/// Main entry point for the Tech News application.
/// 
/// This file contains the main() function and the MyApp widget which serves as
/// the root of the application widget tree.
/// 
/// The application uses the following key Flutter components:
/// - [WidgetsFlutterBinding.ensureInitialized] - Ensures that the Flutter
///   framework is properly initialised before using any Flutter services
/// - [Firebase.initializeApp] - Initialises Firebase services for the app
/// - [MaterialApp] - Provides the Material Design visual language for the app
/// - [MultiProvider] - Allows multiple providers to be used in the widget tree
/// 
/// References:
/// - Flutter App Structure: https://docs.flutter.dev/development/ui/interactive
/// - Firebase Initialisation: https://firebase.flutter.dev/docs/core/overview
/// - State Management with Provider: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// - Material Design in Flutter: https://docs.flutter.dev/design/material
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';
import 'package:tech_news_app/screens/home_screen.dart';
import 'package:tech_news_app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tech_news_app/services/local_notification_service.dart';
import 'firebase_options.dart';

/// The main function is the entry point for the application.
/// 
/// This function:
/// 1. Ensures Flutter framework is initialised
/// 2. Initialises Firebase services
/// 3. Sets up Firebase Messaging for background and foreground notifications
/// 4. Initialises the local notification service
/// 5. Runs the MyApp widget
/// 
/// The WidgetsFlutterBinding.ensureInitialized() call is required when using
/// plugins that interact with native platforms, as it ensures the binding is
/// initialised before calling any platform-specific code.
/// 
/// References:
/// - Flutter Application Lifecycle: https://docs.flutter.dev/development/data-and-backend/firebase
/// - Firebase Messaging: https://firebase.flutter.dev/docs/messaging/overview
/// - WidgetsFlutterBinding: https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding-class.html
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check if we're in a test environment
  // This prevents Firebase initialization during tests
  final isTesting = const bool.fromEnvironment('FLUTTER_TEST');
  
  if (!isTesting) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Set up Firebase Messaging for background message handling
      // This allows the app to receive push notifications even when terminated
      // Reference: https://firebase.flutter.dev/docs/messaging/usage#background-messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Initialise local notification service for displaying notifications
      // This service handles both local and push notifications in a unified way
      // Reference: https://pub.dev/packages/flutter_local_notifications
      await LocalNotificationService.initialize();
      
      // Handle notification tap events when the app is opened from a notification
      // This listener is triggered when a user taps on a notification
      // Reference: https://firebase.flutter.dev/docs/messaging/notifications#handling-interaction
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationTap(message.data['type']);
      });
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }
  
  runApp(const MyApp());
}

/// The root widget for the Tech News application.
/// 
/// This StatelessWidget builds the MaterialApp with the following configuration:
/// - Title: 'Tech News' - The title that appears in the app switcher
/// - debugShowCheckedModeBanner: false - Hides the debug banner in debug mode
/// - Theme: Uses Material 3 design with a blue seed color
/// - Home: The LoginScreen is the initial screen
/// - Routes: Defines named routes for navigation between screens
/// 
/// The MultiProvider widget wraps the entire app to provide state management
/// for the NewsProvider, allowing any widget in the tree to access news data.
/// 
/// References:
/// - MaterialApp: https://api.flutter.dev/flutter/material/MaterialApp-class.html
/// - ThemeData: https://api.flutter.dev/flutter/material/ThemeData-class.html
/// - MultiProvider: https://pub.dev/documentation/provider/latest/provider/MultiProvider-class.html
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        title: 'Tech News',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}

/// Background message handler for Firebase Cloud Messaging.
/// 
/// This function is called when a push notification is received while the app
/// is terminated. It must be a top-level or static function annotated with
/// @pragma('vm:entry-point') to ensure it's not tree-shaken during compilation.
/// 
/// The function initialises Firebase and handles the background message.
/// 
/// Reference: https://firebase.flutter.dev/docs/messaging/usage#background-messages
  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

/// Handles notification tap events.
/// 
/// This function is called when a user taps on a notification that opened
/// the application. It receives the payload data from the notification and
/// can navigate to specific screens based on the content.
/// 
/// Currently, this is a placeholder implementation that could be extended
/// to handle different notification types (e.g., breaking news, event reminders).
/// 
/// Reference: https://firebase.flutter.dev/docs/messaging/notifications#handling-interaction
void _handleNotificationTap(String? payload) {
  // Handle notification tap
}
