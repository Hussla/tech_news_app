/// Provides news articles and manages the application state for the Tech News app.
/// 
/// This ChangeNotifier class handles:
/// - Fetching top headlines from a news API
/// - Searching for articles by keyword
/// - Managing saved articles with local persistence
/// - State management for the search query and loading state
/// 
/// The class uses the following key Flutter patterns:
/// - [ChangeNotifier] - For state management with the Provider package
/// - [Future] - For asynchronous operations like API calls
/// - [notifyListeners] - To notify widgets of state changes
/// 
/// References:
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// - HTTP Requests in Flutter: https://docs.flutter.dev/cookbook/networking/fetch-data
/// - ChangeNotifier: https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html
/// - Asynchronous Programming: https://dart.dev/codelabs/async-await
/// 
/// **Attribution**: Provider pattern implementation adapted from:
/// URL: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// URL: https://pub.dev/packages/provider (official documentation)
/// Summary: Learnt how to implement the Provider pattern for state management,
/// including proper use of ChangeNotifier, notifyListeners, and async state
/// management patterns. Also learnt best practices for separating business
/// logic from UI components.
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tech_news_app/models/article.dart';
import 'package:tech_news_app/services/database_service.dart';

class NewsProvider with ChangeNotifier {
  static bool _testingMode = false;
  
  List<Article> _articles = [];
  List<Article> _savedArticles = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Article> get articles => _articles;
  List<Article> get savedArticles => _savedArticles;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  NewsProvider() {
    // Only initialize if not in testing mode
    if (!_testingMode) {
      fetchTopHeadlines();
      _loadSavedArticles();
    }
  }

  /// Set testing mode to prevent database operations during tests
  static void setTestingMode(bool testing) {
    _testingMode = testing;
  }

  Future<void> fetchTopHeadlines() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock data for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      _articles = [
        Article(
          title: 'Flutter 3.0 Released with Major Performance Improvements',
          description: 'Google announces Flutter 3.0 with enhanced performance and new features for cross-platform development.',
          content: 'Flutter 3.0 brings significant improvements to performance, developer experience, and platform support...',
          url: 'https://flutter.dev/news/flutter-3',
          imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Article(
          title: 'AI Revolution: ChatGPT-4 Transforms Software Development',
          description: 'The latest AI models are changing how developers write and debug code.',
          content: 'Artificial Intelligence is revolutionizing software development with advanced code generation capabilities...',
          url: 'https://openai.com/chatgpt',
          imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        Article(
          title: 'Quantum Computing Breakthrough: IBM Unveils 1000-Qubit Processor',
          description: 'IBM reaches new milestone in quantum computing with their latest processor.',
          content: 'IBM has announced a major breakthrough in quantum computing technology...',
          url: 'https://ibm.com/quantum',
          imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        Article(
          title: 'Apple Vision Pro: The Future of Mixed Reality Computing',
          description: 'Apple\'s latest device promises to revolutionize how we interact with digital content.',
          content: 'The Vision Pro represents Apple\'s bold step into spatial computing...',
          url: 'https://apple.com/vision-pro',
          imageUrl: 'https://images.unsplash.com/photo-1593508512255-86ab42a8e620?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        Article(
          title: 'Tesla\'s New Autopilot Update Enhances Safety Features',
          description: 'Latest software update brings improved object detection and emergency braking.',
          content: 'Tesla continues to push the boundaries of autonomous driving technology...',
          url: 'https://tesla.com/autopilot',
          imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
        ),
      ];
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching news: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Searches for news articles based on a query string.
  /// 
  /// This method:
  /// 1. Updates the search query state
  /// 2. Sets loading state to true
  /// 3. Simulates an API call with Future.delayed
  /// 4. Gets search results based on the query
  /// 5. Updates the articles list
  /// 6. Handles any errors that occur during the search
  /// 7. Sets loading state to false
  /// 
  /// The search functionality uses a mock implementation that returns
  /// different results based on common tech terms in the query.
  /// 
  /// References:
  /// - Asynchronous Programming: https://dart.dev/codelabs/async-await
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  /// - String Manipulation: https://api.flutter.dev/flutter/dart-core/String-class.html
  Future<void> searchNews(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    try {
      // Mock search results for demo with realistic tech news
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate different search results based on query
      final searchResults = _getSearchResults(query.toLowerCase());
      _articles = searchResults;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching news: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Gets search results based on the query string.
  /// 
  /// This private method returns different sets of mock articles based on
  /// the content of the search query. It simulates a real API by returning
  /// relevant tech news articles for common technology terms.
  /// 
  /// The method handles the following search terms:
  /// - 'ai' or 'artificial intelligence': Returns AI/ML related articles
  /// - 'flutter' or 'mobile': Returns Flutter and mobile development articles
  /// - 'apple' or 'ios': Returns Apple and iOS related articles
  /// - 'web' or 'javascript': Returns web development articles
  /// - Any other query: Returns an empty list to trigger the "no results" state
  /// 
  /// References:
  /// - String Methods: https://api.flutter.dev/flutter/dart-core/String-class.html
  /// - Conditional Logic: https://dart.dev/language/booleans
  /// - List Operations: https://api.flutter.dev/flutter/dart-core/List-class.html
  List<Article> _getSearchResults(String query) {
    // Simulate realistic search results based on common tech terms
    if (query.contains('ai') || query.contains('artificial intelligence')) {
      return [
        Article(
          title: 'OpenAI Releases GPT-4 Turbo with Enhanced Capabilities',
          description: 'The latest AI model offers improved reasoning and reduced costs for developers.',
          content: 'OpenAI has unveiled GPT-4 Turbo, featuring enhanced capabilities...',
          url: 'https://openai.com/blog/gpt-4-turbo',
          imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Article(
          title: 'Google Bard Gets Major Update with Gemini Integration',
          description: 'Google\'s AI assistant now powered by advanced Gemini model.',
          content: 'Google has announced a significant update to Bard...',
          url: 'https://blog.google/technology/ai/bard-gemini-update',
          imageUrl: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
      ];
    } else if (query.contains('flutter') || query.contains('mobile')) {
      return [
        Article(
          title: 'Flutter 3.16 Brings Material Design 3 Support',
          description: 'Latest Flutter update includes full Material You theming and performance improvements.',
          content: 'Flutter 3.16 introduces comprehensive Material Design 3 support...',
          url: 'https://flutter.dev/blog/flutter-3-16',
          imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Article(
          title: 'React Native vs Flutter: 2024 Performance Comparison',
          description: 'Comprehensive analysis of cross-platform mobile development frameworks.',
          content: 'A detailed comparison of React Native and Flutter performance...',
          url: 'https://medium.com/react-native-vs-flutter-2024',
          imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
    } else if (query.contains('apple') || query.contains('ios')) {
      return [
        Article(
          title: 'Apple Vision Pro Developer Kit Now Available',
          description: 'Apple opens Vision Pro development to more creators with new SDK.',
          content: 'Apple has expanded access to Vision Pro development tools...',
          url: 'https://developer.apple.com/vision-pro',
          imageUrl: 'https://images.unsplash.com/photo-1593508512255-86ab42a8e620?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Article(
          title: 'iOS 17.2 Introduces Advanced Health Monitoring',
          description: 'New health features leverage machine learning for better insights.',
          content: 'iOS 17.2 brings enhanced health monitoring capabilities...',
          url: 'https://apple.com/ios/ios-17',
          imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ];
    } else if (query.contains('web') || query.contains('javascript') || query.contains('node')) {
      return [
        Article(
          title: 'Node.js 21 Released with Enhanced Performance',
          description: 'Latest Node.js version brings significant speed improvements and new features.',
          content: 'Node.js 21 introduces performance optimisations and developer tools...',
          url: 'https://nodejs.org/blog/release/v21.0.0',
          imageUrl: 'https://images.unsplash.com/photo-1627398242454-45a1465c2479?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Article(
          title: 'WebAssembly Gains Momentum in Enterprise Applications',
          description: 'More companies adopting WASM for high-performance web applications.',
          content: 'WebAssembly is becoming increasingly popular in enterprise settings...',
          url: 'https://webassembly.org/blog/enterprise-adoption',
          imageUrl: 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
    } else {
      // Return empty list for unrecognized queries to trigger "no results" state
      return [];
    }
  }

  /// Loads saved articles from local storage when the app starts.
  /// 
  /// This private method is called in the NewsProvider constructor to
  /// populate the saved articles list from persistent storage. It handles
  /// both successful loading and error cases gracefully.
  /// 
  /// On web platforms where local database storage is not available,
  /// it falls back to an empty list to ensure the app functions correctly.
  /// 
  /// The method:
  /// 1. Attempts to retrieve saved articles from the database
  /// 2. Updates the _savedArticles list with the retrieved data
  /// 3. Handles any errors by using an empty list as fallback
  /// 4. Notifies listeners of the state change
  /// 
  /// References:
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  /// - Async/Await: https://dart.dev/codelabs/async-await
  /// - Local Storage: https://pub.dev/packages/sqflite
  Future<void> _loadSavedArticles() async {
    try {
      final savedArticles = await DatabaseService.instance.getSavedArticles();
      _savedArticles = savedArticles;
    } catch (e) {
      // For web demo, just use empty list
      _savedArticles = [];
    }
    notifyListeners();
  }

  /// Saves an article to persistent storage.
  /// 
  /// This method:
  /// 1. Checks if the article is already saved to avoid duplicates
  /// 2. Adds the article to the in-memory list of saved articles
  /// 3. Attempts to save the article to the local database
  /// 4. Handles database errors gracefully (particularly on web platform)
  /// 5. Notifies listeners of the state change
  /// 
  /// On web platforms where local database storage is not available,
  /// the article is kept in memory for the current session only.
  /// 
  /// References:
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  /// - List Operations: https://api.flutter.dev/flutter/dart-core/List-class.html
  /// - Local Storage: https://pub.dev/packages/sqflite
  Future<void> saveArticle(Article article) async {
    if (!_savedArticles.any((a) => a.url == article.url)) {
      _savedArticles.add(article);
      try {
        await DatabaseService.instance.insert(article);
      } catch (e) {
        // For web demo, just keep in memory
        if (kDebugMode) {
          print('Database not available on web: $e');
        }
      }
      notifyListeners();
    }
  }

  /// Removes a saved article from persistent storage.
  /// 
  /// This method:
  /// 1. Removes the article from the in-memory list of saved articles
  /// 2. Attempts to delete the article from the local database
  /// 3. Handles database errors gracefully (particularly on web platform)
  /// 4. Notifies listeners of the state change
  /// 
  /// On web platforms where local database storage is not available,
  /// the article is only removed from the current session's memory.
  /// 
  /// References:
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  /// - List Operations: https://api.flutter.dev/flutter/dart-core/List-class.html
  /// - Local Storage: https://pub.dev/packages/sqflite
  Future<void> removeSavedArticle(String url) async {
    _savedArticles.removeWhere((article) => article.url == url);
    try {
      await DatabaseService.instance.delete(url);
    } catch (e) {
      // For web demo, just remove from memory
      if (kDebugMode) {
        print('Database not available on web: $e');
      }
    }
    notifyListeners();
  }

  /// Checks if an article is saved in the user's collection.
  /// 
  /// This method determines whether a specific article (identified by its URL)
  /// exists in the user's saved articles list.
  /// 
  /// Returns true if the article is saved, false otherwise.
  /// 
  /// Used by the ArticleCard widget to determine the state of the bookmark icon.
  /// 
  /// References:
  /// - Iterable Methods: https://api.flutter.dev/flutter/dart-core/Iterable-class.html
  /// - Lambda Functions: https://dart.dev/language/functions#anonymous-functions
  bool isArticleSaved(String url) {
    return _savedArticles.any((article) => article.url == url);
  }
}
