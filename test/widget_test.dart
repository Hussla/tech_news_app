/// Widget tests for the Tech News application's main components.
/// 
/// This test suite validates the basic functionality of the app's core widgets,
/// ensuring that the application loads correctly and displays the expected UI
/// elements when running in test mode.
/// 
/// The tests use Firebase Auth mocking and network image stubbing to avoid
/// authentication and image loading issues during testing.
///
/// References:
/// - [Widget Testing](https://docs.flutter.dev/testing/widget-tests)
/// - [WidgetTester Class](https://api.flutter.dev/flutter/flutter_test/WidgetTester-class.html)
/// - [Firebase Auth Testing](https://firebase.flutter.dev/docs/auth/usage/#testing)
/// - [Network Image Mocking](https://pub.dev/packages/network_image_mock)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'test_setup.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await setupTestEnvironment();
      
      // Build our app using the test helper
      await tester.pumpWidget(createTestMyApp());
      await tester.pumpAndSettle();

      // Verify that the login screen loads (since no user is signed in)
      expect(find.text('Continue as Guest'), findsOneWidget);
      
      // Test guest login flow
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // After guest login, we should see the main app interface
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
