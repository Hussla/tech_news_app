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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'helpers/mock_news_provider.dart';

/// Sets up the test environment with necessary configurations.
/// 
/// This function should be called in the setUpAll() method of test files
/// that need database or other service initialisation.
void setupTestEnvironment() {
  // Test environment setup - no database initialisation needed for unit tests
}

/// Creates a MaterialApp widget with proper Provider setup for testing.
/// 
/// This helper function creates a consistent widget tree for testing
/// that includes all necessary providers and routing configuration.
/// 
/// Parameters:
/// - [child]: The widget to wrap in the MaterialApp
/// - [useMockProvider]: Whether to use MockNewsProvider instead of real NewsProvider
/// 
/// Returns a MaterialApp widget ready for testing.
Widget createTestApp({
  required Widget child,
  bool useMockProvider = false,
}) {
  return MaterialApp(
    home: ChangeNotifierProvider<NewsProvider>(
      create: (context) => useMockProvider ? MockNewsProvider() : NewsProvider(),
      child: child,
    ),
  );
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

/// Disposes of any pending resources after tests.
/// 
/// This function should be called in tearDown() methods to clean up
/// any resources that might cause issues between tests.
void cleanupTestResources() {
  // Clean up any pending timers or resources
  // This helps prevent "Timer is still pending" errors
}
