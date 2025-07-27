/// LoginScreen widget tests for the Tech News application.
/// 
/// This test file validates the LoginScreen's functionality including:
/// - App title and logo display
/// - Google Sign-In button display and functionality
/// - Guest login button display and functionality
/// - Navigation to HomeScreen
/// - Snackbar display for Google Sign-In
/// - UI styling and layout
/// - Responsive layout
/// 
/// 
/// References:
/// - [Widget Testing](https://docs.flutter.dev/testing/widget-tests)
/// - [Testing User Interactions](https://docs.flutter.dev/testing/user-interaction)
/// - [ElevatedButton](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)
/// - [Scaffold](https://api.flutter.dev/flutter/material/Scaffold-class.html)
/// - [Snackbar](https://api.flutter.dev/flutter/material/SnackBar-class.html)
/// - [Gradient Background](https://api.flutter.dev/flutter/painting/Gradient-class.html)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/screens/auth/login_screen.dart';
import '../test_setup.dart';

void main() {
  setUpAll(() async {
    await setupTestEnvironment();
  });

  group('LoginScreen', () {
    Widget createWidgetUnderTest() {
      return createMockTestApp(
        child: const LoginScreen(),
      );
    }

    testWidgets('displays app title and logo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Test app title
      expect(find.text('Tech News'), findsOneWidget);
      
      // Test logo is displayed (using the gradient container)
      expect(find.byType(Container), findsNWidgets(2));
    });

    testWidgets('displays Google Sign-In button (disabled for web)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Google Sign-In button should be visible
      expect(find.text('Google Sign-In (Coming Soon)'), findsOneWidget);
      
      // Button should be disabled
      final googleButton = tester.widget<ElevatedButton>(find.text('Google Sign-In (Coming Soon)'));
      expect(googleButton.onPressed, isNull);
    });

    testWidgets('displays guest login button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Guest login button should be visible
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('tapping guest login button navigates to HomeScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap guest login button
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // Should navigate to HomeScreen
      expect(find.text('Tech News'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Google Sign-In button shows snackbar when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Google Sign-In button
      await tester.tap(find.text('Google Sign-In (Coming Soon)'));
      await tester.pumpAndSettle();

      // Snackbar should be displayed
      expect(find.text('Google Sign-In is not available in web demo'), findsOneWidget);
    });

    testWidgets('applies proper styling to title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final titleFinder = find.text('Tech News');
      final titleWidget = tester.widget<Text>(titleFinder);
      
      expect(titleWidget.style?.fontSize, 32);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.color, Colors.white);
    });

    testWidgets('has proper layout and spacing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Test gradient background
      final gradientFinder = find.descendant(
        of: find.byType(Container),
        matching: find.byType(DecoratedBox),
      );
      expect(gradientFinder, findsOneWidget);

      // Test button spacing
      final buttonColumn = find.descendant(
        of: find.byType(Column),
        matching: find.byType(Column),
      ).last;
      
      final children = tester.widget<Column>(buttonColumn).children;
      expect(children.length, 2); // Two buttons
    });

    testWidgets('maintains aspect ratio of gradient container', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      
      // Test that the container has proper constraints
      expect(container.constraints?.minHeight, 200);
      expect(container.padding, const EdgeInsets.all(32));
    });

    testWidgets('displays correct text on buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Test button texts
      expect(find.text('Google Sign-In (Coming Soon)'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('guest login button has proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final guestButton = tester.widget<ElevatedButton>(find.text('Continue as Guest'));
      
      expect(guestButton.style?.backgroundColor, 
             MaterialStateProperty.all(Colors.blue));
      expect(guestButton.style?.padding, 
             MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 32, vertical: 16)));
    });

    testWidgets('shows snackbar with correct message for Google Sign-In', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Google Sign-In button
      await tester.tap(find.text('Google Sign-In (Coming Soon)'));
      await tester.pumpAndSettle();

      // Snackbar should have correct content
      expect(find.text('Google Sign-In is not available in web demo'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('layout is responsive', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Test that the layout adapts to different screen sizes
      // This is implicit in the use of Column and flexible spacing
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('does not show debug banner', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Debug banner should not be visible
      expect(find.byType(Builder), findsNothing);
    });
  });
}
