/// ArticleCard widget tests for the Tech News application.
/// 
/// This test file validates the ArticleCard's functionality including:
/// - Display of article title, description, and publication date
/// - Bookmark button display and state
/// - Image display and handling of missing images
/// - Handling of missing descriptions
/// - Navigation to article detail screen
/// - Bookmark state toggling
/// - Text styling and overflow handling
/// - Padding and margin
/// - Hero animation with correct tag
/// 
/// The tests use a NewsProvider to manage the saved articles state.
/// 
/// References:
/// - [Widget Testing](https://docs.flutter.dev/testing/widget-tests)
/// - [Testing User Interactions](https://docs.flutter.dev/testing/user-interaction)
/// - [Hero Animations](https://docs.flutter.dev/ui/animations/hero-animations)
/// - [Text Overflow](https://api.flutter.dev/flutter/painting/TextOverflow-class.html)
/// - [Image Widget](https://api.flutter.dev/flutter/widgets/Image-class.html)
/// - [InkWell](https://api.flutter.dev/flutter/material/InkWell-class.html)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/models/article.dart';
import 'package:tech_news_app/widgets/article_card.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import '../helpers/mock_news_provider.dart';
import 'package:flutter/services.dart';

void main() {
  group('ArticleCard', () {
    final testArticle = Article(
      title: 'Test Article Title',
      description: 'Test article description that is moderately long to test text overflow',
      url: 'https://example.com/test',
      imageUrl: 'https://example.com/image.jpg',
      publishedAt: DateTime(2023, 1, 15, 10, 30, 0),
    );

    final testArticleWithoutImage = Article(
      title: 'Article Without Image',
      description: 'This article has no image URL',
      url: 'https://example.com/no-image',
      imageUrl: null,
      publishedAt: DateTime(2023, 1, 15, 10, 30, 0),
    );

    final testArticleWithoutDescription = Article(
      title: 'Article Without Description',
      description: null,
      url: 'https://example.com/no-description',
      imageUrl: 'https://example.com/image.jpg',
      publishedAt: DateTime(2023, 1, 15, 10, 30, 0),
    );

    Widget createWidgetUnderTest(Article article, {bool showSaveButton = true}) {
      return MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<NewsProvider>.value(
            value: MockNewsProvider(),
            child: ArticleCard(
              article: article,
              showSaveButton: showSaveButton,
            ),
          ),
        ),
      );
    }

    testWidgets('displays article title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      expect(find.text(testArticle.title), findsOneWidget);
    });

    testWidgets('displays article description', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      expect(find.text(testArticle.description!), findsOneWidget);
    });

    testWidgets('displays formatted publication date', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      // Test that publication date is displayed
      expect(find.byIcon(Icons.access_time), findsOneWidget);
      
      // Test that the date is formatted correctly (e.g., "2 hours ago")
      final textFinder = find.textContaining('ago');
      expect(textFinder, findsOneWidget);
    });

    testWidgets('displays bookmark button when showSaveButton is true', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle, showSaveButton: true));

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('does not display bookmark button when showSaveButton is false', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle, showSaveButton: false));

      expect(find.byIcon(Icons.bookmark_border), findsNothing);
    });

    testWidgets('displays image when imageUrl is provided', (WidgetTester tester) async {
      // Create a transparent image for testing
      final testImage = Uint8List.fromList([
        // 1x1 transparent PNG
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
        0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
        0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0xDA, 0x62, 0x60, 0x60, 0x60, 0x00,
        0x00, 0x00, 0x04, 0x00, 0x01, 0x27, 0x11, 0x81, 0x8E, 0x00, 0x00, 0x00,
        0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
      ]);
      
      // Mock the image network request
      tester.binding.imageCache.clear();
      tester.binding.imageCache.clearLiveImages();
      
      // Set up the mock message handler
      tester.binding.defaultBinaryMessenger.setMockMessageHandler('flutter/io.dart', (message) async {
        final methodCall = const StandardMethodCodec().decodeMethodCall(message);
        if (methodCall.method == 'ImageCache.putIfAbsent') {
          final arguments = methodCall.arguments as Map<String, dynamic>;
          final key = arguments['key'] as String;
          if (key.contains(testArticle.imageUrl!)) {
            return ByteData(8)..setInt32(0, 100)..setInt32(4, 100);
          }
        }
        return null;
      });

      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      // Give the widget time to build
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);

      // Clean up
      tester.binding.defaultBinaryMessenger.setMockMessageHandler('flutter/io.dart', null);
    });

    testWidgets('handles missing image gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticleWithoutImage));

      // Give the widget time to build
      await tester.pump();

      // Should not show image
      expect(find.byType(Image), findsNothing);
      
      // Should show placeholder
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
      expect(find.text('Image not available'), findsOneWidget);
    });

    testWidgets('handles missing description gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticleWithoutDescription));

      // Should not show description
      expect(find.text(''), findsNothing);
      
      // Should still show other elements
      expect(find.text(testArticleWithoutDescription.title), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('displays correct bookmark icon state when article is saved', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.saveArticle(testArticle);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<NewsProvider>.value(
              value: provider,
              child: ArticleCard(
                article: testArticle,
                showSaveButton: true,
              ),
            ),
          ),
        ),
      );

      // Should show filled bookmark icon
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('displays correct bookmark icon state when article is not saved', (WidgetTester tester) async {
      final provider = MockNewsProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<NewsProvider>.value(
              value: provider,
              child: ArticleCard(
                article: testArticle,
                showSaveButton: true,
              ),
            ),
          ),
        ),
      );

      // Should show outlined bookmark icon
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('tapping card navigates to NewsDetailScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      // Tap the card using a more specific finder
      await tester.tap(find.descendant(
        of: find.byType(Card),
        matching: find.byType(InkWell),
      ).first);
      await tester.pumpAndSettle();

      // Should navigate to NewsDetailScreen
      expect(find.text('Article'), findsOneWidget);
    });

    testWidgets('tapping bookmark button toggles save state', (WidgetTester tester) async {
      final provider = MockNewsProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<NewsProvider>.value(
              value: provider,
              child: ArticleCard(
                article: testArticle,
                showSaveButton: true,
              ),
            ),
          ),
        ),
      );

      // Initially not saved
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

      // Tap bookmark button
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pump();

      // Should now be saved
      expect(find.byIcon(Icons.bookmark), findsOneWidget);

      // Tap bookmark button again
      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pump();

      // Should now be unsaved
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('applies proper text styling and overflow handling', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

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
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      final cardFinder = find.byType(Card);
      final card = tester.widget<Card>(cardFinder);

      // Test card margin
      expect(card.margin, const EdgeInsets.symmetric(horizontal: 16, vertical: 8));

      // Test padding inside card - look for the specific padding around the content
      final paddingFinder = find.descendant(
        of: find.byType(Card),
        matching: find.widgetWithText(Padding, testArticle.title),
      );
      expect(paddingFinder, findsOneWidget);
    });

    testWidgets('displays hero animation with correct tag', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      // Should have a Hero widget with the article URL as tag
      final heroFinder = find.descendant(
        of: find.byType(Card),
        matching: find.byType(Hero),
      );
      expect(heroFinder, findsOneWidget);

      final hero = tester.widget<Hero>(heroFinder);
      expect(hero.tag, testArticle.url);
    });
  });
}
