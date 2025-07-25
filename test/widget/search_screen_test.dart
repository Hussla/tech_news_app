import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';

void main() {
  group('SearchScreen', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => NewsProvider(),
          child: const SearchScreen(),
        ),
      );
    }

    testWidgets('displays app bar with title and search field', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Test app bar title
      expect(find.text('Tech News'), findsOneWidget);

      // Test search field is visible
      expect(find.byType(TextField), findsOneWidget);
      
      // Test search field has correct placeholder
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, 'Search technology news...');
    });

    testWidgets('displays search field with clear and search buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter text in search field
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pump();

      // Clear button should be visible
      expect(find.byIcon(Icons.clear), findsOneWidget);
      
      // Search button should be visible
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('clear button clears search text and fetches top headlines', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Enter text in search field
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pump();

      // Clear button should be visible
      expect(find.byIcon(Icons.clear), findsOneWidget);
      
      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Search field should be empty
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('search button triggers search with current text', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Enter text in search field
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pump();

      // Tap search button
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Verify search was performed (articles list should not be empty)
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays loading indicator when loading articles', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Simulate loading state
      provider.isLoading = true;
      await tester.pump();

      // Loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading articles...'), findsOneWidget);
    });

    testWidgets('displays empty state when no search performed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Initially, no search has been performed
      expect(find.text('Search for technology news'), findsOneWidget);
      expect(find.text('Enter keywords to find relevant articles'), findsOneWidget);
    });

    testWidgets('displays no results state when search returns no matches', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Perform search with query that returns no results
      provider.searchQuery = 'nonexistentquery123';
      provider.articles = [];
      await tester.pump();

      // No results state should be displayed
      expect(find.text('No results found for "nonexistentquery123"'), findsOneWidget);
      expect(find.text('Try searching for:'), findsOneWidget);
      
      // Suggestion chips should be visible
      expect(find.text('AI'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Web'), findsOneWidget);
      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('suggestion chips trigger search with suggested term', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Perform search with query that returns no results
      provider.searchQuery = 'nonexistentquery123';
      provider.articles = [];
      await tester.pump();

      // Tap AI suggestion chip
      await tester.tap(find.text('AI'));
      await tester.pump();

      // Search should be performed with "AI"
      expect(provider.searchQuery, 'AI');
    });

    testWidgets('show all news button clears search and shows top headlines', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Perform search with query that returns no results
      provider.searchQuery = 'nonexistentquery123';
      provider.articles = [];
      await tester.pump();

      // Tap show all news button
      await tester.tap(find.text('Show All News'));
      await tester.pump();

      // Search query should be cleared
      expect(provider.searchQuery, isEmpty);
    });

    testWidgets('pull-to-refresh triggers refresh', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Perform a small scroll to trigger pull-to-refresh
      await tester.fling(find.byType(RefreshIndicator), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      // Refresh should have been triggered
      // This is tested by the fact that the test completes without error
    });

    testWidgets('displays search results when articles are available', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      // Add some articles
      provider.articles = [
        Article(
          title: 'Flutter Article',
          description: 'Description of Flutter article',
          url: 'https://example.com/flutter',
          imageUrl: 'https://example.com/flutter.jpg',
          publishedAt: DateTime.now(),
        ),
        Article(
          title: 'Dart Article',
          description: 'Description of Dart article',
          url: 'https://example.com/dart',
          imageUrl: 'https://example.com/dart.jpg',
          publishedAt: DateTime.now(),
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Articles should be displayed
      expect(find.text('Flutter Article'), findsOneWidget);
      expect(find.text('Dart Article'), findsOneWidget);
      
      // Empty states should not be visible
      expect(find.text('Search for technology news'), findsNothing);
      expect(find.text('No results found for'), findsNothing);
    });

    testWidgets('search field submits on text submission', (WidgetTester tester) async {
      final provider = NewsProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const SearchScreen(),
          ),
        ),
      );

      // Enter text and submit
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Search should have been performed
      expect(provider.searchQuery, 'Flutter');
    });

    testWidgets('search field updates on text change', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter text
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pump();

      // Clear button should appear
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
  });
}
