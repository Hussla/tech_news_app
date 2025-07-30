import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/services.dart';
import 'package:tech_news_app/models/article.dart';

void main() {
  group('FirecrawlService', () {
    late FirecrawlService firecrawlService;

    setUp(() {
      firecrawlService = FirecrawlService();
    });

    tearDown(() {
      firecrawlService.dispose();
    });

    test('FirecrawlService can be instantiated', () {
      expect(firecrawlService, isA<FirecrawlService>());
    });

    test('extractArticleContent returns original article when no API key is configured', () async {
      final testArticle = Article(
        title: 'Test Article',
        description: 'A test article',
        url: 'https://example.com/article',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: DateTime.now(),
      );
      final result = await firecrawlService.extractArticleContent(testArticle);
      expect(result, equals(testArticle));
    });

    test('extractArticleContent returns original article when extraction fails', () async {
      final testArticle = Article(
        title: 'Test Article',
        description: 'A test article',
        url: 'https://example.com/article',
        publishedAt: DateTime.now(),
      );

      final result = await firecrawlService.extractArticleContent(testArticle);
      expect(result, equals(testArticle));
    });

    test('extractBatchContent returns original articles when no API key is configured', () async {
      final testArticles = [
        Article(
          title: 'Test Article 1',
          description: 'First test article',
          url: 'https://example.com/article1',
          publishedAt: DateTime.now(),
        ),
        Article(
          title: 'Test Article 2',
          description: 'Second test article',
          url: 'https://example.com/article2',
          publishedAt: DateTime.now(),
        ),
      ];

      final result = await firecrawlService.extractBatchContent(testArticles);
      expect(result, equals(testArticles));
    });

    test('extractArticleContent returns original article for empty URL', () async {
      final testArticle = Article(
        title: 'Test Article',
        description: 'A test article',
        url: '',
        publishedAt: DateTime.now(),
      );

      final result = await firecrawlService.extractArticleContent(testArticle);
      expect(result, equals(testArticle));
    });
  });
}
