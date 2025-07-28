# Tech News App

A technology news application built with Flutter and Dart that provides users with the latest technology news and articles. The app features voice search, camera integration for QR code scanning, location-based personalisation, push notifications, and social sharing capabilities.

## Technology Stack

- **Flutter SDK**: 3.16.0
- **Dart**: 3.1.0
- **State Management**: Provider ^6.1.2
- **HTTP Client**: http ^1.2.2
- **Local Database**: sqflite ^2.3.3+1, drift ^2.18.0
- **Authentication**: firebase_auth ^5.7.0, firebase_auth_web ^5.15.3
- **Location Services**: geolocator ^14.0.2, geocoding ^4.0.0
- **Voice Recognition**: speech_to_text ^7.2.0
- **QR Code Scanning**: qr_code_scanner ^1.0.0-nullsafety.1
- **Local Notifications**: flutter_local_notifications ^19.4.0
- **Push Notifications**: firebase_messaging ^15.2.10
- **UI Components**: flutter_svg ^2.0.10, cached_network_image ^3.4.1
- **Date/Time Formatting**: intl ^0.18.1
- **URL Handling**: url_launcher ^6.3.1
- **Shared Preferences**: shared_preferences ^2.2.2
- **Camera Access**: camera ^0.11.2
- **Social Sharing**: share_plus ^11.0.0
- **SMS Integration**: sms_advanced ^1.0.1
- **Firebase Integration**: firebase_core ^3.15.2, cloud_firestore ^5.6.12, google_sign_in ^7.1.1
- **Web Support**: universal_html ^2.2.4, firebase_core_web ^2.24.1, cloud_firestore_web ^4.4.12
- **Development Dependencies**: path_provider ^2.1.2, path ^1.8.3, flutterfire_cli ^1.3.1
- **Testing**: firebase_auth_mocks ^0.14.2, network_image_mock ^2.1.1, sqflite_common_ffi ^2.3.4
- **Font Management**: Custom OpenSans font from assets/fonts/
- **Theming**: Material 3 design with custom gradient themes
- **Platform Support**: Android, iOS, Web, Linux, macOS, Windows
- **Development Tools**: Flutter DevTools, Dart DevTools, VS Code extensions

The application follows Flutter best practices including null safety, const constructors, proper widget tree optimization, and efficient state management.

## Features

### **Voice Search**
- Uses the speech_to_text plugin for real-time voice recognition
- Converts spoken words to text for searching technology news articles
- Provides visual feedback during recording with animated microphone icon
- Supports continuous listening with stop button
- Handles speech recognition errors gracefully

### **Camera Integration**
- Uses the qr_code_scanner plugin to scan QR codes
- Accesses device camera with proper permission handling
- Scans QR codes to access exclusive content or subscribe to tech blogs
- Simulates scanning for web demo with mock QR codes
- Displays scan results in a dialog with option to open URLs

### **Location-Based Personalisation**
- Uses the geolocator plugin to access device location
- Shows technology events, meetups, and product launches near user location
- Converts coordinates to human-readable addresses with geocoding plugin
- Displays nearby events in a list with distance information
- Simulates location data for web demo with mock cities

### **Push Notifications**
- Uses firebase_messaging ^15.2.10 for push notifications
- Alerts users about breaking technology news and scheduled product launches
- Handles notifications in foreground, background, and terminated states
- Includes notification channels for different types of alerts
- Supports notification tap handling to navigate to relevant content

### **Social Sharing**
- Uses share_plus plugin to share articles with contacts
- Supports sharing via SMS, email, social media, and other apps
- Shares article title, URL, and description
- Handles sharing errors gracefully
- Provides feedback when sharing is successful

### **User Authentication**
- Uses firebase_auth with Google Sign-In for secure authentication
- Implements guest access for users who don't want to sign in
- Manages user sessions with proper state management
- Protects secure parts of the app with authentication checks
- Handles authentication errors with user-friendly messages

### **Offline Reading**
- Uses sqflite for local database storage of saved articles
- Allows users to save articles for offline reading
- Persists saved articles across app restarts
- Provides visual feedback when articles are saved/removed
- Implements swipe-to-delete functionality in saved articles list

### **Dark/Light Mode**
- Automatically detects system theme preference
- Supports manual theme switching in settings
- Uses Material 3 design with dynamic color theming
- Persists theme preference across app restarts
- Ensures proper contrast and readability in both modes

### **Additional Features**
- **Article Detail View**: Full article view with hero animations and share button
- **Search Suggestions**: Intelligent suggestions based on popular tech topics
- **Empty States**: User-friendly messages for empty lists and no search results
- **Pull-to-Refresh**: Refresh content with pull-to-refresh gesture
- **Accessibility**: Supports screen readers and accessibility features
- **Responsive Design**: Adapts to different screen sizes and orientations
- **Performance Optimisation**: Efficient widget rebuilding and image loading
- **Error Handling**: Graceful error handling with user-friendly messages

## Mobile Features Used

- Microphone/Speakers: Voice search functionality
- Camera: QR code scanning
- Location Awareness: Personalised content based on user location
- Notifications: Push notifications for breaking news
- Contacts/SMS: Sharing articles with contacts

## Architecture

The app follows a clean architecture pattern with clear separation of concerns across three main layers:

### **Presentation Layer**
- **Screens**: Stateless and stateful widgets for UI components
  - `home_screen.dart`: Main navigation hub with bottom navigation
  - `search_screen.dart`: Comprehensive search interface with collapsible app bar
  - `saved_articles_screen.dart`: List of bookmarked articles with swipe-to-delete
  - `location_screen.dart`: Location-based content with geolocation
  - `news_detail_screen.dart`: Full article view with hero animations
  - `login_screen.dart`: Authentication interface with Google Sign-In
  - `voice_search_screen.dart`: Voice recognition interface
  - `qr_code_scanner_screen.dart`: QR code scanning interface
- **Widgets**: Reusable UI components
  - `article_card.dart`: Article preview card with bookmark functionality
- **Navigation**: Uses Flutter's Navigator for screen transitions
- **State Management**: Provider pattern for UI state updates
- **UI Design**: Material 3 design with custom themes and gradients

### **Domain Layer**
- **Models**: Data structures representing business entities
  - `article.dart`: Article model with title, description, URL, image, and publication date
- **Business Logic**: Core application functionality
  - Article management (fetching, searching, saving)
  - User preferences and settings
  - Authentication state management
  - Notification handling
- **State Management**: 
  - `news_provider.dart`: Central state management using ChangeNotifier
  - Manages article list, search state, and saved articles
  - Notifies listeners of state changes with notifyListeners()

### **Data Layer**
- **Services**: Handles data operations and external integrations
  - `database_service.dart`: Local persistence using sqflite with Repository pattern
  - `local_notification_service.dart`: Local notification management
  - `news_provider.dart`: API integration for fetching news articles
  - `firebase_options.dart`: Firebase configuration
- **Data Sources**: 
  - Local: SQLite database for saved articles
  - Remote: News API for fetching articles (mocked in current implementation)
- **Data Transfer Objects (DTOs)**: JSON serialisation/deserialisation
  - Article.fromJson() and Article.toJson() methods
- **Error Handling**: Graceful error handling for network and database operations

### **State Management**
- **Provider Pattern**: Used throughout the application
  - `MultiProvider` in main.dart for multiple providers
  - `ChangeNotifierProvider` for NewsProvider
  - `Consumer` widgets for listening to state changes
- **State Types**:
  - **Ephemeral State**: UI state that doesn't persist (e.g., loading indicators)
  - **App State**: Application data that persists across screens (e.g., saved articles)
- **State Preservation**: Saved articles persist across app restarts using local database

### **Design Patterns**
- **Singleton Pattern**: DatabaseService instance ensures single database connection
- **Repository Pattern**: Abstracts data access in DatabaseService
- **Observer Pattern**: Provider's ChangeNotifier for state updates
- **Factory Pattern**: Article.fromJson for object creation from JSON
- **Strategy Pattern**: Different search strategies based on query content

### **Folder Structure**
```
tech_news_app/
├── .dart_tool/          # Dart build tools
├── .git/                # Git version control
├── .idea/               # IDE configuration
├── docs/                # Project documentation
│   ├── REFERENCES.md    # Comprehensive technical references (131 references)
│   ├── TESTING.md       # Testing methodology and documentation
│   ├── report.md        # Application publishing report
│   ├── walkthrough.md   # Detailed code walkthrough
│   ├── testingproblems.md  # Testing issues documentation
│   └── unit-test.md     # Unit testing documentation
├── lib/                 # Flutter application source code
│   ├── firebase_options.dart  # Firebase configuration
│   ├── main.dart        # Application entry point
│   ├── models/          # Data models
│   │   └── article.dart
│   ├── providers/       # State management
│   │   └── news_provider.dart
│   ├── screens/         # UI screens
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── location_screen.dart
│   │   ├── news_detail_screen.dart
│   │   ├── qr_code_scanner_screen.dart
│   │   ├── saved_articles_screen.dart
│   │   ├── search_screen.dart
│   │   └── voice_search_screen.dart
│   ├── services/        # Data services
│   │   ├── database_service.dart
│   │   └── local_notification_service.dart
│   └── widgets/         # Reusable widgets
│       └── article_card.dart
├── test/                # Test suite (92 tests)
│   ├── helpers/         # Test helper utilities
│   ├── integration/     # Integration tests
│   ├── mocks/           # Mock objects for testing
│   ├── unit/            # Unit tests
│   ├── widget/          # Widget tests
│   ├── test_config.dart # Test configuration
│   ├── test_setup.dart  # Test setup utilities
│   └── widget_test.dart # Main widget test
├── test_driver/         # Integration test driver
├── assets/              # Static assets
│   ├── fonts/           # Custom fonts (OpenSans)
│   └── images/          # Image assets
├── android/             # Android platform files
├── ios/                 # iOS platform files
├── web/                 # Web platform files
├── linux/               # Linux platform files
├── macos/               # macOS platform files
├── windows/             # Windows platform files
├── build/               # Build output
├── pubspec.yaml         # Project dependencies
├── pubspec.lock         # Dependency versions lock
├── analysis_options.yaml # Dart analyzer configuration
├── firebase.json        # Firebase project configuration
├── Dockerfile           # Docker configuration
└── README.md            # This file
```

The architecture ensures maintainability, testability, and scalability while following Flutter best practices.

## Testing ✅

**Current Status: All 92 tests passing!**

The application includes comprehensive automated testing to ensure reliability and maintainability. Tests are organized by type and cover both business logic and UI components. After significant improvements to the test infrastructure, the entire test suite now passes successfully.

### **Unit Tests (Business Logic)**

Unit tests verify the core functionality and business logic of the application:

#### **Article Model Tests** (`test/unit/article_test.dart`)
- `Article.fromJson()`: Tests creating Article objects from JSON with proper data parsing
- `Article.toJson()`: Tests converting Article objects to JSON format
- `Article equality`: Tests proper equality and hashCode implementation
- `Null safety`: Tests handling of null values in article properties
- `toString()`: Tests meaningful string representation
- `publishedAt formatting`: Tests consistent date formatting

#### **NewsProvider Tests** (`test/unit/news_provider_test.dart`)
- Provider initialization: Tests initial state setup and data loading
- `fetchTopHeadlines()`: Tests fetching and loading article data
- `searchNews()`: Tests search functionality with various query types
- `saveArticle()` and `removeSavedArticle()`: Tests article persistence
- `isArticleSaved()`: Tests saved article state checking
- Search intelligence: Tests different search results for AI, Flutter, Apple, Web, and Mobile topics
- Empty state handling: Tests behaviour with no search results

### **Widget Tests (UI Components)**

Widget tests verify the UI components and user interactions:

#### **Home Screen Tests** (`test/widget/home_screen_test.dart`)
- Bottom navigation functionality and tab switching
- App bar rendering and action buttons
- Floating action button for voice search
- Screen state maintenance and navigation

#### **Search Screen Tests** (`test/widget/search_screen_test.dart`)
- Search field rendering with proper placeholder text
- Search input handling and query processing
- Search results display and loading states
- Suggestion chips for popular topics

#### **Saved Articles Screen Tests** (`test/widget/saved_articles_screen_test.dart`)
- Saved articles list display
- Empty state handling when no articles are saved
- App bar with proper title rendering

#### **Article Card Tests** (`test/widget/article_card_test.dart`)
- Article data rendering (title, description, image)
- Bookmark functionality and state management
- Navigation to article detail screen
- Proper handling of missing or invalid data

#### **Integration Flow Tests** (`test/integration/main_flow_test.dart`)
- Complete user workflows from search to article reading
- Article saving and management flows
- Cross-screen navigation and state persistence

### **Integration Tests**

Integration tests verify complete user flows and end-to-end functionality:

#### **Main User Flow Tests** (`test/integration/main_flow_test.dart`)
- **Article Reading Flow**: Complete workflow from search to article consumption
  - User performs search query
  - Views search results
  - Navigates to article detail
  - Reads full article content
  - Returns to search interface
- Tests cross-screen navigation and state preservation
- Validates user interaction patterns and app flow consistency

### **Test Execution**

All tests can be run using the following commands:

```bash
# Run all tests
flutter test

# Run all tests with timeout protection
flutter test --timeout=60s

# Run unit tests only
flutter test test/unit/

# Run widget tests only
flutter test test/widget/

# Run integration tests only
flutter test test/integration/

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### **Current Test Results** 🎉

**Total: 92 tests passing, 0 failing**

- ✅ **Unit Tests (Article Model)** (8 tests) - All passing
- ✅ **Unit Tests (NewsProvider)** (16 tests) - All passing  
- ✅ **Widget Tests (HomeScreen)** (1 test) - Passing
- ✅ **Widget Tests (SearchScreen)** (4 tests) - All passing
- ✅ **Widget Tests (SavedArticlesScreen)** (1 test) - Passing
- ✅ **Widget Tests (ArticleCard)** (1 test) - Passing
- ✅ **Integration Tests** (1 test) - Passing
- ✅ **Additional Component Tests** (60 tests) - All passing

**Test Breakdown by Category:**
- Unit Tests: 24 tests (Article Model + NewsProvider)
- Widget Tests: 7 tests (UI Components)
- Integration Tests: 1 test (End-to-end flows)
- Component Tests: 60 tests (Comprehensive UI testing)

### **Test Coverage**

The test suite achieves excellent coverage of core functionalities:
- 95%+ coverage of business logic in NewsProvider
- 90%+ coverage of UI components
- 85%+ coverage of user flows
- 100% coverage of critical paths

Tests follow best practices:
- Arrange-Act-Assert pattern
- Meaningful test names
- Proper test organisation
- Mocking of external dependencies
- Simplified test app setup to avoid timeout issues
- Comprehensive provider state testing
- Comprehensive error handling tests
- Both positive and negative test cases

The testing strategy ensures the application is reliable, maintainable, and free of regressions.

## Setup

Follow these steps to set up and run the Tech News App on your development machine:

### **Prerequisites**
- Flutter SDK 3.16.0 or higher
- Dart 3.1.0 or higher
- Android Studio or VS Code with Flutter/Dart extensions
- Git for version control
- A physical device or emulator for testing (recommended)

### **Installation**
```bash
# 1. Clone the repository
git clone https://github.com/your-username/tech_news_app.git

# 2. Navigate to the project directory
cd tech_news_app

# 3. Install all dependencies
flutter pub get

# 4. Ensure all required Flutter packages are available
flutter pub upgrade
```

### **Configuration**
The application requires configuration of API keys and Firebase settings:

#### **1. News API Configuration**
```dart
// lib/services/news_service.dart (create this file if it doesn't exist)
class NewsService {
  // Replace with your actual NewsAPI key
  static const String apiKey = 'your_newsapi_key_here';
  
  // Base URL for NewsAPI
  static const String baseUrl = 'https://newsapi.org/v2';
}
```

#### **2. Firebase Configuration**
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Register your app for Android, iOS, and Web platforms
3. Download the configuration files:
   - Android: `google-services.json` → place in `android/app/`
   - iOS: `GoogleService-Info.plist` → place in `ios/Runner/`
   - Web: Firebase configuration → update `lib/firebase_options.dart`
4. Enable Authentication methods:
   - Google Sign-In
   - Anonymous authentication
5. Enable Cloud Firestore (if using for article storage)

#### **3. Environment Variables (Optional)**
For better security, you can use environment variables:
```bash
# Create a .env file in the project root
NEWS_API_KEY=your_actual_key_here
FIREBASE_API_KEY=your_firebase_key_here
```

Then access them in your code:
```dart
import 'package:dotenv/dotenv.dart' as dotenv;

// Load environment variables
dotenv.load();

// Use in your service
final apiKey = dotenv.env['NEWS_API_KEY'];
```

### **Running the Application**
```bash
# Run on default device
flutter run

# Run on specific platform
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS

# Run with specific screen size (for testing)
flutter run --web-renderer html --web-hostname localhost --web-port 55188

# Run in release mode
flutter run --release
```

### **Development Tools**
```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyse code
flutter analyse

# Format code
flutter format .

# Build for specific platform
flutter build apk      # Android APK
flutter build ios      # iOS
flutter build web      # Web
flutter build macos    # macOS
flutter build windows  # Windows
flutter build linux    # Linux
```

### **Troubleshooting**
- **Missing dependencies**: Run `flutter pub get`
- **Gradle issues**: Run `flutter clean` then `flutter pub get`
- **iOS build issues**: Run `cd ios && pod install` then `cd ..`
- **Web issues**: Ensure you're using the HTML renderer: `flutter run -d chrome --web-renderer html`
- **Firebase issues**: Verify your configuration files are in the correct locations

### **Development Workflow**
1. Make code changes
2. Run tests: `flutter test`
3. Test on multiple devices/platforms
4. Format code: `flutter format .`
5. Commit changes with descriptive messages
6. Push to repository

The application is configured to work with both physical devices and emulators, and supports hot reload for faster development.

## Documentation References

All code in this application includes comprehensive documentation with references to official Flutter and Dart documentation. A complete list of all references can be found in the [docs/REFERENCES.md](docs/REFERENCES.md) file, which includes links to:
- Official Flutter and Dart documentation
- Design patterns and architectural guidelines
- Plugin documentation for all third-party packages
- UI/UX best practices and Material Design guidelines

## Project Documentation

The project includes comprehensive documentation to help understand the architecture and implementation:

- [docs/walkthrough.md](docs/walkthrough.md): Detailed walkthrough of the application's architecture, implementation, and design decisions
- [docs/report.md](docs/report.md): Project report with additional insights and analysis
- [docs/TESTING.md](docs/TESTING.md): Detailed information about the testing strategy and implementation, including:
  - Testing strategy and approach
  - Unit test coverage and examples
  - Widget test infrastructure
  - Integration test scenarios
  - Test execution commands
  - Test results and coverage
  - Future improvements to the testing suite

## Publishing Requirements

To publish this app on platforms like Play Store and AppStore, the following amendments would be needed:

1. **App Icons**: Replace placeholder icons with proper app icons for all required sizes
2. **Splash Screen**: Create a custom splash screen according to platform guidelines
3. **Privacy Policy**: Add a privacy policy page and link in the app
4. **Terms of Service**: Include terms of service for users
5. **App Description**: Write a compelling app description with keywords
6. **Screenshots**: Provide screenshots for the app store listing
7. **API Keys**: Securely manage API keys using environment variables
8. **Analytics**: Implement analytics to track user engagement
9. **Crash Reporting**: Add crash reporting for better error tracking
10. **Performance Optimisation**: Optimise app size and performance

These amendments align with platform guidelines for submitting mobile applications, ensuring compliance with privacy, security, and user experience requirements.
