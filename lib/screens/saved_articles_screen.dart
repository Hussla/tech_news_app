/// Saved articles screen for the Tech News application.
/// 
/// This screen displays articles that the user has bookmarked for later reading.
/// It provides functionality to view, remove, and clear saved articles.
/// 
/// The screen uses the following key Flutter components:
/// - [Consumer] - For listening to changes in the NewsProvider
/// - [ListView.builder] - For efficiently displaying a list of saved articles
/// - [Dismissible] - For allowing swipe-to-delete functionality
/// - [AlertDialog] - For confirming deletion actions
/// - [SnackBar] - For providing user feedback with undo functionality
/// 
/// References:
/// - Consumer: https://pub.dev/documentation/provider/latest/provider/Consumer-class.html
/// - ListView.builder: https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html
/// - Dismissible: https://api.flutter.dev/flutter/widgets/Dismissible-class.html
/// - AlertDialog: https://api.flutter.dev/flutter/material/AlertDialog-class.html
/// - SnackBar: https://api.flutter.dev/flutter/material/SnackBar-class.html
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/widgets/article_card.dart';

/// The saved articles interface for the Tech News application.
/// 
/// This StatelessWidget provides a screen that displays articles
/// the user has bookmarked for later reading. It features:
/// - A list of saved articles with swipe-to-delete functionality
/// - An empty state when no articles are saved
/// - A clear all button to remove all saved articles
/// - Confirmation dialogs for deletion actions
/// - Undo functionality through snack bar actions
/// 
/// The screen uses the Provider pattern to listen to changes in
/// the NewsProvider and update the UI accordingly.
/// 
/// References:
/// - StatelessWidget: https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html
/// - Provider Pattern: https://pub.dev/packages/provider
class SavedArticlesScreen extends StatelessWidget {
  /// Creates a SavedArticlesScreen widget
  const SavedArticlesScreen({super.key});

  /// Builds the empty state UI when no articles are saved.
  /// 
  /// This method constructs a user-friendly message that appears
  /// when the user has not saved any articles yet. It includes:
  /// - A bookmark icon to visually represent saved articles
  /// - A title message explaining the current state
  /// - A description explaining how to save articles
  /// 
  /// The empty state encourages users to save articles from search
  /// results for later reading.
  /// 
  /// References:
  /// - Icon: https://api.flutter.dev/flutter/material/Icon-class.html
  /// - Text: https://api.flutter.dev/flutter/widgets/Text-class.html
  /// - Column: https://api.flutter.dev/flutter/widgets/Column-class.html
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved articles yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save articles from search results to read later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the complete saved articles screen UI.
  /// 
  /// This method constructs the entire saved articles interface with:
  /// - A Scaffold as the root widget
  /// - An AppBar with the screen title and clear all button
  /// - A body that displays:
  ///   * An empty state when no articles are saved
  ///   * A list of saved articles with swipe-to-delete functionality
  /// - Confirmation dialogs for deletion actions
  /// - Undo functionality through snack bar actions
  /// 
  /// The UI responds to changes in the NewsProvider through the Consumer widget,
  /// automatically rebuilding when the list of saved articles changes.
  /// 
  /// References:
  /// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
  /// - AppBar: https://api.flutter.dev/flutter/material/AppBar-class.html
  /// - Consumer: https://pub.dev/documentation/provider/latest/provider/Consumer-class.html
  /// - Dismissible: https://api.flutter.dev/flutter/widgets/Dismissible-class.html
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Articles'),
            actions: [
              if (newsProvider.savedArticles.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Clear All Saved Articles'),
                          content: const Text(
                            'Are you sure you want to remove all saved articles? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Clear all saved articles
                                final articles = List.from(newsProvider.savedArticles);
                                for (final article in articles) {
                                  newsProvider.removeSavedArticle(article.url);
                                }
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All saved articles removed'),
                                  ),
                                );
                              },
                              child: const Text('Clear All'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  tooltip: 'Clear all saved articles',
                ),
            ],
          ),
          body: newsProvider.savedArticles.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: newsProvider.savedArticles.length,
                  itemBuilder: (context, index) {
                    final article = newsProvider.savedArticles[index];
                    return Dismissible(
                      key: Key(article.url),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Remove Article'),
                              content: Text(
                                'Remove "${article.title}" from saved articles?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Remove'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        newsProvider.removeSavedArticle(article.url);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Article removed from saved'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                newsProvider.saveArticle(article);
                              },
                            ),
                          ),
                        );
                      },
                      child: ArticleCard(
                        article: article,
                        showSaveButton: true,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
