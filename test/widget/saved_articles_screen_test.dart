/// SavedArticlesScreen widget tests for the Tech News application.
/// 
/// This test file validates the SavedArticlesScreen's functionality including:
/// - App bar display with title
/// - Empty state display when no articles saved
/// - List of saved articles display
/// - Publication date formatting
/// - Navigation to NewsDetailScreen
/// - Swipe to delete with confirmation dialog
/// - Clear all button with confirmation dialog
/// - Snackbar with undo option
/// - UI styling and layout
/// 
/// 
/// References:
/// - [Widget Testing](https://docs.flutter.dev/testing/widget-tests)
/// - [Testing User Interactions](https://docs.flutter.dev/testing/user-interaction)
/// - [Dismissible Widget](https://api.flutter.dev/flutter/widgets/Dismissible-class.html)
/// - [AlertDialog](https://api.flutter.dev/flutter/material/AlertDialog-class.html)
/// - [Snackbar](https://api.flutter.dev/flutter/material/SnackBar-class.html)
/// - [Card Widget](https://api.flutter.dev/flutter/material/Card-class.html)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/screens/saved_articles_screen.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/models/article.dart';
import '../test_setup.dart';
import '../helpers/mock_news_provider.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  setUpAll(() async {
    await setupTestEnvironment();
  });

  tearDown(() {
    cleanupTestResources();
  });

  group('SavedArticlesScreen', () {
    final testArticle = Article(
      title: 'Saved Article',
      description: 'This article is saved for offline reading',
      url: 'https://example.com/saved',
      imageUrl: 'https://via.placeholder.com/200x300',
      publishedAt: DateTime(2023, 1, 15, 10, 30, 0),
    );

    Widget createWidgetUnderTest() {
      return createMockTestApp(
        child: const SavedArticlesScreen(),
      );
    }

    testWidgets('displays app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Test app bar title
      expect(find.text('Saved Articles'), findsOneWidget);
    });

    testWidgets('displays empty state when no articles saved', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Empty state should be displayed
      expect(find.text('No saved articles yet'), findsOneWidget);
      expect(find.text('Save articles from search results to read later'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('displays list of saved articles when articles are saved', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Article should be displayed
      expect(find.text(testArticle.title), findsOneWidget);
      expect(find.text(testArticle.description!), findsOneWidget);
    });

    testWidgets('displays formatted publication date', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Publication date should be displayed
      expect(find.byIcon(Icons.access_time), findsOneWidget);
      
      // Date should be formatted correctly
      final textFinder = find.textContaining('ago');
      expect(textFinder, findsOneWidget);
    });

    testWidgets('tapping article navigates to NewsDetailScreen', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.articles = [testArticle];
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );

        // Allow time for the widget to build
        await tester.pump(const Duration(milliseconds: 100));

        // Verify we start on SavedArticlesScreen
        expect(find.text('Saved Articles'), findsOneWidget);
        expect(find.text(testArticle.title), findsOneWidget);

        // Tap on article
        await tester.tap(find.text(testArticle.title));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should navigate to NewsDetailScreen
        expect(find.text('Article'), findsOneWidget, reason: 'AppBar title should be "Article"');
        expect(find.text(testArticle.title), findsOneWidget, reason: 'Article title should be displayed');
        expect(find.textContaining('Published on'), findsOneWidget, reason: 'Publication date should be displayed');
        expect(find.text('Read Full Article'), findsOneWidget, reason: 'Read Full Article button should be displayed');
        expect(find.byIcon(Icons.share), findsOneWidget, reason: 'Share icon should be displayed');
      });
    }, timeout: Timeout(Duration(seconds: 120)));

    testWidgets('swipe to delete shows confirmation dialog', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Allow time for animations
      await tester.pumpAndSettle();

      // Swipe to delete
      await tester.fling(
        find.text(testArticle.title),
        const Offset(-500, 0),
        1000,
      );
      
      // Allow time for swipe animation
      await tester.pumpAndSettle();

      // Confirmation dialog should be displayed
      expect(find.text('Remove from saved?'), findsOneWidget);
      expect(find.text('Are you sure you want to remove this article from your saved articles?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    testWidgets('confirmation dialog cancels deletion when Cancel is tapped', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Allow time for animations
      await tester.pumpAndSettle();

      // Swipe to delete
      await tester.fling(
        find.text(testArticle.title),
        const Offset(-500, 0),
        1000,
      );
      
      // Allow time for swipe animation
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Article should still be in the list
      expect(find.text(testArticle.title), findsOneWidget);
      expect(provider.savedArticles.length, 1);
    });

    testWidgets('confirmation dialog removes article when Remove is tapped', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Allow time for animations
      await tester.pumpAndSettle();

      // Swipe to delete
      await tester.fling(
        find.text(testArticle.title),
        const Offset(-500, 0),
        1000,
      );
      
      // Allow time for swipe animation
      await tester.pumpAndSettle();

      // Tap Remove
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Article should be removed
      expect(find.text(testArticle.title), findsNothing);
      expect(provider.savedArticles.length, 0);
    });

    testWidgets('clear all button shows confirmation dialog', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Tap clear all button (icon button)
      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      // Confirmation dialog should be displayed
      expect(find.text('Clear All Saved Articles'), findsOneWidget);
      expect(find.text('Are you sure you want to remove all saved articles? This action cannot be undone.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
    });

    testWidgets('clear all confirmation dialog cancels when Cancel is tapped', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Tap clear all button (icon button)
      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Article should still be in the list
      expect(find.text(testArticle.title), findsOneWidget);
      expect(provider.savedArticles.length, 1);
    });

    testWidgets('clear all confirmation dialog removes all articles when Clear All is tapped', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Tap clear all button (icon button)
      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      // Tap Clear All in dialog
      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      // Article should be removed
      expect(find.text(testArticle.title), findsNothing);
      expect(provider.savedArticles.length, 0);
    });

    testWidgets('shows snackbar with undo option after deletion', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Swipe to delete
      await tester.fling(
        find.text(testArticle.title),
        const Offset(-500, 0),
        1000,
      );
      await tester.pumpAndSettle();

      // Tap Remove
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Snackbar should be displayed with undo option
      expect(find.text('Article removed from saved'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets('undo snackbar restores deleted article', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Swipe to delete
      await tester.fling(
        find.text(testArticle.title),
        const Offset(-500, 0),
        1000,
      );
      await tester.pumpAndSettle();

      // Tap Remove
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Tap Undo
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();

      // Article should be restored
      expect(find.text(testArticle.title), findsOneWidget);
      expect(provider.savedArticles.length, 1);
    });

    testWidgets('applies proper styling to list items', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      // Test title styling
      final titleFinder = find.text(testArticle.title);
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.maxLines, 2);
      expect(titleWidget.overflow, TextOverflow.ellipsis);

      // Test description styling
      final descriptionFinder = find.text(testArticle.description!);
      final descriptionWidget = tester.widget<Text>(descriptionFinder);
      expect(descriptionWidget.style?.color, Colors.grey.shade600);
      expect(descriptionWidget.maxLines, 2);
      expect(descriptionWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('has proper padding and margin', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.savedArticles = [testArticle];
      
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createMockTestApp(
            child: const SavedArticlesScreen(),
            mockProvider: provider,
          ),
        );
      });

      final cardFinder = find.byType(Card);
      final card = tester.widget<Card>(cardFinder);

      // Test card margin
      expect(card.margin, const EdgeInsets.symmetric(horizontal: 16, vertical: 8));
    });
  });
}
