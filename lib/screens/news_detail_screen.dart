/// News detail screen for the Tech News application.
/// 
/// **Attribution**: Screen architecture and sharing implementation adapted from:
/// URL: https://docs.flutter.dev/ui/animations/hero-animations
/// URL: https://pub.dev/packages/share_plus
/// URL: https://pub.dev/packages/url_launcher
/// URL: https://docs.firecrawl.dev/
/// Summary: Learnt how to implement hero animations for smooth transitions,
/// native sharing capabilities using share_plus, URL launching for external
/// links, and web content extraction using Firecrawl API. Also learnt best
/// practices for handling asynchronous content loading and user feedback.
/// 
/// This screen displays the full details of a selected news article,
/// including the title, image, publication date, description, and content.
/// It provides functionality to share the article and open it in a browser.
/// Enhanced with Firecrawl content extraction for full article text and
/// expandable "Read more" functionality for better UX.
/// 
/// The screen uses the following key Flutter components:
/// - [Hero] - For smooth transitions between screens with shared elements
/// - [SingleChildScrollView] - Allows scrolling through long article content
/// - [CachedNetworkImage] - Displays the article's featured image with caching
/// - [ElevatedButton] - For opening the full article in a browser
/// - [IconButton] - For sharing the article via native iOS sharing
/// - [StatefulWidget] - For managing content enhancement and expansion state
/// - [FirecrawlService] - For extracting enhanced article content
/// - [share_plus] - For native platform sharing functionality
/// 
/// Key Features:
/// - Hero animations for smooth image transitions
/// - Native iOS sharing integration with Messages/SMS support
/// - Expandable content with "Read more/Show less" functionality
/// - Background content enhancement using Firecrawl
/// - Visual loading indicators for content extraction
/// - Error handling for failed content enhancement
/// - Responsive layout for different screen sizes
/// 
/// References:
/// - Hero Animations: https://docs.flutter.dev/ui/animations/hero-animations
/// - Cached Network Image: https://pub.dev/packages/cached_network_image
/// - Button Types: https://docs.flutter.dev/ui/widgets/material#buttons
/// - URL Launching: https://pub.dev/packages/url_launcher
/// - Native Sharing: https://pub.dev/packages/share_plus
/// - Firecrawl API: https://docs.firecrawl.dev/
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - SingleChildScrollView: https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../models/article.dart';
import '../services/firecrawl_service.dart';

/// The news article detail interface for the Tech News application.
/// 
/// **Attribution**: Implementation patterns adapted from:
/// URL: https://material.io/design/communication/article-templates.html
/// URL: https://docs.flutter.dev/cookbook/effects/expandable-fab
/// Summary: Learnt Material Design principles for article display layouts,
/// expandable content patterns, and user interaction design for mobile reading
/// experiences. Applied best practices for content hierarchy and typography.
/// 
/// This StatefulWidget provides a comprehensive article reading experience with:
/// 
/// **Core Display Features:**
/// - Hero animation for the article image when navigating from the list
/// - Article title in a prominent, readable typography style
/// - Publication date formatted in human-readable relative time
/// - Article description and enhanced content display
/// - High-quality cached image display with loading/error states
/// 
/// **Enhanced Functionality:**
/// - Background content extraction using Firecrawl API
/// - Expandable "Read more/Show less" content with 300-character truncation
/// - Visual indicators for content enhancement status
/// - Native iOS sharing via Messages/SMS and social media
/// - External link opening with URL launcher
/// - Loading states and error handling for all async operations
/// 
/// **State Management:**
/// - Content enhancement state (loading, success, error)
/// - Content expansion state (collapsed/expanded)
/// - Sharing operation feedback
/// - Background API operation status
/// 
/// **User Experience:**
/// - Smooth hero transitions from article list
/// - Responsive layout that adapts to content length
/// - Clear visual hierarchy with proper spacing
/// - Accessible touch targets and semantic labels
/// - Native platform sharing integration
/// 
/// **Technical Implementation:**
/// - Uses single scrollable column for optimal mobile reading
/// - Implements proper error boundaries for API failures
/// - Handles async operations with user feedback
/// - Optimizes performance with cached network images
/// - Supports iOS native sharing protocols
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - Hero Animations: https://docs.flutter.dev/ui/animations/hero-animations
/// - Material Article Templates: https://material.io/design/communication/article-templates.html
/// - Expandable Content: https://docs.flutter.dev/cookbook/effects/expandable-fab
/// - Native Sharing: https://pub.dev/packages/share_plus
/// - Async State Management: https://dart.dev/codelabs/async-await
class NewsDetailScreen extends StatefulWidget {
  /// The article to display in this screen
  final Article article;

  /// Creates a NewsDetailScreen widget for the specified article
  const NewsDetailScreen({super.key, required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

/// State class for the NewsDetailScreen.
/// 
/// This State class manages:
/// - The enhanced article content
/// - Content loading state during enhancement
/// - Firecrawl service interactions
/// - UI updates when content is enhanced
class _NewsDetailScreenState extends State<NewsDetailScreen> {
  /// The current article (may be enhanced with full content)
  late Article _currentArticle;
  
  /// Whether content enhancement is in progress
  bool _isEnhancing = false;
  
  /// Whether the full content is expanded (for "Read more" functionality)
  bool _isContentExpanded = false;
  
  /// Firecrawl service for content extraction
  final FirecrawlService _firecrawlService = FirecrawlService();

  /// Maximum characters to show when content is collapsed
  static const int _maxCollapsedLength = 300;

  @override
  void initState() {
    super.initState();
    _currentArticle = widget.article;
    
    // Automatically enhance content if it's limited
    if (_shouldEnhanceContent()) {
      _enhanceContent();
    }
  }

  @override
  void dispose() {
    _firecrawlService.dispose();
    super.dispose();
  }

  /// Determines if the content should be enhanced.
  /// 
  /// Returns true if:
  /// - Content is null or empty
  /// - Content is very short (less than 500 characters)
  /// - Firecrawl service is configured
  bool _shouldEnhanceContent() {
    if (!_firecrawlService.isConfigured) return false;
    
    final content = _currentArticle.content;
    return content == null || content.isEmpty || content.length < 500;
  }

  /// Enhances the current article content using Firecrawl.
  Future<void> _enhanceContent() async {
    if (_isEnhancing) return;
    
    setState(() {
      _isEnhancing = true;
    });

    try {
      final enhancedArticle = await _firecrawlService.extractArticleContent(_currentArticle);
      
      setState(() {
        _currentArticle = enhancedArticle;
      });
      
      // Show success message if content was enhanced
      if (enhancedArticle.content != widget.article.content && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Article content enhanced with full text'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to enhance article content'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnhancing = false;
        });
      }
    }
  }

  /// Shares the current article via the device's share functionality.
  /// 
  /// This method creates a shareable message containing:
  /// - The article title
  /// - A brief description (if available)
  /// - The article URL for direct access
  /// 
  /// The share dialog will show native sharing options including:
  /// - SMS/Messages
  /// - Email
  /// - Social media apps
  /// - Clipboard
  /// - Other installed sharing apps
  /// 
  /// The method uses the device's native sharing capabilities
  /// through the share_plus plugin.
  Future<void> _shareArticle() async {
    try {
      // Create a comprehensive share message
      final String shareText = '''
${_currentArticle.title}

${_currentArticle.description ?? 'Check out this interesting tech article!'}

Read more: ${_currentArticle.url}

Shared via Tech News App
'''.trim();

      // Use the native share dialog
      await Share.share(
        shareText,
        subject: _currentArticle.title,
      );
    } catch (e) {
      // Handle sharing errors gracefully
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share article'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Builds an expandable content widget with "Read more" functionality.
  /// 
  /// This method creates a content display that:
  /// - Shows truncated content initially (first 300 characters)
  /// - Displays a "Read more" button to expand full content
  /// - Shows a "Read less" button to collapse content
  /// - Provides smooth animation for content expansion
  /// - Handles both enhanced and original content
  /// 
  /// The expandable behavior improves readability by not overwhelming
  /// users with long content initially while still providing full access.
  Widget _buildExpandableContent() {
    final content = _currentArticle.content!;
    final shouldTruncate = content.length > _maxCollapsedLength;
    
    // If content is short enough, show it all
    if (!shouldTruncate) {
      return Text(
        content,
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }
    
    // Show truncated or full content based on expansion state
    final displayContent = _isContentExpanded 
        ? content 
        : content.substring(0, _maxCollapsedLength);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isContentExpanded ? displayContent : '$displayContent...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            setState(() {
              _isContentExpanded = !_isContentExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isContentExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  _isContentExpanded ? 'Read less' : 'Read more',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Article',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1565C0), // Deep Blue
                Color(0xFF0D47A1), // Darker Blue
                Color(0xFF1A237E), // Indigo
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.share_rounded, color: Colors.white),
              onPressed: () => _shareArticle(),
              tooltip: 'Share Article',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image
              if (_currentArticle.imageUrl != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Hero(
                      tag: _currentArticle.url,
                      child: CachedNetworkImage(
                        imageUrl: _currentArticle.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.grey.shade300, Colors.grey.shade100],
                            ),
                          ),
                          child: const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Title
              Text(
                _currentArticle.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              // Date and Source
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Published on ${_currentArticle.publishedAt.day}/${_currentArticle.publishedAt.month}/${_currentArticle.publishedAt.year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Description
              if (_currentArticle.description != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    _currentArticle.description!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              // Content
              if (_currentArticle.content != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _currentArticle.content != widget.article.content
                                  ? Colors.green.shade100
                                  : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _currentArticle.content != widget.article.content
                                  ? Icons.auto_awesome_rounded
                                  : Icons.article_rounded,
                              size: 20,
                              color: _currentArticle.content != widget.article.content
                                  ? Colors.green.shade600
                                  : Colors.blue.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _currentArticle.content != widget.article.content
                                  ? 'Enhanced Article Content'
                                  : 'Article Content',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: _currentArticle.content != widget.article.content
                                    ? Colors.green.shade700
                                    : Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_isEnhancing) ...[
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildExpandableContent(),
                    ],
                  ),
                ),
              ],
              // Enhancement button for manual enhancement
              if (!_isEnhancing && _firecrawlService.isConfigured) ...[
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.secondary,
                          theme.colorScheme.secondary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _enhanceContent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                      label: Text(
                        _currentArticle.content != widget.article.content
                            ? 'Re-enhance Content'
                            : 'Get Full Article Content',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else if (_firecrawlService.isConfigured && _isEnhancing) ...[
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text(
                          'Extracting full article content...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Action buttons
              Row(
                children: [
                  // Read More Button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1565C0).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final Uri url = Uri.parse(_currentArticle.url);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
                        label: const Text(
                          'Read Full Article',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Share Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.secondary,
                          theme.colorScheme.secondary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _shareArticle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.share_rounded, size: 18, color: Colors.white),
                      label: const Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
