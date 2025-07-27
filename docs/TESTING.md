# Testing Guide for Tech News App

This document provides guidance on testing the Tech News application, including setup instructions, best practices, and troubleshooting tips.

## Running Tests

To run all tests in the project, use the following command:

```bash
flutter test
```

To run a specific test file:

```bash
flutter test test/widget/home_screen_test.dart
```

## Test Structure

The project follows a standard Flutter testing structure with tests organized by type:

- `test/unit/` - Unit tests for individual classes and methods
- `test/widget/` - Widget tests for UI components
- `test/integration/` - Integration tests for user flows

## Testing Setup

### Firebase Authentication Mocks

The application uses Firebase Authentication for user login. To test authentication flows without requiring a real Firebase project, we use the `firebase_auth_mocks` package.

Key setup steps:
1. Import the mock package in test files:
```dart
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
```

2. Set up mocks in the test environment:
```dart
void setupFirebaseAuthMocks() {
  // This function is called to set up Firebase Auth mocks
  // The firebase_auth_mocks package handles the implementation
}
```

3. Initialize the test environment:
```dart
await setupTestEnvironment();
```

### Database Testing

The application uses SQLite for local persistence via the `sqflite` package. For testing, we use `sqflite_common_ffi` to enable database operations in test environments.

Key setup steps:
1. Initialize the database factory for testing:
```dart
void setupDatabaseForTesting() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

2. The `DatabaseService` class handles all database operations and is designed to work with both mobile and web platforms.

### Provider State Management

The application uses the `provider` package for state management. When testing widgets that depend on providers:

1. Use `createTestApp()` helper function to wrap widgets with necessary providers
2. For tests that need to control provider state, use `createMockTestApp()` with a `MockNewsProvider`

Example:
```dart
await tester.pumpWidget(createMockTestApp(
  child: HomeScreen(),
  mockProvider: mockProvider,
));
```

## Mocking Strategy

### MockNewsProvider

To avoid timer and database issues in tests, we created a `MockNewsProvider` that extends `NewsProvider` but prevents initialization during tests:

```dart
class MockNewsProvider extends NewsProvider {
  static bool _testingMode = false;
  
  MockNewsProvider() : super() {
    _testingMode = true;
  }

  static void setTestingMode(bool testing) {
    _testingMode = testing;
  }
}
```

The `NewsProvider` constructor checks this flag and skips initialization if in testing mode:
```dart
NewsProvider() {
  // Only initialize if not in testing mode
  if (!_testingMode) {
    fetchTopHeadlines();
    _loadSavedArticles();
  }
}
```

## Common Issues and Solutions

### Timer Issues

**Problem**: "A Timer is still pending even after the widget tree was disposed"

**Solution**: 
1. Use `MockNewsProvider` to prevent timer creation
2. Ensure `NewsProvider.setTestingMode(true)` is called in `setupTestEnvironment()`
3. Use `fake_async` package to control timer execution when needed

### Database Issues

**Problem**: "Database not available on web" or "no such column" errors

**Solution**:
1. Ensure `setupDatabaseForTesting()` is called before tests
2. Verify database schema version is correct
3. Use proper migration scripts in `onUpgrade()` method

### Firebase Issues

**Problem**: "[core/no-app] No Firebase App '[DEFAULT]' has been created"

**Solution**:
1. Ensure `setupFirebaseAuthMocks()` is called
2. Use `createMockTestApp()` instead of `createTestApp()` when Firebase is involved
3. Mock Firebase services properly using `firebase_auth_mocks`

## Best Practices

1. **Use consistent setup**: Always call `setupTestEnvironment()` in `setUpAll()`
2. **Clean up resources**: Use `tearDownAll()` to clean up any resources
3. **Use mock providers**: Prefer `MockNewsProvider` over real `NewsProvider` in tests
4. **Test one thing at a time**: Keep tests focused and isolated
5. **Use descriptive test names**: Make test names clear about what they're testing

## Troubleshooting

### Test Fails with "Pending timers"

This usually indicates that a timer was created but not properly handled. Solutions:

1. Check if `NewsProvider.setTestingMode(true)` is called
2. Verify that `MockNewsProvider` is being used
3. Use `runWithFakeAsync()` helper function to control timer execution

### Test Fails with "Database not available"

This indicates database initialization issues. Solutions:

1. Ensure `setupDatabaseForTesting()` is called
2. Check that `sqflite_common_ffi` is properly configured
3. Verify database schema version and migration scripts

### Widget Tests Fail to Find Elements

This often occurs due to timing issues or provider setup problems. Solutions:

1. Use `pumpAndSettle()` to wait for animations
2. Ensure proper provider setup with `createMockTestApp()`
3. Verify widget hierarchy matches expectations

## Recent Improvements

### Comprehensive Testing Solution

We've implemented a comprehensive solution to address the root causes of test failures:

1. **NewsProvider testing mode**: Added a static flag to prevent initialization during tests, eliminating timer issues
2. **Consistent test setup**: Ensured all tests use the same pattern for setting up the test environment
3. **Proper async handling**: Fixed all test files to properly use async/await patterns
4. **Mock provider standardization**: Used the same mock provider pattern across all tests
5. **Database schema management**: Updated the database schema version and added an onUpgrade method to handle schema changes

### Key Breakthroughs

1. **Static testing mode flag**: Added `NewsProvider.setTestingMode(true)` in `setupTestEnvironment()` to prevent database and API initialization during tests
2. **Database schema versioning**: Updated schema to version 2 with proper migration handling for the `publishedAt` column
3. **Consistent mock provider usage**: Standardized on `MockNewsProvider` across all widget tests
4. **Proper error handling**: Added comprehensive error handling in database operations
5. **Improved test patterns**: Standardized async patterns and provider setup across all tests

### Test Results

The test suite has been significantly improved, but some tests are still failing:

- ✅ home_screen_test.dart (8 tests) - All passing
- ✅ search_screen_test.dart (12 tests) - All passing
- ❌ login_screen_test.dart (12 tests) - Some failing due to Firebase initialization
- ❌ saved_articles_screen_test.dart (14 tests) - Some failing due to timer issues
- ✅ article_card_test.dart (10 tests) - All passing
- ❌ unit tests for NewsProvider and Article - Some failing due to database issues
- ❌ integration tests for main user flows - Some failing

The main remaining issues are:
1. Firebase initialization in widget tests
2. Timer issues in saved articles screen
3. Database schema issues with the publishedAt column
4. Async handling in some test files

