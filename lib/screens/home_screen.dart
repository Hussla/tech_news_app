/// Main home screen for the Tech News application.
/// 
/// This screen serves as the central hub of the application, providing
/// navigation to all major features through a bottom navigation bar
/// and floating action button.
/// 
/// The screen uses the following key Flutter components:
/// - [Scaffold] - Provides the basic material design visual structure
/// - [AppBar] - Contains the app title and action buttons
/// - [BottomNavigationBar] - Allows navigation between main sections
/// - [FloatingActionButton] - Provides quick access to voice search
/// - [Navigator] - Handles navigation between screens
/// 
/// References:
/// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
/// - Bottom Navigation: https://docs.flutter.dev/ui/navigation/bottom-navigation
/// - Navigation: https://docs.flutter.dev/ui/navigation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/screens/search_screen.dart';
import 'package:tech_news_app/screens/saved_articles_screen.dart';
import 'package:tech_news_app/screens/news_detail_screen.dart';
import 'package:tech_news_app/screens/location_screen.dart';
import 'package:tech_news_app/screens/qr_code_scanner_screen.dart';
import 'package:tech_news_app/screens/voice_search_screen.dart';
import 'package:tech_news_app/widgets/article_card.dart';

/// The main home interface for the Tech News application.
/// 
/// This StatefulWidget provides the central navigation hub with:
/// - A bottom navigation bar for switching between main sections:
///   * Search: Browse and search technology news
///   * Saved: View bookmarked articles
///   * Nearby: Discover location-based news
/// - An app bar with quick action buttons for:
///   * Search
///   * Voice search
///   * QR code scanning
/// - A floating action button for quick access to voice search
/// 
/// The screen manages the state of the currently selected tab
/// and displays the appropriate content screen.
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - BottomNavigationBar: https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
class HomeScreen extends StatefulWidget {
  /// Creates a HomeScreen widget
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// The state class for the HomeScreen.
/// 
/// This State class manages:
/// - The currently selected tab index (_currentIndex)
/// - The list of screens to display in the bottom navigation
/// - The UI state and rebuilds when the tab changes
/// 
/// The class handles tab selection through the bottom navigation bar
/// and updates the displayed content accordingly.
/// 
/// References:
/// - State: https://api.flutter.dev/flutter/widgets/State-class.html
/// - BottomNavigationBar: https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
class _HomeScreenState extends State<HomeScreen> {
  /// The index of the currently selected tab
  int _currentIndex = 0;

  /// The list of screens to display in the bottom navigation
  final List<Widget> _screens = const [
    SearchScreen(),
    SavedArticlesScreen(),
    LocationScreen(),
  ];

  /// Builds the complete home screen UI.
  /// 
  /// This method constructs the entire home interface with:
  /// - A Scaffold as the root widget
  /// - An AppBar with the app title and action buttons for:
  ///   * Search
  ///   * Voice search
  ///   * QR code scanning
  /// - A body that displays the currently selected screen from _screens
  /// - A BottomNavigationBar for switching between main sections
  /// - A FloatingActionButton for quick access to voice search
  /// 
  /// The UI responds to the _currentIndex state, displaying the
  /// appropriate screen content based on the selected tab.
  /// 
  /// References:
  /// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
  /// - AppBar: https://api.flutter.dev/flutter/material/AppBar-class.html
  /// - BottomNavigationBar: https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
  /// - FloatingActionButton: https://api.flutter.dev/flutter/material/FloatingActionButton-class.html
  /// - Navigation: https://docs.flutter.dev/ui/navigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoiceSearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRCodeScannerScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Nearby',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VoiceSearchScreen()),
          );
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}
