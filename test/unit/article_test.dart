/// Article model tests for the Tech News application.
/// 
/// This test file validates the Article model's functionality including:
/// - JSON serialisation and deserialisation
/// - Handling of null values and missing fields
/// - Object equality and hashing
/// - String representation
/// - Date formatting
/// 
/// The tests follow the Arrange-Act-Assert pattern and use meaningful test names
/// to clearly describe the expected behaviour.
/// 
/// References:
/// - [Flutter Testing Guide](https://docs.flutter.dev/testing)
/// - [Widget Testing](https://docs.flutter.dev/testing/widget-tests)
/// - [Test Coverage](https://docs.flutter.dev/testing/code-coverage)
/// - [JSON Serialisation](https://docs.flutter.dev/data-and-backend/json)
/// - [Dart DateTime](https://api.dart.dev/stable/dart-core/DateTime-class.html)
/// - [Dart Equality](https://dart.dev/guides/language/effective-dart/usage#equality)

import 'package:flutter_test/flutter_test.dart';
import 'package:tech_news_app/models/article.dart';
import 'package:intl/intl.dart';

void main() {
  group('Article', () {
    final testDate = DateTime(2023, 1, 15, 10, 30, 0);
    final testJson = {
      'title': 'Test Article',
      'description': 'Test description',
      'content': 'Test content',
      'url': 'https://example.com/test',
      'urlToImage': 'https://example.com/image.jpg',
      'publishedAt': '2023-01-15T10:30:00Z',
    };

    test('creates Article from JSON using fromJson', () {
      final article = Article.fromJson(testJson);

      expect(article.title, 'Test Article');
      expect(article.description, 'Test description');
      expect(article.content, 'Test content');
      expect(article.url, 'https://example.com/test');
      expect(article.imageUrl, 'https://example.com/image.jpg');
      expect(article.publishedAt, DateTime.utc(2023, 1, 15, 10, 30, 0));
    });

    test('handles null values in JSON', () {
      final jsonWithNulls = {
        'title': 'Test Article',
        'description': null,
        'content': null,
        'url': 'https://example.com/test',
        'urlToImage': null,
        'publishedAt': '2023-01-15T10:30:00Z',
      };

      final article = Article.fromJson(jsonWithNulls);

      expect(article.title, 'Test Article');
      expect(article.description, isNull);
      expect(article.content, isNull);
      expect(article.url, 'https://example.com/test');
      expect(article.imageUrl, isNull);
      expect(article.publishedAt, DateTime.utc(2023, 1, 15, 10, 30, 0));
    });

    test('handles missing required fields in JSON', () {
      final jsonMissingRequired = {
        'description': 'Test description',
        'content': 'Test content',
        'urlToImage': 'https://example.com/image.jpg',
        'publishedAt': '2023-01-15T10:30:00Z',
      };

      final article = Article.fromJson(jsonMissingRequired);

      expect(article.title, '');
      expect(article.description, 'Test description');
      expect(article.content, 'Test content');
      expect(article.url, '');
      expect(article.imageUrl, 'https://example.com/image.jpg');
      expect(article.publishedAt, DateTime.utc(2023, 1, 15, 10, 30, 0));
    });

    test('converts Article to JSON using toJson', () {
      final article = Article(
        title: 'Test Article',
        description: 'Test description',
        content: 'Test content',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: testDate,
      );

      final json = article.toJson();

      expect(json['title'], 'Test Article');
      expect(json['description'], 'Test description');
      expect(json['content'], 'Test content');
      expect(json['url'], 'https://example.com/test');
      expect(json['urlToImage'], 'https://example.com/image.jpg');
      expect(json['publishedAt'], '2023-01-15T10:30:00.000Z');
    });

    test('converts Article with null values to JSON', () {
      final article = Article(
        title: 'Test Article',
        description: null,
        content: null,
        url: 'https://example.com/test',
        imageUrl: null,
        publishedAt: testDate,
      );

      final json = article.toJson();

      expect(json['title'], 'Test Article');
      expect(json['description'], isNull);
      expect(json['content'], isNull);
      expect(json['url'], 'https://example.com/test');
      expect(json['urlToImage'], isNull);
      expect(json['publishedAt'], '2023-01-15T10:30:00.000Z');
    });

    test('Article equality works correctly', () {
      final article1 = Article(
        title: 'Test Article',
        description: 'Test description',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: testDate,
      );

      final article2 = Article(
        title: 'Test Article',
        description: 'Test description',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: testDate,
      );

      final article3 = Article(
        title: 'Different Article',
        description: 'Different description',
        url: 'https://example.com/different',
        imageUrl: 'https://example.com/different.jpg',
        publishedAt: testDate,
      );

      expect(article1, equals(article2));
      expect(article1 == article2, isTrue);
      expect(article1.hashCode, equals(article2.hashCode));
      expect(article1, isNot(equals(article3)));
      expect(article1 == article3, isFalse);
    });

    test('Article toString returns meaningful string', () {
      final article = Article(
        title: 'Test Article',
        description: 'Test description',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: testDate,
      );

      final toStringResult = article.toString();

      expect(toStringResult, contains('Article'));
      expect(toStringResult, contains('title: Test Article'));
      expect(toStringResult, contains('url: https://example.com/test'));
    });

    test('publishedAt formatting is consistent', () {
      final article = Article(
        title: 'Test Article',
        description: 'Test description',
        url: 'https://example.com/test',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: testDate,
      );

      // Test different formatting approaches
      final isoFormat = article.publishedAt.toIso8601String();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(article.publishedAt);

      expect(isoFormat, '2023-01-15T10:30:00.000');
      expect(formattedDate, '2023-01-15 10:30:00');
    });
  });
}
