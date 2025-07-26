import 'package:flutter/foundation.dart';
import 'package:tech_news_app/models/article.dart';
import 'package:tech_news_app/providers/news_provider.dart';

/// Mock NewsProvider for testing purposes.
/// 
/// This class extends NewsProvider but prevents initialization issues
/// by using a static flag to control constructor behavior.
class MockNewsProvider extends NewsProvider {
  static bool _isTesting = false;
  
  List<Article> _mockArticles = [];
  List<Article> _mockSavedArticles = [];
  String _mockSearchQuery = '';
  bool _mockIsLoading = false;
  bool _disposed = false;

  MockNewsProvider() : super() {
    _isTesting = true;
  }

  static void setTestingMode(bool testing) {
    _isTesting = testing;
  }

  // Override all getters to use mock data
  @override
  List<Article> get articles => _mockArticles;
  
  @override
  List<Article> get savedArticles => _mockSavedArticles;
  
  @override
  String get searchQuery => _mockSearchQuery;
  
  @override
  bool get isLoading => _mockIsLoading;

  // Setters for test control
  set articles(List<Article> value) {
    _mockArticles = value;
    if (!_disposed) {
      notifyListeners();
    }
  }

  set savedArticles(List<Article> value) {
    _mockSavedArticles = value;
    if (!_disposed) {
      notifyListeners();
    }
  }

  set searchQuery(String value) {
    _mockSearchQuery = value;
    if (!_disposed) {
      notifyListeners();
    }
  }

  set isLoading(bool value) {
    _mockIsLoading = value;
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _isTesting = false;
    super.dispose();
  }

  // Override all NewsProvider methods to prevent database/API calls
  @override
  Future<void> fetchTopHeadlines() async {
    if (_disposed) return;
    // Mock implementation - no actual API call or timer
  }

  @override
  Future<void> searchNews(String query) async {
    if (_disposed) return;
    _mockSearchQuery = query;
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  Future<void> saveArticle(Article article) async {
    if (_disposed) return;
    if (!_mockSavedArticles.any((a) => a.url == article.url)) {
      _mockSavedArticles.add(article);
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  @override
  Future<void> removeSavedArticle(String url) async {
    if (_disposed) return;
    _mockSavedArticles.removeWhere((article) => article.url == url);
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  bool isArticleSaved(String url) {
    return _mockSavedArticles.any((article) => article.url == url);
  }

  @override
  Future<void> loadSavedArticles() async {
    if (_disposed) return;
    // Mock implementation - no database operations
  }

  @override
  Future<void> fetchNewsByCategory(String category) async {
    if (_disposed) return;
    // Mock implementation - no actual API call
  }
}
