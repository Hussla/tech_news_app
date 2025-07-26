/// NewsProvider tests for the Tech News application.
/// 
/// This test file validates the NewsProvider's functionality including:
/// - Initialisation state
/// - Fetching top headlines
/// - Searching for articles
/// - Saving and removing articles
/// - Checking saved article status
/// - Search results for specific topics
/// 
/// The tests use mock data to simulate API responses without network dependencies,
/// ensuring fast and reliable test execution. 
/// 
/// References:
/// - [Flutter Testing Guide](https://docs.flutter.dev/testing)
/// - [Unit Testing](https://docs.flutter.dev/testing#unit-tests)
/// - [Mocking Dependencies](https://pub.dev/packages/mockito)
/// - [State Management with Provider](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)
/// - [Future and Async](https://dart.dev/codelabs/async-await)
/// - [Error Handling](https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control)

import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/models/article.dart';

void main() {
  group('NewsProvider', () {
    late NewsProvider newsProvider;

    setUp(() async {
      newsProvider = NewsProvider();
      // Wait for initial fetch to complete
      await Future.delayed(const Duration(milliseconds: 1100));
    });

    tearDown(() {
      newsProvider.dispose();
    });

    test('initialises with articles after initial fetch', () {
      expect(newsProvider.articles, isNotEmpty);
    });

    test('initialises with empty saved articles list', () {
      expect(newsProvider.savedArticles, isEmpty);
    });

    test('initialises with empty search query', () {
      expect(newsProvider.searchQuery, isEmpty);
    });

    test('initialises with isLoading false after initial fetch', () {
      expect(newsProvider.isLoading, isFalse);
    });

    test('fetchTopHeadlines fetches articles successfully', () async {
      await newsProvider.fetchTopHeadlines();
      
      expect(newsProvider.isLoading, isFalse);
      expect(newsProvider.articles, isNotEmpty);
      expect(newsProvider.articles.length, 5);
      expect(newsProvider.articles.first, isA<Article>());
      expect(newsProvider.articles.first.title, isNotEmpty);
      expect(newsProvider.articles.first.url, isNotEmpty);
      expect(newsProvider.articles.first.publishedAt, isA<DateTime>());
    });

    test('searchNews updates searchQuery and fetches articles', () async {
      const query = 'Flutter';
      await newsProvider.searchNews(query);
      
      expect(newsProvider.searchQuery, query);
      expect(newsProvider.isLoading, isFalse);
      expect(newsProvider.articles, isNotEmpty);
      expect(newsProvider.articles.first.title.toLowerCase(), 
             contains(query.toLowerCase()));
    });

    test('searchNews with no results returns empty list', () async {
      const query = 'nonexistentquery123';
      await newsProvider.searchNews(query);
      
      expect(newsProvider.searchQuery, query);
      expect(newsProvider.isLoading, isFalse);
      expect(newsProvider.articles, isEmpty);
    });

    test('saveArticle adds article to savedArticles', () {
      final article = Article(
        title: 'Test Article',
        description: 'Test description',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: DateTime.now(),
      );

      newsProvider.saveArticle(article);
      
      expect(newsProvider.savedArticles, isNotEmpty);
      expect(newsProvider.savedArticles.length, 1);
      expect(newsProvider.savedArticles.first.url, article.url);
      expect(newsProvider.isArticleSaved(article.url), isTrue);
    });

    test('saveArticle does not add duplicate articles', () {
      final article = Article(
        title: 'Test Article',
        description: 'Test description',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: DateTime.now(),
      );

      newsProvider.saveArticle(article);
      newsProvider.saveArticle(article); // Try to add again
      
      expect(newsProvider.savedArticles.length, 1);
    });

    test('removeSavedArticle removes article from savedArticles', () {
      final article = Article(
        title: 'Test Article',
        description: 'Test description',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: DateTime.now(),
      );

      newsProvider.saveArticle(article);
      expect(newsProvider.savedArticles.length, 1);
      
      newsProvider.removeSavedArticle(article.url);
      
      expect(newsProvider.savedArticles, isEmpty);
      expect(newsProvider.isArticleSaved(article.url), isFalse);
    });

    test('isArticleSaved returns correct value', () {
      final article = Article(
        title: 'Test Article',
        description: 'Test description',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: DateTime.now(),
      );

      expect(newsProvider.isArticleSaved(article.url), isFalse);
      
      newsProvider.saveArticle(article);
      expect(newsProvider.isArticleSaved(article.url), isTrue);
      
      newsProvider.removeSavedArticle(article.url);
      expect(newsProvider.isArticleSaved(article.url), isFalse);
    });

    test('searchNews with AI query returns AI-related articles', () async {
      await newsProvider.searchNews('AI');
      
      expect(newsProvider.articles, isNotEmpty);
      final title = newsProvider.articles.first.title.toLowerCase();
      expect(title.contains('ai') || title.contains('artificial intelligence'), isTrue);
    });

    test('searchNews with Flutter query returns Flutter-related articles', () async {
      await newsProvider.searchNews('Flutter');
      
      expect(newsProvider.articles, isNotEmpty);
      final title = newsProvider.articles.first.title.toLowerCase();
      expect(title.contains('flutter') || title.contains('mobile'), isTrue);
    });

    test('searchNews with Apple query returns Apple-related articles', () async {
      await newsProvider.searchNews('Apple');
      
      expect(newsProvider.articles, isNotEmpty);
      final title = newsProvider.articles.first.title.toLowerCase();
      expect(title.contains('apple') || title.contains('ios'), isTrue);
    });

    test('searchNews with Web query returns Web-related articles', () async {
      await newsProvider.searchNews('javascript');
      
      expect(newsProvider.articles, isNotEmpty);
      final title = newsProvider.articles.first.title.toLowerCase();
      expect(title.contains('web') || title.contains('javascript') || title.contains('node'), isTrue);
    });
  });
}
