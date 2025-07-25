/// News detail screen for the Tech News application.
/// 
/// This screen displays the full details of a selected news article,
/// including the title, image, publication date, description, and content.
/// It provides functionality to share the article and open it in a browser.
/// 
/// The screen uses the following key Flutter components:
/// - [Hero] - For smooth transitions between screens with shared elements
/// - [SingleChildScrollView] - Allows scrolling through long article content
/// - [Image.network] - Displays the article's featured image
/// - [ElevatedButton] - For opening the full article in a browser
/// - [IconButton] - For sharing the article
/// 
/// References:
/// - Hero Animations: https://docs.flutter.dev/ui/animations/hero-animations
/// - Image Widget: https://api.flutter.dev/flutter/widgets/Image-class.html
/// - Button Types: https://docs.flutter.dev/ui/widgets/material#buttons
/// - URL Launching: https://pub.dev/packages/url_launcher
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tech_news_app/models/article.dart';

/// The news article detail interface for the Tech News application.
/// 
/// This StatelessWidget provides a screen that displays the full details
/// of a selected news article. It features:
/// - A hero animation for the article image when navigating from the list
/// - The article title in a prominent display
/// - The publication date in a readable format
/// - The article description and content
/// - A button to open the full article in a browser
/// - A share button in the app bar
/// 
/// The screen uses a single scrollable column to display all content,
/// ensuring users can read the entire article even on smaller screens.
/// 
/// References:
/// - StatelessWidget: https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html
/// - Hero Animations: https://docs.flutter.dev/ui/animations/hero-animations
/// - Article Display: https://material.io/design/communication/article-templates.html
class NewsDetailScreen extends StatelessWidget {
  /// The article to display in this screen
  final Article article;

  /// Creates a NewsDetailScreen widget for the specified article
  const NewsDetailScreen({super.key, required this.article});

  /// Builds the complete news article detail screen UI.
  /// 
  /// This method constructs the entire article detail interface with:
  /// - A Scaffold as the root widget
  /// - An AppBar with the screen title and share button
  /// - A body containing:
  ///   * The article image with hero animation (if available)
  ///   * The article title in a large, bold font
  ///   * The publication date in DD/MM/YYYY format
  ///   * The article description (if available)
  ///   * The article content (if available)
  ///   * A button to open the full article in a browser
  /// 
  /// The content is wrapped in a SingleChildScrollView to ensure
  /// all content is accessible even on smaller screens.
  /// 
  /// The share button in the app bar opens the article URL in the
  /// device's default browser.
  /// 
  /// References:
  /// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
  /// - AppBar: https://api.flutter.dev/flutter/material/AppBar-class.html
  /// - Hero: https://api.flutter.dev/flutter/widgets/Hero-class.html
  /// - Image.network: https://api.flutter.dev/flutter/widgets/Image/Image.network.html
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final Uri url = Uri.parse(article.url);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl != null)
                Hero(
                  tag: article.url,
                  child: Image.network(
                    article.imageUrl!,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Published on ${article.publishedAt.day}/${article.publishedAt.month}/${article.publishedAt.year}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              if (article.description != null)
                Text(
                  article.description!,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 16),
              if (article.content != null)
                Text(
                  article.content!,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(article.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text('Read Full Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
