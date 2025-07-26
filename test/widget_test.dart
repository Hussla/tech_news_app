// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/main.dart';
import 'test_setup.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Start the app using test setup
    await tester.pumpWidget(
      createTestApp(
        child: const MyApp(),
        useMockProvider: true,
      ),
    );

    // Verify app bar is displayed
    expect(find.text('Tech News'), findsOneWidget);

    // Verify bottom navigation bar is displayed
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify home tab is selected by default
    expect(find.text('Home'), findsOneWidget);
  });
}
