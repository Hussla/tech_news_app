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
          body: ChangeNotifierProvider(
            create: (context) => NewsProvider(),
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
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      // Wait for image to load
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('handles missing image gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticleWithoutImage));

      // Wait for potential image loading
      await tester.pumpAndSettle();

      // Should not show image
      expect(find.byType(Image), findsNothing);
      
      // Should show placeholder
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
      expect(find.text('Image not available'), findsOneWidget);
    });

    testWidgets('handles missing description gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticleWithoutDescription));

      // Should not show description
      expect(find.text(testArticleWithoutDescription.description!), findsNothing);
      
      // Should still show other elements
      expect(find.text(testArticleWithoutDescription.title), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('displays correct bookmark icon state when article is saved', (WidgetTester tester) async {
      final provider = NewsProvider();
      provider.saveArticle(testArticle);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
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
      final provider = NewsProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
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

      // Tap the card
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Should navigate to NewsDetailScreen
      expect(find.text('Article'), findsOneWidget);
    });

    testWidgets('tapping bookmark button toggles save state', (WidgetTester tester) async {
      final provider = NewsProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
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
      await tester.pumpAndSettle();

      // Should now be saved
      expect(find.byIcon(Icons.bookmark), findsOneWidget);

      // Tap bookmark button again
      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();

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

      // Test padding inside card
      final paddingFinder = find.descendant(
        of: find.byType(Card),
        matching: find.byType(Padding),
      );
      expect(paddingFinder, findsOneWidget);
    });

    testWidgets('displays hero animation with correct tag', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testArticle));

      // Should have a Hero widget with the article URL as tag
      final heroFinder = find.descendant(
        of: find.byType(Image),
        matching: find.byType(Hero),
      );
      expect(heroFinder, findsOneWidget);

      final hero = tester.widget<Hero>(heroFinder);
      expect(hero.tag, testArticle.url);
    });
  });
}
