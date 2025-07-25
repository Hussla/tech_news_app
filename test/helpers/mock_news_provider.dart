import 'package:flutter/foundation.dart';
import 'package:tech_news_app/models/article.dart';

/// Mock NewsProvider for testing purposes.
/// 
/// This class extends ChangeNotifier and provides setters for all properties
/// to allow tests to control the state without triggering actual API calls.
class MockNewsProvider with ChangeNotifier {
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

  Future<void> fetchTopHeadlines() async {
    // Mock implementation - no actual API call
  }

  Future<void> searchNews(String query) async {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> saveArticle(Article article) async {
    if (!_savedArticles.any((a) => a.url == article.url)) {
      _savedArticles.add(article);
      notifyListeners();
    }
  }

  Future<void> removeSavedArticle(String url) async {
    _savedArticles.removeWhere((article) => article.url == url);
    notifyListeners();
  }

  bool isArticleSaved(String url) {
    return _savedArticles.any((article) => article.url == url);
  }
}
