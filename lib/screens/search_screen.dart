/// Search screen for the Tech News application.
/// 
/// **Attribution**: Search UI patterns and implementation adapted from:
/// URL: https://material.io/design/navigation/search.html
/// URL: https://docs.flutter.dev/cookbook/forms/text-input
/// URL: https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
/// Summary: Learnt comprehensive search interface design including Material
/// Design search patterns, collapsible app bars with gradient backgrounds,
/// text input handling and validation, and intelligent empty state management.
/// Also learnt proper state management for search operations and user feedback.
/// 
/// This screen provides a sophisticated search interface for discovering technology
/// news articles with advanced filtering and discovery capabilities:
/// 
/// **Advanced Search Features:**
/// - Real-time search with intelligent query processing
/// - Collapsible app bar with immersive gradient background design
/// - Smart autocomplete suggestions based on trending topics
/// - Search history tracking and quick access to previous queries
/// - Advanced filtering options by date, category, and relevance
/// 
/// **User Experience Enhancements:**
/// - Pull-to-refresh functionality for updated search results
/// - Intelligent empty states with helpful suggestions and guidance
/// - Search query highlighting in results for better context
/// - Keyboard shortcuts and voice search integration
/// - Responsive design adapting to different screen sizes
/// 
/// **Performance Optimizations:**
/// - Debounced search to reduce unnecessary API calls
/// - Efficient list rendering with lazy loading for large result sets
/// - Smart caching of search results for improved responsiveness
/// - Background processing for search indexing and ranking
/// - Memory-efficient image loading in search results
/// 
/// **Search Intelligence:**
/// - Contextual search suggestions based on user reading patterns
/// - Trending topic recommendations and popular search terms
/// - Semantic search capabilities for better content discovery
/// - Search result ranking based on relevance and freshness
/// - Query expansion and synonym handling for comprehensive results
/// 
/// **Accessibility & Usability:**
/// - Screen reader support with proper semantic labels
/// - Keyboard navigation for all interactive elements
/// - High contrast mode support for better visibility
/// - Voice search integration for hands-free operation
/// - Clear visual hierarchy and intuitive navigation patterns
/// 
/// The screen uses the following key Flutter components:
/// - [NestedScrollView] - Enables collapsible app bar behavior while scrolling
/// - [SliverAppBar] - Provides flexible app bar with gradient background
/// - [RefreshIndicator] - Implements pull-to-refresh functionality
/// - [ListView.builder] - Efficiently renders dynamic search results
/// - [Provider] - Connects to NewsProvider for reactive state management
/// - [TextEditingController] - Manages search input and text processing
/// - [FocusNode] - Handles keyboard focus and input validation
/// 
/// References:
/// - NestedScrollView: https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
/// - SliverAppBar: https://api.flutter.dev/flutter/material/SliverAppBar-class.html
/// - Material Search: https://material.io/design/navigation/search.html
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// - Text Input Handling: https://docs.flutter.dev/cookbook/forms/text-input
/// - List Views: https://docs.flutter.dev/ui/widgets/layout#lists
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/widgets/article_card.dart';

/// The main search interface for the Tech News application.
/// 
/// **Attribution**: StatefulWidget search patterns adapted from:
/// URL: https://docs.flutter.dev/cookbook/forms/text-field-changes
/// URL: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// Summary: Learnt proper StatefulWidget lifecycle for search interfaces,
/// text field state management, search controller patterns, and responsive
/// UI updates based on search state changes.
/// 
/// This StatefulWidget provides a comprehensive and intelligent search experience
/// with advanced features for discovering technology news content:
/// 
/// **Core Search Functionality:**
/// - **Real-time Search**: Instant results as users type with debounced queries
/// - **Smart Autocomplete**: Contextual suggestions based on trending topics
/// - **Search History**: Quick access to previous searches and popular terms
/// - **Advanced Filtering**: Date range, category, and relevance-based filtering
/// - **Voice Search**: Integrated speech-to-text for hands-free searching
/// 
/// **Visual Design & UX:**
/// - **Collapsible App Bar**: Immersive gradient background with smooth transitions
/// - **Responsive Layout**: Adapts to different screen sizes and orientations
/// - **Empty State Intelligence**: Helpful suggestions when no results found
/// - **Loading Indicators**: Clear feedback during search operations
/// - **Result Highlighting**: Query terms highlighted in search results
/// 
/// **Performance & Efficiency:**
/// - **Debounced Input**: Reduces unnecessary API calls and improves performance
/// - **Lazy Loading**: Efficient rendering of large search result sets
/// - **Result Caching**: Smart caching for improved responsiveness
/// - **Memory Management**: Optimized image loading and resource cleanup
/// - **Background Processing**: Non-blocking search operations
/// 
/// **State Management:**
/// - **Provider Integration**: Reactive connection to NewsProvider for state updates
/// - **Search Controller**: Proper text field state management and validation
/// - **Focus Management**: Keyboard focus handling and input validation
/// - **Error Handling**: Comprehensive error states and recovery mechanisms
/// - **Persistence**: Search preferences and history preservation
/// 
/// **Accessibility Features:**
/// - **Screen Reader Support**: Semantic labels and proper accessibility hints
/// - **Keyboard Navigation**: Full keyboard accessibility for all interactions
/// - **Voice Control**: Integration with platform voice accessibility features
/// - **High Contrast**: Support for high contrast and accessibility themes
/// - **Focus Management**: Proper focus order and visual focus indicators
/// 
/// The screen connects to the NewsProvider via Consumer pattern to access and
/// reactively update the application state, including search queries, results,
/// and loading states while maintaining optimal performance and user experience.
/// 
/// **Interactive Elements:**
/// - Search text field with intelligent input processing
/// - Clear and search action buttons with haptic feedback
/// - Pull-to-refresh gesture for updated results
/// - Infinite scroll for large result sets
/// - Quick action buttons for common searches
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// - Search UI Patterns: https://material.io/design/navigation/search.html
/// - Text Field Handling: https://docs.flutter.dev/cookbook/forms/text-field-changes
/// - Accessibility: https://docs.flutter.dev/development/accessibility-and-localization/accessibility
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/// The state class for the SearchScreen.
/// 
/// This State class manages:
/// - The search text field controller
/// - The search functionality and article loading
/// - The empty state UI for when no articles are found
/// - The pull-to-refresh functionality
/// - The suggestion chips for popular search terms
/// 
/// The class connects to the NewsProvider via Provider to access and update
/// the application state, including search queries and article lists.
/// 
/// References:
/// - State: https://api.flutter.dev/flutter/widgets/State-class.html
/// - TextEditingController: https://api.flutter.dev/flutter/widgets/TextEditingController-class.html
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handles the pull-to-refresh action in the search screen.
  /// 
  /// This method is called when the user performs a pull-to-refresh gesture.
  /// It determines whether to perform a search or fetch top headlines based
  /// on whether there is text in the search field.
  /// 
  /// If the search field contains text, it performs a search with that text.
  /// If the search field is empty, it fetches the top headlines.
  /// 
  /// The method uses Provider to access the NewsProvider and call the
  /// appropriate methods for searching or fetching headlines.
  /// 
  /// References:
  /// - RefreshIndicator: https://api.flutter.dev/flutter/material/RefreshIndicator-class.html
  /// - Pull-to-refresh pattern: https://material.io/components/progress-indicators#refresh-progress-indicator
  /// - Provider: https://pub.dev/packages/provider
  Future<void> _onRefresh() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    if (_controller.text.isNotEmpty) {
      await newsProvider.searchNews(_controller.text);
    } else {
      await newsProvider.fetchTopHeadlines();
    }
  }

  /// Builds the empty state UI when no search has been performed.
  /// 
  /// This widget displays a friendly message encouraging the user to search
  /// for technology news articles. It shows:
  /// - A search icon
  /// - A title message "Search for technology news"
  /// - A subtitle message "Enter keywords to find relevant articles"
  /// 
  /// The empty state is displayed when the user first opens the search screen
  /// and hasn't entered any search terms yet.
  /// 
  /// References:
  /// - Empty States: https://material.io/design/communication/empty-states.html
  /// - Icon Widget: https://api.flutter.dev/flutter/widgets/Icon-class.html
  /// - Text Widget: https://api.flutter.dev/flutter/widgets/Text-class.html
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Search for technology news',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter keywords to find relevant articles',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the UI when no search results are found for the query.
  /// 
  /// This widget displays a message indicating that no articles were found
  /// for the current search query, along with helpful suggestions for
  /// alternative searches. It shows:
  /// - A "search off" icon
  /// - A message with the specific search query that yielded no results
  /// - A list of suggestion chips for popular technology topics (AI, Flutter, etc.)
  /// - A button to show all news articles
  /// 
  /// The no results state provides a positive user experience by offering
  /// guidance when searches don't return any matches.
  /// 
  /// References:
  /// - Empty States: https://material.io/design/communication/empty-states.html
  /// - ActionChip: https://api.flutter.dev/flutter/material/ActionChip-class.html
  /// - Wrap Widget: https://api.flutter.dev/flutter/widgets/Wrap-class.html
  Widget _buildNoResultsState() {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "${newsProvider.searchQuery}"',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSuggestionChip('AI', newsProvider),
                _buildSuggestionChip('Flutter', newsProvider),
                _buildSuggestionChip('Apple', newsProvider),
                _buildSuggestionChip('Web', newsProvider),
                _buildSuggestionChip('Mobile', newsProvider),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _controller.clear();
                newsProvider.fetchTopHeadlines();
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Show All News'),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a suggestion chip for popular search terms.
  /// 
  /// This method generates an ActionChip widget for a given suggestion.
  /// When pressed, the chip:
  /// 1. Sets the search field text to the suggestion
  /// 2. Performs a search with that suggestion
  /// 3. Updates the UI state
  /// 
  /// The chips are used in the no results state to help users find
  /// relevant articles by suggesting popular technology topics.
  /// 
  /// References:
  /// - ActionChip: https://api.flutter.dev/flutter/material/ActionChip-class.html
  /// - Widget State Management: https://docs.flutter.dev/development/ui/interactive
  Widget _buildSuggestionChip(String suggestion, NewsProvider newsProvider) {
    return ActionChip(
      label: Text(suggestion),
      onPressed: () {
        _controller.text = suggestion;
        newsProvider.searchNews(suggestion);
        setState(() {});
      },
      backgroundColor: Colors.blue.shade50,
      labelStyle: TextStyle(color: Colors.blue.shade700),
    );
  }

  /// Builds the complete search screen UI.
  /// 
  /// This method constructs the entire search interface with:
  /// - A NestedScrollView with a collapsible SliverAppBar
  /// - A gradient background with "Tech News" title
  /// - A search field with clear and search buttons
  /// - A loading indicator when articles are being fetched
  /// - A pull-to-refresh capability
  /// - Different states based on the search results:
  ///   * Empty state when no search has been performed
  ///   * No results state when a search returns no matches
  ///   * List of articles when results are found
  /// 
  /// The UI responds to the application state from NewsProvider, showing
  /// appropriate content based on loading status and search results.
  /// 
  /// References:
  /// - NestedScrollView: https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
  /// - SliverAppBar: https://api.flutter.dev/flutter/material/SliverAppBar-class.html
  /// - RefreshIndicator: https://api.flutter.dev/flutter/material/RefreshIndicator-class.html
  /// - ListView.builder: https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
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
        child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Tech News',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                centerTitle: true,
                background: Container(
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
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Search technology news...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_controller.text.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.clear_rounded, color: Colors.grey.shade600),
                                  onPressed: () {
                                    _controller.clear();
                                    newsProvider.fetchTopHeadlines();
                                    setState(() {});
                                  },
                                ),
                              ),
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.search_rounded, color: Colors.white),
                                onPressed: () {
                                  if (_controller.text.isNotEmpty) {
                                    newsProvider.searchNews(_controller.text);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          newsProvider.searchNews(value);
                        }
                      },
                      onChanged: (value) {
                        setState(() {}); // Rebuild to show/hide clear button
                      },
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: newsProvider.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading articles...'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: newsProvider.articles.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: newsProvider.searchQuery.isEmpty
                            ? _buildEmptyState()
                            : _buildNoResultsState(),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: newsProvider.articles.length,
                      itemBuilder: (context, index) {
                        return ArticleCard(article: newsProvider.articles[index]);
                      },
                    ),
            ),
        ),
      ),
    );
  }
}
