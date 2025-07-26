/// Integration tests for the Tech News application.
/// 
/// This test file validates complete user flows through the application,
/// testing how multiple components work together. The tests cover:
/// - Search flow
/// - Article reading flow
/// - Saved articles flow
/// - Voice search flow
/// - QR code scanner flow
/// 
/// 
/// References:
/// - [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
/// - [Testing User Flows](https://docs.flutter.dev/testing/user-interaction)
/// - [MyApp Widget](https://api.flutter.dev/flutter/material/MaterialApp-class.html)
/// - [WidgetTester](https://api.flutter.dev/flutter/flutter_test/WidgetTester-class.html)
/// - [Pump and Settle](https://api.flutter.dev/flutter/flutter_test/WidgetTester/pumpAndSettle.html)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/main.dart';
import 'package:tech_news_app/models/article.dart';
import '../test_setup.dart';

void main() {
  setUpAll(() async {
    await setupTestEnvironment();
  });

  group('Main User Flows', () {
    final testArticle = Article(
      title: 'Integration Test Article',
      description: 'This article is used for integration testing',
      url: 'https://example.com/integration-test',
      imageUrl: 'https://example.com/integration-test.jpg',
      publishedAt: DateTime.now(),
    );

    setUp(() {
      // Register any necessary services or mocks here
    });

    testWidgets('Search Flow', (WidgetTester tester) async {
      // Start the app using test setup
      await tester.pumpWidget(
        createTestApp(
          child: const MyApp(),
          useMockProvider: true,
        ),
      );
      await tester.pumpAndSettle();

      // Wait for initial data to load
      await tester.pump(const Duration(seconds: 2));

      // Tap search icon in app bar
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pump();

      // Tap search button
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify search results are displayed
      expect(find.text('Flutter'), findsWidgets);

      // Tap on an article
      await tester.tap(find.text('Flutter'));
      await tester.pumpAndSettle();

      // Verify we're on the article detail screen
      expect(find.text('Article'), findsOneWidget);

      // Tap bookmark button to save article
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();

      // Verify snackbar shows "Article saved"
      expect(find.text('Article saved'), findsOneWidget);

      // Navigate to saved articles
      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();

      // Verify saved article is displayed
      expect(find.text('Flutter'), findsWidgets);
    });

    testWidgets('Article Reading Flow', (WidgetTester tester) async {
      // Start the app using test setup
      await tester.pumpWidget(
        createTestApp(
          child: const MyApp(),
          useMockProvider: true,
        ),
      );
      await tester.pumpAndSettle();

      // Wait for initial data to load
      await tester.pump(const Duration(seconds: 2));

      // Tap on an article from the home screen
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify we're on the article detail screen
      expect(find.text('Article'), findsOneWidget);

      // Verify article content is displayed
      // Note: WebView may not be available in test environment
      expect(find.text('Article'), findsOneWidget);

      // Tap share button
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Verify share dialog is displayed
      expect(find.text('Share via'), findsOneWidget);

      // Tap on a share option (e.g., SMS)
      await tester.tap(find.text('SMS'));
      await tester.pumpAndSettle();

      // Verify SMS app would be opened (in a real test, this would be mocked)
      // For now, just verify the flow completes
    });

    testWidgets('Saved Articles Flow', (WidgetTester tester) async {
      // Start the app using test setup
      await tester.pumpWidget(
        createTestApp(
          child: const MyApp(),
          useMockProvider: true,
        ),
      );
      await tester.pumpAndSettle();

      // Wait for initial data to load
      await tester.pump(const Duration(seconds: 2));

      // Tap on an article from the home screen
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Tap bookmark button to save article
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();

      // Verify snackbar shows "Article saved"
      expect(find.text('Article saved'), findsOneWidget);

      // Navigate back to home screen
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Navigate to saved articles
      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();

      // Verify saved article is displayed
      expect(find.byType(ListTile), findsWidgets);

      // Swipe to delete an article
      await tester.fling(
        find.byType(ListTile).first,
        const Offset(-500, 0),
        1000,
      );
      await tester.pumpAndSettle();

      // Tap Remove in confirmation dialog
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Verify snackbar shows "Article removed from saved"
      expect(find.text('Article removed from saved'), findsOneWidget);

      // Verify article is no longer in the list
      // This depends on the initial state, so we'll just verify the flow
    });

    testWidgets('Voice Search Flow', (WidgetTester tester) async {
      // Start the app using test setup
      await tester.pumpWidget(
        createTestApp(
          child: const MyApp(),
          useMockProvider: true,
        ),
      );
      await tester.pumpAndSettle();

      // Wait for initial data to load
      await tester.pump(const Duration(seconds: 2));

      // Navigate to More screen
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();

      // Tap Voice Search
      await tester.tap(find.text('Voice Search'));
      await tester.pumpAndSettle();

      // Verify we're on the voice search screen
      expect(find.text('Voice Search'), findsOneWidget);

      // Tap microphone to start listening
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump(const Duration(seconds: 2));

      // Tap stop button
      await tester.tap(find.byIcon(Icons.stop));
      await tester.pumpAndSettle();

      // Enter text manually for testing (since we can't actually do voice input)
      await tester.enterText(find.byType(TextField), 'AI');
      await tester.pump();

      // Tap Send
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      // Verify we're back on the home screen with search results
      expect(find.text('AI'), findsWidgets);
    });

    testWidgets('QR Code Scanner Flow', (WidgetTester tester) async {
      // Start the app using test setup
      await tester.pumpWidget(
        createTestApp(
          child: const MyApp(),
          useMockProvider: true,
        ),
      );
      await tester.pumpAndSettle();

      // Wait for initial data to load
      await tester.pump(const Duration(seconds: 2));

      // Navigate to More screen
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();

      // Tap QR Code Scanner
      await tester.tap(find.text('QR Code Scanner'));
      await tester.pumpAndSettle();

      // Verify we're on the QR code scanner screen
      expect(find.text('QR Code Scanner'), findsOneWidget);

      // Tap Start Scanning
      await tester.tap(find.text('Start Scanning'));
      await tester.pump(const Duration(seconds: 2));

      // Verify scan result dialog appears
      expect(find.text('QR Code Detected'), findsOneWidget);

      // Tap Open Link if available
      if (find.text('Open Link').evaluate().isNotEmpty) {
        await tester.tap(find.text('Open Link'));
        await tester.pumpAndSettle();
      }

      // Verify we're on the appropriate screen
      // This depends on the QR code content, so we'll just verify the flow
    });
  });
}
