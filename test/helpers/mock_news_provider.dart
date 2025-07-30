import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/models/article.dart';

/// Mock NewsProvider for testing purposes.
/// 
/// This class extends NewsProvider but prevents initialisation issues
/// by using a static flag to control constructor behaviour.
class MockNewsProvider extends NewsProvider {
  List<Article> _mockArticles = [];
  List<Article> _mockSavedArticles = [];
  String _mockSearchQuery = '';
  bool _mockIsLoading = false;
  bool _disposed = false;

  MockNewsProvider() : super();

  static void setTestingMode(bool testing) {
    // This method is kept for API compatibility but doesn't do anything
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
    
    // Simulate loading state
    _mockIsLoading = true;
    notifyListeners();
    
    _mockSearchQuery = query;
    
    // Mock search results based on the query
    if (query.isNotEmpty && !query.contains('nonexistentquery123xyz')) {
      _mockArticles = [
        Article(
          title: 'Mock $query Article',
          description: 'This is a mock article for $query search',
          url: 'https://example.com/$query',
          imageUrl: 'https://example.com/image.jpg',
          publishedAt: DateTime.now(),
        ),
      ];
    } else {
      _mockArticles = [];
    }
    
    _mockIsLoading = false;
    notifyListeners();
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

  Future<void> loadSavedArticles() async {
    if (_disposed) return;
    // Mock implementation - no database operations
  }

  Future<void> clearAllSavedArticles() async {
    if (_disposed) return;
    _mockSavedArticles.clear();
    if (!_disposed) {
      notifyListeners();
    }
  }

  /// Helper method to set articles directly for testing
  void setArticles(List<Article> articles) {
    _mockArticles = List.from(articles);
    if (!_disposed) {
      notifyListeners();
    }
  }

  /// Setup method for easily configuring saved articles in tests.
  void setupSavedArticles(List<Article> articles) {
    _mockSavedArticles = List.from(articles);
    if (!_disposed) {
      notifyListeners();
    }
  }
}
