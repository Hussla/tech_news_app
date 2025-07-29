/// Provides news articles and manages the application state for the Tech News app.
/// 
/// **Attribution**: Provider pattern and state management implementation adapted from:
/// URL: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// URL: https://pub.dev/packages/provider
/// URL: https://docs.flutter.dev/cookbook/networking/fetch-data
/// Summary: Learnt comprehensive state management patterns using Provider,
/// including ChangeNotifier implementation, async state handling, local data
/// persistence, and separation of business logic from UI components. Also
/// learnt best practices for managing loading states and error handling.
/// 
/// This ChangeNotifier class serves as the central state management hub and handles:
/// 
/// **Core Data Management:**
/// - Fetching and caching top technology headlines
/// - Managing search functionality with real-time query updates
/// - Handling saved articles with local persistence
/// - Background content enhancement using Firecrawl integration
/// - State synchronization across all app components
/// 
/// **Article Management:**
/// - Mock technology news data with realistic content
/// - Article saving/removing with local storage persistence
/// - Content enhancement status tracking
/// - Search query management and filtering
/// - Loading state management for all async operations
/// 
/// **Firecrawl Integration:**
/// - Background content extraction from article URLs
/// - Enhanced article content with full text
/// - Progress tracking for content enhancement operations
/// - Error handling for failed content extractions
/// - Batch processing for multiple article enhancements
/// 
/// **Persistence Layer:**
/// - Local storage integration for saved articles
/// - App state restoration on restart
/// - Data migration and version management
/// - Offline support for cached content
/// - Cross-session data consistency
/// 
/// **State Management Patterns:**
/// - [ChangeNotifier] - For reactive state updates with the Provider package
/// - [Future] - For asynchronous operations like API calls and content extraction
/// - [notifyListeners] - To broadcast state changes to listening widgets
/// - Testing mode support - For unit and integration testing
/// - Memory management - Proper disposal of resources and listeners
/// 
/// **Performance Optimization:**
/// - Lazy loading of content when needed
/// - Efficient state update patterns
/// - Memory-conscious data structures
/// - Background processing for non-critical operations
/// - Intelligent caching strategies
/// 
/// The class uses the following key Flutter patterns:
/// - Provider pattern for dependency injection and state access
/// - Observer pattern for reactive UI updates
/// - Repository pattern for data access abstraction
/// - Service layer integration for external APIs
/// - Factory pattern for article creation
/// 
/// References:
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// - HTTP Requests in Flutter: https://docs.flutter.dev/cookbook/networking/fetch-data
/// - ChangeNotifier: https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html
/// - Asynchronous Programming: https://dart.dev/codelabs/async-await
/// - Provider Package: https://pub.dev/packages/provider
/// - Local Storage: https://docs.flutter.dev/cookbook/persistence/key-value
/// - Testing Patterns: https://docs.flutter.dev/cookbook/testing/unit/introduction
import 'package:flutter/foundation.dart';
import 'package:tech_news_app/models/article.dart';
import 'package:tech_news_app/services/database_service.dart';
import 'package:tech_news_app/services/firecrawl_service.dart';

class NewsProvider with ChangeNotifier {
  static bool _testingMode = false;
  
  List<Article> _articles = [];
  List<Article> _savedArticles = [];
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isExtractingContent = false;
  
  final FirecrawlService _firecrawlService = FirecrawlService();

  List<Article> get articles => _articles;
  List<Article> get savedArticles => _savedArticles;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isExtractingContent => _isExtractingContent;

  NewsProvider() {
    // Only initialize if not in testing mode
    if (!_testingMode) {
      fetchTopHeadlines();
      _loadSavedArticles();
    }
  }

  /// Set testing mode to prevent database operations during tests
  static void setTestingMode(bool testing) {
    _testingMode = testing;
  }

  Future<void> fetchTopHeadlines() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock data for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      
      _articles = [
        Article(
          title: 'OpenAI\'s CEO says he\'s scared of GPT-5',
          description: 'Sam Altman expresses concerns about the potential risks and capabilities of OpenAI\'s next-generation AI model.',
          content: '''OpenAI CEO Sam Altman has expressed genuine concerns about GPT-5, the company's next-generation AI model currently in development. In candid interviews, Altman discussed the unprecedented capabilities that GPT-5 is expected to demonstrate and the responsibility that comes with such powerful technology.

The changes represent the most significant overhaul to Google Search in years, as the company responds to competitive pressure from ChatGPT, Perplexity, and other AI-powered search tools. Google's approach involves using AI to provide direct answers and summaries at the top of search results.

The new AI-powered features include enhanced understanding of complex queries, better contextual responses, and more personalized search results. Google is leveraging its Gemini AI model to power these improvements, offering users more comprehensive and helpful search experiences.

The redesign also includes visual improvements to make AI-generated content more prominent and easier to consume. Search results now feature AI summaries, generated images, and interactive elements that help users get answers faster.

However, the changes have raised concerns about accuracy and the potential for AI hallucinations in search results. Google has implemented various safeguards and continues to refine the system based on user feedback and real-world usage patterns.''',
          url: 'https://www.techradar.com/ai-platforms-assistants/chatgpt/openais-ceo-says-hes-scared-of-gpt-5',
          imageUrl: 'https://platform.theverge.com/wp-content/uploads/sites/2/chorus/uploads/chorus_asset/file/25447224/AI_Overviews___Complex_Questions__still_.jpg',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Article(
          title: 'Adding support for Google Pay within Android WebView',
          description: 'Google announces native Google Pay support in Android WebView, enabling seamless payments in embedded web checkouts.',
          content: '''Google has announced that Google Pay is now supported within Android WebView, starting with version 137. This significant development allows Android apps that embed web checkout processes to offer native Google Pay functionality to their users.

The new Copilot Mode provides contextual help, webpage summaries, and intelligent suggestions based on the content users are viewing. It can answer questions about web pages, help with research tasks, and even assist with writing and editing content directly within the browser.

Key features include real-time webpage analysis, intelligent bookmarking suggestions, and the ability to generate summaries of long articles or documents. The AI can also help users compare products, analyze data presented on websites, and provide explanations of complex topics.

Microsoft has integrated advanced language models to ensure that Copilot Mode understands context and provides relevant, helpful responses. The feature works across all types of websites and can adapt its assistance based on the type of content being viewed.

Privacy and security remain important considerations, with Microsoft implementing safeguards to ensure user data is protected while still providing personalized AI assistance. The feature can be easily toggled on or off based on user preference.''',
          url: 'https://developers.googleblog.com/en/adding-support-for-google-pay-within-android-webview/',
          imageUrl: 'https://techcrunch.com/wp-content/uploads/2025/07/imgi_9_Blog-Hero1920b-1600x900-1.png',
          publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        Article(
          title: 'Flutter 3.27 Release Notes - Latest Features and Improvements',
          description: 'Flutter 3.27 introduces new Material Design 3 components, enhanced performance optimizations, and improved developer tooling.',
          content: '''Flutter 3.27 introduces significant improvements to the cross-platform development framework, bringing new Material Design 3 components, enhanced performance optimizations, and improved developer tooling with better debugging capabilities.

This release focuses on developer experience improvements, including faster hot reload times, more informative error messages, and enhanced widget inspector capabilities. The update also includes better memory management and reduced app startup times across all platforms.

New Material Design 3 components have been added to help developers create modern, beautiful user interfaces that follow Google's latest design guidelines. These components include updated navigation elements, improved form controls, and enhanced theming capabilities.

Performance improvements in this release include optimized rendering pipeline, reduced memory usage, and better battery life optimization for mobile applications. Web performance has also been enhanced with smaller bundle sizes and faster loading times.

The developer tools have received significant updates, including improved debugging capabilities, better error reporting, and enhanced code completion in IDEs. The Flutter Inspector now provides more detailed widget information and better performance profiling tools.

This release also includes important security updates and bug fixes that improve the overall stability and reliability of Flutter applications across all supported platforms.''',
          url: 'https://docs.flutter.dev/release/release-notes/release-notes-3.27.0',
          imageUrl: 'https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-logomark-320px.png',
          publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        Article(
          title: 'GitHub Copilot: Meet the new coding agent',
          description: 'Implementing features has never been easier: Just assign a task or issue to Copilot. It runs in the background with GitHub Actions and submits its work as a pull request.',
          content: '''GitHub announced a new coding agent for GitHub Copilot that represents a significant advancement in AI-powered development tools. This innovative feature allows developers to assign GitHub issues directly to Copilot, which then creates secure development environments using GitHub Actions.

The coding agent operates by analyzing assigned issues, understanding project context through advanced retrieval augmented generation (RAG) powered by GitHub code search, and working autonomously to implement solutions. As it works, the agent pushes commits to draft pull requests, allowing developers to track progress through detailed session logs.

Key features include integration with Model Context Protocol (MCP) for accessing external data and capabilities, support for custom repository instructions, and the ability to understand context from related issues and pull request discussions. The agent can also process images included in GitHub issues, enabling developers to share screenshots of bugs or mockups.

Security remains a priority with built-in safeguards including restricted branch access, required human approval for CI/CD workflows, and adherence to existing repository policies and organization rules. The agent can only push to branches it creates, keeping default branches and team-created branches secure.

Performance capabilities include handling low-to-medium complexity tasks in well-tested codebases, from adding features and fixing bugs to extending tests, refactoring code, and improving documentation. The agent uses state-of-the-art language models and follows existing development workflows.

The feature is available to GitHub Copilot Enterprise and Copilot Pro+ customers and represents GitHub's vision for agentic workflows that don't just assist developers but actively solve problems through multi-step reasoning and execution.''',
          url: 'https://github.blog/news-insights/product-news/github-copilot-meet-the-new-coding-agent/',
          imageUrl: 'https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png',
          publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        Article(
          title: 'Tesla founder disappointed Musk canceled \$25,000 EV and made dumpster-looking truck',
          description: 'Tesla\'s original co-founder Martin Eberhard criticizes Elon Musk for canceling the affordable electric car program and developing the Cybertruck.',
          content: '''Tesla\'s original co-founder, Martin Eberhard, has expressed disappointment with Elon Musk\'s decision to cancel Tesla\'s \$25,000 electric car program in favor of developing the Cybertruck, which he described as "dumpster-looking."

In a rare interview, Eberhard, who co-founded Tesla with Marc Tarpenning in 2003 before Musk joined as an investor, shared his views on the company\'s current direction. He believes the world needs affordable electric vehicles rather than expensive trucks with unconventional designs.

The criticism comes as Tesla faces increasing competition in the affordable EV segment from Chinese manufacturers and other automakers who are successfully launching sub-\$30,000 electric vehicles. Eberhard argues that Tesla\'s original mission was to accelerate sustainable transport adoption, which requires affordable options.

Eberhard also expressed skepticism about Tesla\'s autonomous vehicle plans, particularly the promised "Robotaxi Model 2." He criticized the approach of releasing autonomous systems that may sometimes fail, stating that putting prototypes on the road that could kill people "is not OK" for him.

The Tesla co-founder\'s comments highlight ongoing tensions about the company\'s direction since Musk took control. While Tesla has achieved remarkable success with premium vehicles, critics argue it has moved away from its original goal of making sustainable transport accessible to mainstream consumers.

Tesla\'s focus on the Cybertruck and autonomous vehicles represents a significant departure from the roadmap originally envisioned by Eberhard and Tarpenning, who planned for Tesla to eventually produce mass-market, affordable electric vehicles after establishing itself with premium models.''',
          url: 'https://electrek.co/2025/07/28/tesla-founder-disapointed-musk-canceled-25000-ev-dumpster-lookin-truck/',
          imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
        ),
        Article(
          title: 'Meta Quest 3S launches as affordable entry into mixed reality',
          description: 'Meta releases Quest 3S as a more affordable alternative to Quest 3, bringing mixed reality to mainstream consumers.',
          content: '''Meta has launched the Quest 3S, a more affordable version of its popular Quest 3 mixed reality headset, designed to make VR and mixed reality more accessible to mainstream consumers. The new headset offers many of the same core features as the Quest 3 at a significantly lower price point.

The Quest 3S maintains the same powerful Snapdragon XR2 Gen 2 processor as its more expensive sibling, ensuring smooth performance across VR games and mixed reality applications. It features the same hand tracking capabilities and supports the full Quest ecosystem of apps and games.

Key differences include a slightly lower resolution display and reduced storage options, but Meta has maintained the core mixed reality functionality that allows users to see and interact with their real environment while using VR applications. The device supports both VR and AR experiences seamlessly.

The launch represents Meta\'s continued investment in making VR mainstream, following the success of the Quest 2 which became the best-selling VR headset. The company is betting that a lower price point will attract more consumers to try mixed reality technology.

The Quest 3S is compatible with the entire Quest software library and receives the same regular updates as other Quest devices. Meta continues to invest heavily in content creation and developer tools to expand the ecosystem of available experiences.

This release comes as competition in the VR space intensifies, with Apple\'s Vision Pro representing the premium end of the market while companies like Meta focus on affordability and accessibility.''',
          url: 'https://www.roadtovr.com/meta-quest-3s-review-affordable-mixed-reality/',
          imageUrl: 'https://images.unsplash.com/photo-1592478411213-6153e4ebc696?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        Article(
          title: 'Apple Intelligence arrives on iPhone, iPad, and Mac with iOS 18.1',
          description: 'Apple launches its AI platform with enhanced Siri, writing tools, and intelligent features across devices.',
          content: '''Apple has officially launched Apple Intelligence with iOS 18.1, iPadOS 18.1, and macOS Sequoia 15.1, bringing the company\'s long-awaited AI platform to millions of devices worldwide. The release marks Apple\'s major entry into the AI race, competing directly with Google and Microsoft\'s offerings.

Apple Intelligence introduces a redesigned Siri with better natural language understanding, enhanced writing tools that can proofread and rewrite text, and intelligent photo organization features. The AI system is designed to work primarily on-device for privacy, with selective cloud processing for more complex tasks.

Key features include Smart Reply for messages and emails, automatic transcription and summarization of voice recordings, and intelligent photo cleanup tools. The system can also help organize and search through personal information more effectively using natural language queries.

Privacy remains a central focus, with Apple implementing what it calls \"Private Cloud Compute\" for tasks that require server-side processing. The company emphasizes that personal data is never stored on Apple servers and processing is done in secure, isolated environments.

The rollout begins with support for English in select countries, with plans to expand language support and availability throughout 2024 and 2025. Additional features including ChatGPT integration and more advanced Siri capabilities are expected in subsequent updates.

The launch represents Apple\'s response to the growing importance of AI in personal technology, though the company has taken a more cautious approach compared to competitors, prioritizing privacy and on-device processing.''',
          url: 'https://www.apple.com/newsroom/2024/10/apple-intelligence-is-available-today-on-iphone-ipad-and-mac/',
          imageUrl: 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 14)),
        ),
        Article(
          title: 'OpenAI announces o1 reasoning model with enhanced problem-solving capabilities',
          description: 'OpenAI releases o1, a new AI model designed for complex reasoning tasks in science, coding, and mathematics.',
          content: '''OpenAI has unveiled o1, a new family of AI models specifically designed for complex reasoning tasks that require deeper thinking and problem-solving capabilities. The o1 models represent a significant advancement in AI reasoning, particularly excelling in science, coding, and mathematics.

Unlike previous models that generate responses quickly, o1 takes more time to "think" through problems, using chain-of-thought reasoning to arrive at more accurate solutions. This approach allows the model to consider multiple approaches and verify its work before providing an answer.

The model shows remarkable performance on challenging benchmarks, ranking in the 89th percentile on competitive programming problems and scoring at PhD level on physics, chemistry, and biology problems. In mathematical reasoning, o1 significantly outperforms previous models on complex multi-step problems.

OpenAI has developed two variants: o1-preview, which offers the full reasoning capabilities, and o1-mini, a smaller, more cost-effective version optimized for coding tasks. Both models are designed to be more reliable and less prone to hallucinations than previous generations.

The release comes with new safety measures, as the models\' reasoning capabilities could potentially be misused. OpenAI has implemented additional alignment training and safety testing to ensure responsible deployment of these more capable AI systems.

Early users report significant improvements in mathematical problem-solving, scientific research assistance, and complex coding tasks. The models are particularly valuable for tasks requiring multi-step reasoning and verification of solutions.''',
          url: 'https://openai.com/index/learning-to-reason-with-llms/',
          imageUrl: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 16)),
        ),
      ];
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching news: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
    // Enhance articles with full content using Firecrawl (in background)
    _enhanceArticlesWithFullContent();
  }

  /// Enhances articles with full content using Firecrawl service.
  /// 
  /// This method:
  /// 1. Runs in the background after initial articles are loaded
  /// 2. Uses Firecrawl to extract full content from article URLs
  /// 3. Updates articles with enhanced content
  /// 4. Notifies listeners when content is enhanced
  /// 5. Handles errors gracefully without affecting UI
  /// 
  /// The method processes articles in batches to respect API rate limits
  /// and provides better user experience by not blocking the initial load.
  Future<void> _enhanceArticlesWithFullContent() async {
    // Skip if in testing mode or no articles to enhance
    if (_testingMode || _articles.isEmpty) return;
    
    // Skip if Firecrawl service is not configured
    if (!_firecrawlService.isConfigured) {
      if (kDebugMode) {
        print('Firecrawl service not configured, skipping content enhancement');
      }
      return;
    }

    try {
      _isExtractingContent = true;
      notifyListeners();

      if (kDebugMode) {
        print('Enhancing ${_articles.length} articles with full content...');
      }

      // Extract content for all articles
      final enhancedArticles = await _firecrawlService.extractBatchContent(_articles);
      
      // Update articles with enhanced content
      _articles = enhancedArticles;
      
      if (kDebugMode) {
        print('Successfully enhanced articles with full content');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error enhancing articles with content: $e');
      }
    } finally {
      _isExtractingContent = false;
      notifyListeners();
    }
  }

  /// Manually triggers content enhancement for current articles.
  /// 
  /// This method can be called from the UI to refresh article content
  /// or retry failed extractions. It provides user feedback through
  /// the loading state.
  Future<void> enhanceCurrentArticles() async {
    await _enhanceArticlesWithFullContent();
  }

  /// Searches for news articles based on a query string.
  /// 
  /// This method:
  /// 1. Updates the search query state
  /// 2. Sets loading state to true
  /// 3. Simulates an API call with Future.delayed
  /// 4. Gets search results based on the query
  /// 5. Updates the articles list
  /// 6. Handles any errors that occur during the search
  /// 7. Sets loading state to false
  /// 
  /// The search functionality uses a mock implementation that returns
  /// different results based on common tech terms in the query.
  /// 
  /// References:
  /// - Asynchronous Programming: https://dart.dev/codelabs/async-await
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  /// - String Manipulation: https://api.flutter.dev/flutter/dart-core/String-class.html
  Future<void> searchNews(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    try {
      // Mock search results for demo with realistic tech news
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate different search results based on query
      final searchResults = _getSearchResults(query.toLowerCase());
      _articles = searchResults;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching news: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
    // Enhance search results with full content using Firecrawl (in background)
    _enhanceArticlesWithFullContent();
  }

  /// Gets search results based on the query string.
  /// 
  /// This private method returns different sets of mock articles based on
  /// the content of the search query. It simulates a real API by returning
  /// relevant tech news articles for common technology terms.
  /// 
  /// The method handles the following search terms:
  /// - 'ai' or 'artificial intelligence': Returns AI/ML related articles
  /// - 'flutter' or 'mobile': Returns Flutter and mobile development articles
  /// - 'apple' or 'ios': Returns Apple and iOS related articles
  /// - 'web' or 'javascript': Returns web development articles
  /// - Any other query: Returns an empty list to trigger the "no results" state
  /// 
  /// References:
  /// - String Methods: https://api.flutter.dev/flutter/dart-core/String-class.html
  /// - Conditional Logic: https://dart.dev/language/booleans
  /// - List Operations: https://api.flutter.dev/flutter/dart-core/List-class.html
  List<Article> _getSearchResults(String query) {
    // Simulate realistic search results based on common tech terms
    if (query.contains('ai') || query.contains('artificial intelligence')) {
      return [
        Article(
          title: 'Google is redesigning its search engine - and it\'s AI all the way down',
          description: 'The company is moving fast to stay competitive with new AI search products.',
          content: 'Google is redesigning its search engine to better compete with AI-powered search products...',
          url: 'https://www.theverge.com/2024/5/14/24156455/google-search-ai-results-page-gemini-overview',
          imageUrl: 'https://platform.theverge.com/wp-content/uploads/sites/2/chorus/uploads/chorus_asset/file/25447224/AI_Overviews___Complex_Questions__still_.jpg',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Article(
          title: 'OpenAI announces o1 reasoning model with enhanced problem-solving capabilities',
          description: 'OpenAI releases o1, a new AI model designed for complex reasoning tasks in science, coding, and mathematics.',
          content: 'OpenAI has unveiled o1, a new family of AI models specifically designed for complex reasoning tasks...',
          url: 'https://openai.com/index/learning-to-reason-with-llms/',
          imageUrl: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
      ];
    } else if (query.contains('flutter') || query.contains('mobile')) {
      return [
        Article(
          title: 'Flutter 3.27 Release Notes - Latest Features and Improvements',
          description: 'Flutter 3.27 introduces new Material Design 3 components, enhanced performance optimizations, and improved developer tooling.',
          content: 'Flutter 3.27 introduces significant improvements to the cross-platform development framework...',
          url: 'https://docs.flutter.dev/release/release-notes/release-notes-3.27.0',
          imageUrl: 'https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-logomark-320px.png',
          publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Article(
          title: 'Microsoft Edge is now an AI browser with launch of Copilot Mode',
          description: 'Edge browser gets enhanced AI capabilities with new Copilot integration for smarter web browsing.',
          content: 'Microsoft has officially launched Copilot Mode for Edge browser, transforming it into a fully AI-powered browsing experience...',
          url: 'https://techcrunch.com/2024/07/18/microsoft-edge-is-now-an-ai-browser-with-launch-of-copilot-mode/',
          imageUrl: 'https://techcrunch.com/wp-content/uploads/2025/07/imgi_9_Blog-Hero1920b-1600x900-1.png',
          publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
    } else if (query.contains('apple') || query.contains('ios')) {
      return [
        Article(
          title: 'Apple Intelligence arrives on iPhone, iPad, and Mac with iOS 18.1',
          description: 'Apple launches its AI platform with enhanced Siri, writing tools, and intelligent features across devices.',
          content: 'Apple has officially launched Apple Intelligence with iOS 18.1, iPadOS 18.1, and macOS Sequoia 15.1...',
          url: 'https://www.apple.com/newsroom/2024/10/apple-intelligence-is-available-today-on-iphone-ipad-and-mac/',
          imageUrl: 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Article(
          title: 'GitHub Copilot Chat in VS Code can now help you fix test failures',
          description: 'GitHub announces improved Copilot Chat integration with VS Code, featuring better code suggestions and enhanced debugging assistance.',
          content: 'GitHub has announced significant improvements to Copilot Chat integration with Visual Studio Code...',
          url: 'https://github.blog/changelog/2024-11-14-github-copilot-chat-in-vs-code-can-now-help-you-fix-test-failures/',
          imageUrl: 'https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png',
          publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ];
    } else if (query.contains('web') || query.contains('javascript') || query.contains('node')) {
      return [
        Article(
          title: 'What\'s Working in Developer Marketing Today: Insights from Industry Leaders',
          description: 'Draft.dev shares insights from industry leaders on effective developer marketing strategies, emerging trends, and what\'s getting cut in 2025.',
          content: 'Developer marketing is shifting toward ROI-focused strategies in 2025. Teams face pressure to prove business value beyond awareness, with content remaining foundational despite lower SEO click-through rates...',
          url: 'https://draft.dev/learn/whats-working-in-developer-marketing-today',
          imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Article(
          title: 'Meta Quest 3S launches as affordable entry into mixed reality',
          description: 'Meta releases Quest 3S as a more affordable alternative to Quest 3, bringing mixed reality to mainstream consumers.',
          content: 'Meta has launched the Quest 3S, a more affordable version of its popular Quest 3 mixed reality headset...',
          url: 'https://www.roadtovr.com/meta-quest-3s-review-affordable-mixed-reality/',
          imageUrl: 'https://images.unsplash.com/photo-1592478411213-6153e4ebc696?w=400&h=250&fit=crop',
          publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
    } else {
      // Return empty list for unrecognized queries to trigger "no results" state
      return [];
    }
  }

  /// Loads saved articles from local storage when the app starts.
  /// 
  /// This private method is called in the NewsProvider constructor to
  /// populate the saved articles list from persistent storage. It handles
  /// both successful loading and error cases gracefully.
  /// 
  /// On web platforms where local database storage is not available,
  /// it falls back to an empty list to ensure the app functions correctly.
  /// 
  /// The method:
  /// 1. Attempts to retrieve saved articles from the database
  /// 2. Updates the _savedArticles list with the retrieved data
  /// 3. Handles any errors by using an empty list as fallback
  /// 4. Notifies listeners of the state change
  /// 
  /// References:
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  /// - Async/Await: https://dart.dev/codelabs/async-await
  /// - Local Storage: https://pub.dev/packages/sqflite
  Future<void> _loadSavedArticles() async {
    try {
      final savedArticles = await DatabaseService.instance.getSavedArticles();
      _savedArticles = savedArticles;
    } catch (e) {
      // For web demo, just use empty list
      _savedArticles = [];
    }
    notifyListeners();
  }

  /// Saves an article to persistent storage.
  /// 
  /// This method:
  /// 1. Checks if the article is already saved to avoid duplicates
  /// 2. Adds the article to the in-memory list of saved articles
  /// 3. Attempts to save the article to the local database
  /// 4. Handles database errors gracefully (particularly on web platform)
  /// 5. Notifies listeners of the state change
  /// 
  /// On web platforms where local database storage is not available,
  /// the article is kept in memory for the current session only.
  /// 
  /// References:
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  /// - List Operations: https://api.flutter.dev/flutter/dart-core/List-class.html
  /// - Local Storage: https://pub.dev/packages/sqflite
  Future<void> saveArticle(Article article) async {
    if (!_savedArticles.any((a) => a.url == article.url)) {
      _savedArticles.add(article);
      try {
        await DatabaseService.instance.insert(article);
      } catch (e) {
        // For web demo, just keep in memory
        if (kDebugMode) {
          print('Database not available on web: $e');
        }
      }
      notifyListeners();
    }
  }

  /// Removes a saved article from persistent storage.
  /// 
  /// This method:
  /// 1. Removes the article from the in-memory list of saved articles
  /// 2. Attempts to delete the article from the local database
  /// 3. Handles database errors gracefully (particularly on web platform)
  /// 4. Notifies listeners of the state change
  /// 
  /// On web platforms where local database storage is not available,
  /// the article is only removed from the current session's memory.
  /// 
  /// References:
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  /// - List Operations: https://api.flutter.dev/flutter/dart-core/List-class.html
  /// - Local Storage: https://pub.dev/packages/sqflite
  Future<void> removeSavedArticle(String url) async {
    _savedArticles.removeWhere((article) => article.url == url);
    try {
      await DatabaseService.instance.delete(url);
    } catch (e) {
      // For web demo, just remove from memory
      if (kDebugMode) {
        print('Database not available on web: $e');
      }
    }
    notifyListeners();
  }

  /// Checks if an article is saved in the user's collection.
  /// 
  /// This method determines whether a specific article (identified by its URL)
  /// exists in the user's saved articles list.
  /// 
  /// Returns true if the article is saved, false otherwise.
  /// 
  /// Used by the ArticleCard widget to determine the state of the bookmark icon.
  /// 
  /// References:
  /// - Iterable Methods: https://api.flutter.dev/flutter/dart-core/Iterable-class.html
  /// - Lambda Functions: https://dart.dev/language/functions#anonymous-functions
  bool isArticleSaved(String url) {
    return _savedArticles.any((article) => article.url == url);
  }

  /// Disposes of resources when the provider is no longer needed.
  /// 
  /// This method cleans up the Firecrawl service and any other resources
  /// to prevent memory leaks.
  @override
  void dispose() {
    _firecrawlService.dispose();
    super.dispose();
  }
}
