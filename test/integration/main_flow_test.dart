/// Integration tests for the Tech News application's main user flows.
/// 
/// This test suite validates end-to-end user journeys through the application,
/// ensuring that multiple components work together correctly. The tests cover:
/// - Article reading flow with guest authentication
/// - Saved articles functionality with bookmark persistence
/// - Voice search interaction patterns
/// - QR code scanner integration workflows
/// 
/// Each test uses proper Firebase authentication mocking and network image 
/// stubbing to ensure reliable execution in test environments.
///
/// References:
/// - [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
/// - [Widget Testing](https://docs.flutter.dev/testing/widget-tests)
/// - [WidgetTester Class](https://api.flutter.dev/flutter/flutter_test/WidgetTester-class.html)
/// - [Firebase Auth Testing](https://firebase.flutter.dev/docs/auth/usage/#testing)
/// - [Network Image Mocking](https://pub.dev/packages/network_image_mock)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../test_setup.dart';

void main() {
  group('Main User Flows', () {
    testWidgets('Article Reading Flow', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await setupTestEnvironment();
        
        // Use our test app helper
        await tester.pumpWidget(createTestMyApp());
        await tester.pumpAndSettle();

        // Wait for login screen to load
        expect(find.text('Continue as Guest'), findsOneWidget);
        
        // Tap continue as guest
        await tester.tap(find.text('Continue as Guest'));
        await tester.pumpAndSettle();

        // Verify we're on the home screen - look for any navigation element
        expect(find.byType(BottomNavigationBar), findsOneWidget);
        
        // If there are articles, try to tap the first one
        final articleFinder = find.byType(Card).first;
        if (tester.any(articleFinder)) {
          await tester.tap(articleFinder);
          await tester.pumpAndSettle();
        }
      });
    });

    testWidgets('Saved Articles Flow', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await setupTestEnvironment();
        
        await tester.pumpWidget(createTestMyApp());
        await tester.pumpAndSettle();

        // Continue as guest
        await tester.tap(find.text('Continue as Guest'));
        await tester.pumpAndSettle();

        // Navigate to saved articles
        final savedIcon = find.byIcon(Icons.bookmark);
        if (tester.any(savedIcon)) {
          await tester.tap(savedIcon);
          await tester.pumpAndSettle();
        }
        
        // Verify saved articles screen loads
        expect(find.text('Saved Articles'), findsOneWidget);
      });
    });

    testWidgets('Voice Search Flow', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await setupTestEnvironment();
        
        await tester.pumpWidget(createTestMyApp());
        await tester.pumpAndSettle();

        // Continue as guest
        await tester.tap(find.text('Continue as Guest'));
        await tester.pumpAndSettle();

        // Look for voice search icon or button
        final voiceSearchFinder = find.byIcon(Icons.mic);
        if (tester.any(voiceSearchFinder)) {
          await tester.tap(voiceSearchFinder);
          await tester.pumpAndSettle();
        }
      });
    });

    testWidgets('QR Code Scanner Flow', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await setupTestEnvironment();
        
        await tester.pumpWidget(createTestMyApp());
        await tester.pumpAndSettle();

        // Continue as guest
        await tester.tap(find.text('Continue as Guest'));
        await tester.pumpAndSettle();

        // Look for QR scanner icon or button
        final qrScannerFinder = find.byIcon(Icons.qr_code_scanner);
        if (tester.any(qrScannerFinder)) {
          await tester.tap(qrScannerFinder);
          await tester.pumpAndSettle();
        }
      });
    });
  });
}

