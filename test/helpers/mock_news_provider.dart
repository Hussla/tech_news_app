import 'package:flutter/foundation.dart';
import 'package:tech_news_app/models/article.dart';
import 'package:tech_news_app/providers/news_provider.dart';

/// Mock NewsProvider for testing purposes.
/// 
/// This class extends NewsProvider and overrides methods to prevent
/// actual API calls and timer issues in tests.
class MockNewsProvider extends NewsProvider {
  List<Article> _articles = [];
  List<Article> _savedArticles = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Article> get articles => _articles;
  List<Article> get savedArticles => _savedArticles;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  set articles(List<Article> value) {
    _articles = value;
    notifyListeners();
  }

  set savedArticles(List<Article> value) {
    _savedArticles = value;
    notifyListeners();
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  Future<void> fetchTopHeadlines() async {
    // Mock implementation - no actual API call or timer
  }

  @override
  Future<void> searchNews(String query) async {
    _searchQuery = query;
    notifyListeners();
  }

  @override
  Future<void> saveArticle(Article article) async {
    if (!_savedArticles.any((a) => a.url == article.url)) {
      _savedArticles.add(article);
      notifyListeners();
    }
  }

  @override
  Future<void> removeSavedArticle(String url) async {
    _savedArticles.removeWhere((article) => article.url == url);
    notifyListeners();
  }

  @override
  bool isArticleSaved(String url) {
    return _savedArticles.any((article) => article.url == url);
  }

  @override
  Future<void> loadSavedArticles() async {
    // Mock implementation - no database operations
  }

  @override
  Future<void> fetchNewsByCategory(String category) async {
    // Mock implementation - no actual API call
  }
}
