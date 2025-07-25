/// Search screen for the Tech News application.
/// 
/// This screen provides a comprehensive search interface for finding technology news articles.
/// It features a collapsible app bar with a gradient background, a search field with clear
/// and search buttons, and intelligent empty states for when no results are found.
/// 
/// The screen uses the following key Flutter components:
/// - [NestedScrollView] - Allows the app bar to collapse while scrolling
/// - [SliverAppBar] - Provides the collapsible app bar with flexible space
/// - [RefreshIndicator] - Enables pull-to-refresh functionality
/// - [ListView.builder] - Efficiently displays a list of articles
/// - [Provider] - Connects to the NewsProvider for state management
/// 
/// References:
/// - NestedScrollView: https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
/// - SliverAppBar: https://api.flutter.dev/flutter/material/SliverAppBar-class.html
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// - List Views: https://docs.flutter.dev/ui/widgets/layout#lists
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/widgets/article_card.dart';

/// The main search interface for the Tech News application.
/// 
/// This StatefulWidget provides a comprehensive search experience with:
/// - A collapsible app bar with gradient background
/// - A search field with clear and search functionality
/// - Pull-to-refresh capability
/// - Intelligent empty states for no results
/// - Suggested search terms for better user guidance
/// 
/// The screen connects to the NewsProvider via Provider to access and update
/// the application state, including search queries and article lists.
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// - Search Patterns: https://material.io/design/navigation/search.html
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
      body: NestedScrollView(
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
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1a237e), Color(0xFF303f9f)],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search technology news...',
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
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                newsProvider.fetchTopHeadlines();
                                setState(() {});
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                newsProvider.searchNews(_controller.text);
                              }
                            },
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
    );
  }
}
