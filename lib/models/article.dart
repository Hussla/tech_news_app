/// Represents a news article in the Tech News application.
/// 
/// This model class defines the structure of a news article with properties
/// for the title, description, content, URL, image URL, and publication date.
/// 
/// The class provides:
/// - A constructor for creating articles with all required fields
/// - A factory method to create an Article from JSON data
/// - A method to convert an Article to JSON format
/// 
/// References:
/// - Dart Classes: https://dart.dev/language/classes
/// - JSON Serialization: https://docs.flutter.dev/data-and-backend/json
/// - DateTime: https://api.flutter.dev/flutter/dart-core/DateTime-class.html
class Article {
  /// The headline of the article
  final String title;

  /// A brief summary of the article (nullable)
  final String? description;

  /// The full content of the article (nullable)
  final String? content;

  /// The URL where the full article can be viewed
  final String url;

  /// The URL of the article's featured image (nullable)
  final String? imageUrl;

  /// The date and time when the article was published
  final DateTime publishedAt;

  /// Creates a new Article with the specified properties.
  /// 
  /// All parameters except description, content, and imageUrl are required.
  /// 
  /// References:
  /// - Named Parameters: https://dart.dev/language/functions#named-parameters
  /// - Nullable Types: https://dart.dev/null-safety
  Article({
    required this.title,
    this.description,
    this.content,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
  });

  /// Creates an Article instance from a JSON map.
  /// 
  /// This factory method converts a JSON map (typically received from an API)
  /// into an Article object. It handles the mapping of JSON keys to Article
  /// properties, with appropriate null safety handling.
  /// 
  /// The method maps the following JSON keys:
  /// - 'title' → title (with empty string fallback)
  /// - 'description' → description
  /// - 'content' → content
  /// - 'url' → url (with empty string fallback)
  /// - 'urlToImage' → imageUrl
  /// - 'publishedAt' → publishedAt (parsed from ISO 8601 string)
  /// 
  /// References:
  /// - Factory Constructors: https://dart.dev/language/constructors#factory-constructors
  /// - JSON Parsing: https://docs.flutter.dev/data-and-backend/json
  /// - Null Safety: https://dart.dev/null-safety
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'],
      content: json['content'],
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'],
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }

  /// Converts an Article object to a JSON map.
  /// 
  /// This method serialises the Article object into a JSON-compatible map
  /// that can be sent to an API or stored in a database. It handles the
  /// conversion of the DateTime object to an ISO 8601 string format.
  /// 
  /// The method includes the following properties in the JSON output:
  /// - 'title': The article's headline
  /// - 'description': A brief summary of the article
  /// - 'content': The full content of the article
  /// - 'url': The URL where the full article can be viewed
  /// - 'urlToImage': The URL of the article's featured image
  /// - 'publishedAt': The publication date in ISO 8601 format
  /// 
  /// References:
  /// - JSON Serialization: https://docs.flutter.dev/data-and-backend/json
  /// - DateTime Formatting: https://api.flutter.dev/flutter/dart-core/DateTime/toIso8601String.html
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt.toUtc().toIso8601String(),
    };
  }

  /// Compares two Article objects for equality.
  /// 
  /// Two articles are considered equal if they have the same URL,
  /// as URLs are unique identifiers for articles.
  /// 
  /// References:
  /// - Equality Operators: https://dart.dev/language/operators#equality-and-relational-operators
  /// - Object Equality: https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article && other.url == url;
  }

  /// Generates a hash code for the Article object.
  /// 
  /// The hash code is based on the URL, which serves as the unique
  /// identifier for articles.
  /// 
  /// References:
  /// - Hash Codes: https://api.flutter.dev/flutter/dart-core/Object/hashCode.html
  @override
  int get hashCode => url.hashCode;

  /// Returns a string representation of the Article object.
  /// 
  /// This method provides a human-readable representation of the article
  /// that includes the title and URL for debugging purposes.
  /// 
  /// References:
  /// - toString Method: https://api.flutter.dev/flutter/dart-core/Object/toString.html
  @override
  String toString() {
    return 'Article(title: $title, url: $url)';
  }
}
