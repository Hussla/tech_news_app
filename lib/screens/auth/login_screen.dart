/// Login screen for the Tech News application.
/// 
/// This screen provides user authentication functionality for the app,
/// allowing users to sign in with Google or continue as a guest.
/// 
/// The screen uses the following key Flutter components:
/// - [Scaffold] - Provides the basic material design visual structure
/// - [Container] with [BoxDecoration] - Creates a gradient background
/// - [Column] - Arranges UI elements vertically
/// - [ElevatedButton.icon] - Provides styled buttons with icons
/// - [ScaffoldMessenger] - Shows snack bars for user feedback
/// 
/// For the web demo, Google Sign-In is disabled and guest login navigates
/// directly to the HomeScreen without actual Firebase authentication.
/// 
/// References:
/// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
/// - Gradient Backgrounds: https://api.flutter.dev/flutter/painting/BoxDecoration-class.html
/// - ElevatedButton: https://api.flutter.dev/flutter/material/ElevatedButton-class.html
/// - Navigation: https://docs.flutter.dev/ui/navigation
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tech_news_app/screens/home_screen.dart';

/// The login interface for the Tech News application.
/// 
/// This StatefulWidget provides a clean, modern login screen with:
/// - A gradient background in the app's brand colors
/// - The app logo and title
/// - A description of the app's purpose
/// - Two authentication options:
///   * Google Sign-In (currently disabled for web demo)
///   * Guest access (navigates to the main app)
/// 
/// The screen handles loading states during authentication attempts
/// and provides user feedback through snack bars.
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - Authentication: https://docs.flutter.dev/data-and-backend/firebase-auth
class LoginScreen extends StatefulWidget {
  /// Creates a LoginScreen widget
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// The state class for the LoginScreen.
/// 
/// This State class manages:
/// - The Firebase authentication instance
/// - The loading state during authentication attempts
/// - The Google Sign-In functionality
/// - The anonymous (guest) sign-in functionality
/// - User feedback through snack bars
/// 
/// The class handles both successful and failed authentication attempts,
/// providing appropriate user feedback in each case.
/// 
/// References:
/// - State: https://api.flutter.dev/flutter/widgets/State-class.html
/// - Firebase Authentication: https://firebase.flutter.dev/docs/auth/overview
/// - User Feedback: https://api.flutter.dev/flutter/material/SnackBar-class.html
class _LoginScreenState extends State<LoginScreen> {
  /// The Firebase authentication instance used for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Whether an authentication operation is currently in progress
  bool _isLoading = false;

  /// Signs in the user with Google authentication.
  /// 
  /// This method:
  /// 1. Sets the loading state to true
  /// 2. Attempts to sign in with Google
  /// 3. Shows a snackbar with the result
  /// 4. Resets the loading state
  /// 
  /// For the web demo, this method only shows a message that Google
  /// Sign-In is not configured, as the web implementation requires
  /// additional setup.
  /// 
  /// References:
  /// - Google Sign-In: https://firebase.flutter.dev/docs/auth/social#google
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For now, just show a message that Google Sign-In is not configured
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In not configured for web')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign in with Google')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Signs in the user anonymously (as a guest).
  /// 
  /// This method:
  /// 1. Sets the loading state to true
  /// 2. Navigates to the HomeScreen
  /// 3. Shows a snackbar if the navigation fails
  /// 4. Resets the loading state
  /// 
  /// For the web demo, this method bypasses actual Firebase authentication
  /// and navigates directly to the HomeScreen, as the web implementation
  /// would require additional setup.
  /// 
  /// The method uses Navigator.pushReplacement to replace the login screen
  /// with the home screen, preventing the user from navigating back to
  /// the login screen with the back button.
  /// 
  /// References:
  /// - Anonymous Authentication: https://firebase.flutter.dev/docs/auth/anonymous
  /// - Navigation: https://docs.flutter.dev/ui/navigation
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For web demo, just navigate directly without Firebase auth
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign in anonymously')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Builds the complete login screen UI.
  /// 
  /// This method constructs the entire login interface with:
  /// - A Scaffold as the root widget
  /// - A Container with a gradient background in the app's brand colors
  /// - A centered Column containing:
  ///   * The app logo (newspaper icon)
  ///   * The app title and description
  ///   * Authentication buttons (Google Sign-In and Guest access)
  /// - A loading indicator during authentication attempts
  /// 
  /// The UI responds to the _isLoading state, showing either the loading
  /// indicator or the authentication buttons.
  /// 
  /// References:
  /// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
  /// - Gradient Backgrounds: https://api.flutter.dev/flutter/painting/BoxDecoration-class.html
  /// - Column Layout: https://api.flutter.dev/flutter/widgets/Column-class.html
  /// - CircularProgressIndicator: https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a237e), Color(0xFF303f9f)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.newspaper,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tech News',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Stay updated with the latest technology news',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: null, // Disabled for demo
                            icon: const Icon(Icons.login),
                            label: const Text('Google Sign-In (Coming Soon)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.grey.shade600,
                              minimumSize: const Size(double.infinity, 50),
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _signInAnonymously,
                            icon: const Icon(Icons.person),
                            label: const Text('Continue as Guest'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
