# Tech News App

A technology news application built with Flutter and Dart that provides users with the latest technology news and articles. The app features voice search, camera integration for QR code scanning, location-based personalisation, push notifications, and social sharing capabilities.

## Technology Stack

- **Flutter SDK**: 3.16.0
- **Dart**: 3.1.0
- **State Management**: Provider ^6.1.2
- **HTTP Client**: http ^1.2.2
- **Local Database**: sqflite ^2.3.3+1
- **Authentication**: firebase_auth ^5.7.0
- **Location Services**: geolocator ^14.0.2
- **Voice Recognition**: speech_to_text ^7.2.0
- **QR Code Scanning**: qr_code_scanner ^1.0.0-nullsafety.1
- **Local Notifications**: flutter_local_notifications ^19.4.0
- **UI Components**: flutter_svg ^2.0.10, cached_network_image ^3.4.1
- **Date/Time Formatting**: intl ^0.18.1
- **URL Handling**: url_launcher ^6.3.1
- **Shared Preferences**: shared_preferences ^2.2.2
- **Camera Access**: camera ^0.11.2
- **Social Sharing**: share_plus ^11.0.0
- **SMS Integration**: sms_advanced ^1.0.1
- **Firebase Integration**: firebase_core ^3.15.2, cloud_firestore ^5.6.12, google_sign_in ^7.1.1
- **Web Support**: universal_html ^2.2.4
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
- Uses firebase_messaging for push notifications
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
- **Data Transfer Objects (DTOs)**: JSON serialization/deserialization
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
lib/
├── models/              # Data models
│   └── article.dart
├── providers/           # State management
│   └── news_provider.dart
├── screens/             # UI screens
│   ├── auth/
│   │   └── login_screen.dart
│   ├── home_screen.dart
│   ├── location_screen.dart
│   ├── news_detail_screen.dart
│   ├── qr_code_scanner_screen.dart
│   ├── saved_articles_screen.dart
│   ├── search_screen.dart
│   └── voice_search_screen.dart
├── services/            # Data services
│   ├── database_service.dart
│   └── local_notification_service.dart
└── widgets/             # Reusable widgets
    └── article_card.dart
```

The architecture ensures maintainability, testability, and scalability while following Flutter best practices.

## Testing

The application includes comprehensive automated testing to ensure reliability and maintainability. Tests are organized by type and cover both business logic and UI components.

### **Unit Tests (Business Logic)**

Unit tests verify the core functionality and business logic of the application:

#### **NewsProvider Tests** (`test/unit/news_provider_test.dart`)
- `fetchTopHeadlines()`: Tests that top headlines are fetched correctly
- `searchNews()`: Tests search functionality with various queries
- `saveArticle()`: Tests saving articles to local storage
- `removeSavedArticle()`: Tests removing articles from local storage
- `isArticleSaved()`: Tests checking if an article is saved
- `searchNews() with different queries`: Tests intelligent search results for AI, Flutter, Apple, Web, and Mobile topics
- `searchNews() with no results`: Tests empty state handling for unrecognized queries

#### **DatabaseService Tests** (`test/unit/database_service_test.dart`)
- `insert()`: Tests inserting articles into the database
- `update()`: Tests updating existing articles
- `getSavedArticles()`: Tests retrieving saved articles
- `delete()`: Tests deleting articles
- `close()`: Tests closing the database connection
- Error handling: Tests graceful handling of database errors

#### **Article Model Tests** (`test/unit/article_test.dart`)
- `Article.fromJson()`: Tests creating Article objects from JSON
- `Article.toJson()`: Tests converting Article objects to JSON
- `Article equality`: Tests proper equality and hashCode implementation
- `Null safety`: Tests handling of null values in article properties

### **Widget Tests (UI Components)**

Widget tests verify the UI components and user interactions:

#### **ArticleCard Tests** (`test/widget/article_card_test.dart`)
- Renders correctly with article data
- Displays article title, description, and publication date
- Shows bookmark button with proper state (saved/unsaved)
- Handles bookmark button tap
- Navigates to article detail on card tap
- Handles missing image gracefully
- Displays proper loading state

#### **SearchScreen Tests** (`test/widget/search_screen_test.dart`)
- Displays search field with proper placeholder
- Handles text input and submission
- Shows loading indicator during search
- Displays search results in list
- Shows empty state when no search performed
- Shows no results state with suggestions for unrecognized queries
- Handles pull-to-refresh
- Processes search queries and displays appropriate results
- Shows suggestion chips for popular topics (AI, Flutter, Apple, Web, Mobile)

#### **LoginScreen Tests** (`test/widget/login_screen_test.dart`)
- Displays Google Sign-In button (disabled for web demo)
- Displays guest login button
- Shows loading indicator during authentication
- Handles guest login navigation
- Displays proper error messages
- Shows Google Sign-In not configured message for web

#### **SavedArticlesScreen Tests** (`test/widget/saved_articles_screen_test.dart`)
- Displays list of saved articles
- Shows empty state when no articles saved
- Handles swipe-to-delete with confirmation dialog
- Implements clear all functionality with confirmation
- Shows undo snackbar after deletion
- Persists saved articles across sessions
- Displays proper empty state message

#### **HomeScreen Tests** (`test/widget/home_screen_test.dart`)
- Displays bottom navigation with three tabs
- Handles tab selection and screen switching
- Shows proper screen for each tab
- Displays app bar with title and action buttons
- Implements floating action button for voice search
- Handles navigation to search, voice search, and QR code scanner
- Maintains selected tab state

#### **NewsDetailScreen Tests** (`test/widget/news_detail_screen_test.dart`)
- Displays article title, image, and content
- Shows publication date in proper format
- Implements hero animation for image
- Handles share button tap
- Opens full article in browser
- Displays proper layout for articles with/without images
- Handles missing content gracefully

### **Integration Tests**

Integration tests verify complete user flows:

#### **Main User Flows** (`test/integration/main_flow_test.dart`)
- **Search Flow**: 
  - User opens search screen
  - Enters search query
  - Views search results
  - Saves an article
  - Navigates to saved articles
  - Verifies article is saved
- **Article Reading Flow**:
  - User searches for articles
  - Taps on an article
  - Reads article content
  - Shares article with contacts
  - Returns to search screen
- **Saved Articles Flow**:
  - User saves multiple articles
  - Navigates to saved articles screen
  - Views saved articles
  - Removes an article with swipe-to-delete
  - Uses undo functionality
  - Clears all saved articles

### **Test Execution**

All tests can be run using the following commands:

```bash
# Run all tests
flutter test

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

### **Test Coverage**

The test suite aims for high coverage of core functionalities:
- 95%+ coverage of business logic in NewsProvider
- 90%+ coverage of UI components
- 85%+ coverage of user flows
- 100% coverage of critical paths

Tests follow best practices:
- Arrange-Act-Assert pattern
- Meaningful test names
- Proper test organization
- Mocking of external dependencies
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

# Analyze code
flutter analyze

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

## Testing Documentation

For detailed information about the testing strategy and implementation, see the [docs/TESTING.md](docs/TESTING.md) file, which includes:
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
