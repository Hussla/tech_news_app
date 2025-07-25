/// Reusable widget for displaying a news article in a card format.
/// 
/// This widget displays a news article with its image, title, description,
/// publication date, and a save button. It uses the following key Flutter components:
/// - [Card] - Provides the card container with elevation and rounded corners
/// - [InkWell] - Makes the card tappable with ripple effect
/// - [Hero] - Enables smooth transitions when navigating to the article detail
/// - [CachedNetworkImage] - Efficiently loads and caches article images
/// - [Consumer] - Connects to the NewsProvider for state management
/// - [ScaffoldMessenger] - Shows snack bars when articles are saved/removed
/// 
/// The widget handles image loading states with:
/// - A shimmer placeholder during loading
/// - An error placeholder if image loading fails
/// 
/// References:
/// - Card Widget: https://api.flutter.dev/flutter/material/Card-class.html
/// - Hero Animations: https://docs.flutter.dev/ui/animations/hero-animations
/// - Image Caching: https://pub.dev/packages/cached_network_image
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tech_news_app/models/article.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/screens/news_detail_screen.dart';
import 'package:intl/intl.dart';

/// A reusable widget that displays a news article in a card format.
/// 
/// This StatelessWidget displays a news article with:
/// - A featured image (with loading and error states)
/// - The article title (with text overflow handling)
/// - A brief description (with text overflow handling)
/// - Publication time (formatted as "X days/hours/minutes ago")
/// - A bookmark button to save/remove the article
/// 
/// The card is tappable and navigates to the NewsDetailScreen when pressed.
/// It uses Hero animations for smooth transitions between screens.
/// 
/// The widget connects to the NewsProvider via Consumer to:
/// - Check if the article is saved
/// - Save or remove the article from the saved list
/// - Show snack bars to confirm save/remove actions
/// 
/// References:
/// - StatelessWidget: https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html
/// - Hero Animations: https://docs.flutter.dev/ui/animations/hero-animations
/// - Consumer Widget: https://pub.dev/documentation/provider/latest/provider/Consumer-class.html
class ArticleCard extends StatelessWidget {
  /// The article to display in the card
  final Article article;

  /// Whether to show the save button (default: true)
  final bool showSaveButton;

  /// Creates an ArticleCard with the specified article and save button visibility
  const ArticleCard({
    super.key,
    required this.article,
    this.showSaveButton = true,
  });

  /// Builds a shimmer placeholder for when the article image is loading.
  /// 
  /// This widget displays a gradient background with a circular progress
  /// indicator in the center, providing visual feedback that the image
  /// is being loaded. The shimmer effect is created using a diagonal
  /// gradient from light grey to white and back to light grey.
  /// 
  /// The placeholder has the same dimensions as the final image (200px height)
  /// to maintain consistent layout during loading.
  /// 
  /// References:
  /// - LinearGradient: https://api.flutter.dev/flutter/painting/LinearGradient-class.html
  /// - CircularProgressIndicator: https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html
  Widget _buildShimmerPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }

  /// Builds an error placeholder for when the article image fails to load.
  /// 
  /// This widget displays a message indicating that the image could not be
  /// loaded, with an appropriate icon and text. It shows:
  /// - An "image not supported" icon
  /// - The message "Image not available"
  /// 
  /// The error placeholder has the same dimensions as the final image
  /// (200px height) to maintain consistent layout when images fail to load.
  /// 
  /// References:
  /// - Icon Widget: https://api.flutter.dev/flutter/widgets/Icon-class.html
  /// - Container Widget: https://api.flutter.dev/flutter/widgets/Container-class.html
  Widget _buildErrorPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats a DateTime as a human-readable relative time string.
  /// 
  /// This method converts a date/time into a friendly relative format
  /// showing how long ago the article was published. It returns:
  /// - "X days ago" for differences greater than 24 hours
  /// - "X hours ago" for differences greater than 60 minutes
  /// - "X minutes ago" for differences greater than 60 seconds
  /// - "Just now" for very recent articles
  /// 
  /// The method handles pluralization correctly (e.g., "1 day ago" vs "2 days ago").
  /// 
  /// References:
  /// - DateTime: https://api.flutter.dev/flutter/dart-core/DateTime-class.html
  /// - Duration: https://api.flutter.dev/flutter/dart-core/Duration-class.html
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Builds the complete article card UI.
  /// 
  /// This method constructs the entire card layout with:
  /// - A Card container with elevation and rounded corners
  /// - An InkWell for tap interaction with ripple effect
  /// - A Hero animation for smooth transitions to the detail screen
  /// - A CachedNetworkImage for the article image with loading/error states
  /// - The article title with text overflow handling
  /// - The article description with text overflow handling
  /// - The publication time formatted as "X days/hours/minutes ago"
  /// - A bookmark button to save/remove the article
  /// 
  /// The widget connects to the NewsProvider via Consumer to:
  /// - Check if the article is saved
  /// - Handle save/remove actions
  /// - Show snack bars to confirm actions
  /// 
  /// References:
  /// - Consumer Widget: https://pub.dev/documentation/provider/latest/provider/Consumer-class.html
  /// - Hero Animations: https://docs.flutter.dev/ui/animations/hero-animations
  /// - CachedNetworkImage: https://pub.dev/packages/cached_network_image
  /// - Card Widget: https://api.flutter.dev/flutter/material/Card-class.html
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        final isSaved = newsProvider.isArticleSaved(article.url);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(article: article),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: Hero(
                        tag: article.url,
                        child: CachedNetworkImage(
                          imageUrl: article.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => _buildShimmerPlaceholder(),
                          errorWidget: (context, url, error) => _buildErrorPlaceholder(),
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 100),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              article.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (showSaveButton)
                            IconButton(
                              icon: Icon(
                                isSaved ? Icons.bookmark : Icons.bookmark_border,
                                color: isSaved ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () {
                                if (isSaved) {
                                  newsProvider.removeSavedArticle(article.url);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Article removed from saved'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  newsProvider.saveArticle(article);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Article saved'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              tooltip: isSaved ? 'Remove from saved' : 'Save article',
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (article.description != null)
                        Text(
                          article.description!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(article.publishedAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
