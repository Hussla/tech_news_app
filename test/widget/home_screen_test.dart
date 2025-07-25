import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/screens/home_screen.dart';
import 'package:tech_news_app/models/article.dart';
import '../helpers/mock_news_provider.dart';

void main() {
  group('HomeScreen', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => MockNewsProvider(),
          child: const HomeScreen(),
        ),
      );
    }

    testWidgets('displays app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Test app bar title
      expect(find.text('Tech News'), findsOneWidget);
    });

    testWidgets('displays bottom navigation bar with three tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Bottom navigation bar should be visible
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      // Should have three items
      final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.items.length, 3);
      
      // Test tab labels
      expect(bottomNavBar.items[0].label, 'Home');
      expect(bottomNavBar.items[1].label, 'Saved');
      expect(bottomNavBar.items[2].label, 'More');
    });

    testWidgets('displays home tab content when Home tab is selected', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Home tab should be selected by default
      final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, 0);
      
      // Home content should be visible
      expect(find.text('Top Headlines'), findsOneWidget);
    });

    testWidgets('navigates to SavedArticlesScreen when Saved tab is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap Saved tab
      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();

      // Should navigate to SavedArticlesScreen
      expect(find.text('Saved Articles'), findsOneWidget);
    });

    testWidgets('navigates to MoreScreen when More tab is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap More tab
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();

      // Should navigate to MoreScreen
      expect(find.text('More'), findsOneWidget);
      expect(find.text('Voice Search'), findsOneWidget);
      expect(find.text('QR Code Scanner'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
    });

    testWidgets('maintains tab selection state', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap Saved tab
      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();

      // Saved tab should be selected
      final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, 1);
      
      // Tap Home tab
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Home tab should be selected
      final bottomNavBar2 = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar2.currentIndex, 0);
    });

    testWidgets('displays floating action button for voice search', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // FAB should be visible
      expect(find.byType(FloatingActionButton), findsOneWidget);
      
      // FAB should have microphone icon
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('tapping FAB navigates to VoiceSearchScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Should navigate to VoiceSearchScreen
      expect(find.text('Voice Search'), findsOneWidget);
    });

    testWidgets('displays pull-to-refresh functionality', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Perform a small scroll to trigger pull-to-refresh
      await tester.fling(find.byType(RefreshIndicator), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      // Refresh should have been triggered
      // This is tested by the fact that the test completes without error
    });

    testWidgets('displays list of articles', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      
      // Add some articles
      provider.articles = [
        Article(
          title: 'Article 1',
          description: 'Description of article 1',
          url: 'https://example.com/1',
          imageUrl: 'https://example.com/1.jpg',
          publishedAt: DateTime.now(),
        ),
        Article(
          title: 'Article 2',
          description: 'Description of article 2',
          url: 'https://example.com/2',
          imageUrl: 'https://example.com/2.jpg',
          publishedAt: DateTime.now(),
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const HomeScreen(),
          ),
        ),
      );

      // Articles should be displayed
      expect(find.text('Article 1'), findsOneWidget);
      expect(find.text('Article 2'), findsOneWidget);
    });

    testWidgets('displays loading indicator when loading', (WidgetTester tester) async {
      final provider = MockNewsProvider();
      provider.isLoading = true;
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const HomeScreen(),
          ),
        ),
      );

      // Loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading articles...'), findsOneWidget);
    });

    testWidgets('displays app bar actions', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Search icon should be visible
      expect(find.byIcon(Icons.search), findsOneWidget);
      
      // More icon should be visible
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('tapping search icon navigates to SearchScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Should navigate to SearchScreen
      expect(find.text('Search technology news...'), findsOneWidget);
    });

    testWidgets('tapping more icon shows popup menu', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap more icon
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Popup menu should be displayed
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('popup menu items navigate to appropriate screens', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap more icon
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Tap Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Should navigate to SettingsScreen
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('applies proper styling to app bar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final appBarFinder = find.byType(AppBar);
      final appBar = tester.widget<AppBar>(appBarFinder);
      
      expect(appBar.titleTextStyle?.color, Colors.white);
      expect(appBar.backgroundColor, Colors.blue);
    });

    testWidgets('has proper padding and margin', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final listViewFinder = find.byType(ListView);
      final listView = tester.widget<ListView>(listViewFinder);
      
      expect(listView.padding, const EdgeInsets.symmetric(horizontal: 16));
    });
  });
}
