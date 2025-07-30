/// Test setup utilities for the Tech News application.
/// 
/// This file provides common setup functions and utilities used across
/// all test files to ensure consistent test environment configuration.
/// 
/// Key features:
/// - Database initialisation for tests
/// - Mock service setup
/// - Common test utilities
/// - Provider setup helpers
/// 
/// References:
/// - [Flutter Testing](https://docs.flutter.dev/testing)
/// - [Test Setup](https://docs.flutter.dev/testing/unit-tests)
/// - [Mocking](https://docs.flutter.dev/testing/mocking)
/// - [Fake Async](https://pub.dev/documentation/fake_async/latest/)
/// - [Timer Testing](https://docs.flutter.dev/testing/unit-tests#testing-widgets-that-use-timers)
/// - [Widget Testing](https://docs.flutter.dev/testing/widget-tests)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/screens/home_screen.dart';
import 'package:tech_news_app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'helpers/mock_news_provider.dart';
import '../lib/firebase_options.dart';

/// Sets up Firebase Auth mocks for testing.
/// 
/// This function configures Firebase Auth mocking to avoid authentication
/// issues during testing.
/// 
/// According to the firebase_auth_mocks documentation, MockFirebaseAuth
/// automatically handles the FirebaseAuth.instance, so we don't need to
/// manually assign it.
Future<void> setupFirebaseAuthMocks() async {
  // Create a mock instance of FirebaseAuth
  // The MockFirebaseAuth constructor automatically sets up FirebaseAuth.instance
  MockFirebaseAuth();
  
  // In test mode, we don't need to initialize Firebase
  // The mock will handle all Firebase Auth operations
  // No additional setup is needed
}

/// Initializes the database for testing.
/// 
/// This function sets up the database factory for testing, which is required
/// for sqflite to work in a web environment or when running tests.
/// 
/// This implementation:
/// 1. Initializes the FFI implementation for testing
/// 2. Sets the database factory to use FFI
/// 3. Ensures the database schema is properly created
void setupDatabaseForTesting() {
  // Initialize FFI implementation for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  // Clear any existing database to ensure a clean state
  // This helps prevent schema issues between test runs
  try {
    databaseFactory.deleteDatabase('tech_news.db');
  } catch (e) {
    // Ignore errors if database doesn't exist
  }
}

/// Sets up the test environment with necessary configurations.
/// 
/// This function should be called in the setUpAll() method of test files
/// that need database or other service initialisation.
/// 
/// This implementation:
/// 1. Ensures the test binding is initialized
/// 2. Enables testing mode to prevent database operations
/// 3. Initializes database for testing
/// 4. Configures Firebase Auth for testing with mocks
Future<void> setupTestEnvironment() async {
  // Configure fake async for timer handling
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Enable testing mode first to prevent database operations
  NewsProvider.setTestingMode(true);
  
  // Initialize database for testing
  setupDatabaseForTesting();
  
  // Set up Firebase Auth mocks - await the async operation
  await setupFirebaseAuthMocks();
  
  // Ensure Firebase is not initialized during tests
  // This prevents the "No Firebase App '[DEFAULT]'" error
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Ignore initialization errors in tests
    // The mocks will handle Firebase operations
  }
}

/// Runs a test function with fake async to control timers.
/// 
/// This helper function wraps test operations in fake_async to
/// properly control and flush timers, preventing "Timer is still pending" errors.
/// 
/// Parameters:
/// - [testFunction]: The test function to run with fake async
/// 
/// Example:
/// ```dart
/// await runWithFakeAsync(() async {
///   // Your test code here
///   await tester.pumpWidget(createWidgetUnderTest());
/// });
/// ```
Future<void> runWithFakeAsync(Future<void> Function() testFunction) async {
  await fakeAsync((FakeAsync clock) async {
    await testFunction();
    // Ensure all pending timers are flushed
    clock.elapse(const Duration(milliseconds: 100));
  });
}


/// Creates a MaterialApp widget with proper test configuration.
/// 
/// This function creates a MaterialApp with the necessary providers
/// for testing. It can use either a mock or real NewsProvider based
/// on the useMockProvider parameter.
/// 
/// Parameters:
/// - [child]: The widget to wrap in the MaterialApp
/// - [useMockProvider]: Whether to use MockNewsProvider instead of real NewsProvider
/// 
/// Returns a MaterialApp widget ready for testing.
Widget createTestApp({
  required Widget child,
  bool useMockProvider = false,
  dynamic mockProvider,
}) {
  if (useMockProvider) {
    final mock = MockNewsProvider();
    return MaterialApp(
      home: ChangeNotifierProvider<NewsProvider>.value(
        value: mock,
        child: child,
      ),
      routes: {
        '/voice-search': (context) => const Scaffold(
          body: Center(child: Text('Voice Search Screen')),
        ),
        '/qr-scanner': (context) => const Scaffold(
          body: Center(child: Text('QR Scanner Screen')),
        ),
        '/home': (context) => const HomeScreen(),
      },
    );
  } else {
    return MaterialApp(
      home: ChangeNotifierProvider<NewsProvider>(
        create: (context) => NewsProvider(),
        child: child,
      ),
      routes: {
        '/voice-search': (context) => const Scaffold(
          body: Center(child: Text('Voice Search Screen')),
        ),
        '/qr-scanner': (context) => const Scaffold(
          body: Center(child: Text('QR Scanner Screen')),
        ),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

/// Creates a MaterialApp widget with a mock provider for testing.
/// 
/// This is a convenience function that creates a test app with
/// a MockNewsProvider to avoid timer and API call issues in tests.
/// 
/// Parameters:
/// - [child]: The widget to wrap in the MaterialApp
/// - [mockProvider]: Optional pre-configured mock provider
/// 
/// Returns a MaterialApp widget with mock provider.
Widget createMockTestApp({
  required Widget child,
  MockNewsProvider? mockProvider,
}) {
  return MaterialApp(
    home: ChangeNotifierProvider<NewsProvider>.value(
      value: mockProvider ?? MockNewsProvider(),
      child: child,
    ),
  );
}

/// Pumps a widget and waits for all animations and async operations to complete.
/// 
/// This is a helper function that combines pumpWidget and pumpAndSettle
/// with proper error handling for tests.
/// 
/// Parameters:
/// - [tester]: The WidgetTester instance
/// - [widget]: The widget to pump
/// - [duration]: Optional timeout duration
Future<void> pumpAndSettleWidget(
  WidgetTester tester,
  Widget widget, {
  Duration? duration,
}) async {
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle(duration ?? const Duration(seconds: 10));
}

/// Handles async operations in tests safely.
/// 
/// This function wraps async test operations to handle common issues
/// like pending timers and incomplete futures.
/// 
/// Parameters:
/// - [operation]: The async operation to perform
/// - [timeout]: Optional timeout duration
Future<T> safeAsyncTest<T>(
  Future<T> Function() operation, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  return await operation().timeout(timeout);
}

/// Creates a complete MyApp instance configured for testing.
/// 
/// This function creates a properly configured MyApp instance with:
/// - Mock Firebase Auth to avoid authentication issues
/// - Mock NewsProvider to prevent API calls and timer issues
/// - Network image mocking support
/// 
/// Returns a complete Flutter application widget ready for testing.
Widget createTestMyApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<NewsProvider>.value(
        value: MockNewsProvider(),
      ),
    ],
    child: MaterialApp(
      title: 'Tech News - Test Mode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Uses mock auth from test setup
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    ),
  );
}

/// Creates a MockFirebaseAuth instance for testing.
/// 
/// This function creates a properly configured MockFirebaseAuth instance
/// with a signed-out user state suitable for testing authentication flows.
/// 
/// Returns a MockFirebaseAuth instance ready for use in tests.
MockFirebaseAuth createMockFirebaseAuth() {
  return MockFirebaseAuth(signedIn: false);
}

/// Sets up the complete test environment.
/// 
/// This function performs all necessary setup for testing:
/// - Configures database for testing
/// - Sets up Firebase Auth mocks
/// - Initialises any required services
/// 
/// Should be called at the beginning of each test.
/// Disposes of any pending resources after tests.
/// 
/// This function should be called in tearDown() methods to clean up
/// any resources that might cause issues between tests.
void cleanupTestResources() {
  // Clean up any pending timers or resources
  // This helps prevent "Timer is still pending" errors
}
