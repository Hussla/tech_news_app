/// Location-based screen for the Tech News application.
/// 
/// This screen provides location-aware functionality, showing technology
/// events and news near the user's current location.
/// 
/// The screen uses the following key Flutter components and plugins:
/// - [Geolocator] - For accessing the device's location services
/// - [Geocoding] - For converting coordinates to human-readable addresses
/// - [FlutterLocalNotifications] - For displaying local notifications
/// - [Scaffold] - Provides the basic material design visual structure
/// - [ListView.builder] - For efficiently displaying a list of nearby events
/// 
/// For the web demo, location services are simulated with mock data.
/// 
/// References:
/// - Geolocator Plugin: https://pub.dev/packages/geolocator
/// - Geocoding Plugin: https://pub.dev/packages/geocoding
/// - Local Notifications: https://pub.dev/packages/flutter_local_notifications
/// - ListView: https://api.flutter.dev/flutter/widgets/ListView-class.html
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// The location-based interface for the Tech News application.
/// 
/// This StatefulWidget provides a screen that shows technology events
/// and news near the user's current location. It features:
/// - Location services integration to get the user's current position
/// - Address lookup to convert coordinates to human-readable addresses
/// - A list of nearby technology events
/// - Local notifications for upcoming events
/// - A refresh button to update the user's location
/// 
/// For the web demo, location services are simulated with mock data
/// to demonstrate the functionality without requiring actual GPS access.
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - Location Services: https://pub.dev/packages/geolocator
class LocationScreen extends StatefulWidget {
  /// Creates a LocationScreen widget
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

/// The state class for the LocationScreen.
/// 
/// This State class manages:
/// - The user's current position (_currentPosition)
/// - The human-readable address (_currentAddress)
/// - The loading state during location operations (_isLoading)
/// - Local notifications for nearby events
/// - Location permission handling and error states
/// 
/// The class handles both successful and failed location operations,
/// providing appropriate user feedback in each case.
/// 
/// For the web demo, location services are simulated with mock data
/// to demonstrate the functionality without requiring actual GPS access.
/// 
/// References:
/// - State: https://api.flutter.dev/flutter/widgets/State-class.html
/// - Location Services: https://pub.dev/packages/geolocator
/// - Local Notifications: https://pub.dev/packages/flutter_local_notifications
class _LocationScreenState extends State<LocationScreen> {
  /// The user's current geographic position (latitude and longitude)
  Position? _currentPosition;

  /// The human-readable address corresponding to the current position
  String _currentAddress = '';

  /// Whether a location operation is currently in progress
  bool _isLoading = false;

  /// The plugin instance for handling local notifications
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _getCurrentLocation();
  }

  /// Initialises the local notification system.
  /// 
  /// This method sets up the notification plugin with the appropriate
  /// settings for the Android platform. It creates an initialisation
  /// settings object with the app icon and initialises the plugin.
  /// 
  /// The notification channel is configured for location-based alerts
  /// about nearby technology events.
  /// 
  /// References:
  /// - Notification Initialisation: https://pub.dev/packages/flutter_local_notifications#initializing-the-plugin
  /// - Android Settings: https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/AndroidInitializationSettings-class.html
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Gets the user's current geographic location.
  /// 
  /// This method:
  /// 1. Sets the loading state to true
  /// 2. Checks if location services are enabled
  /// 3. Checks and requests location permissions if needed
  /// 4. Gets the current position with high accuracy
  /// 5. Updates the UI with the position and address
  /// 6. Handles any errors that occur during the process
  /// 7. Resets the loading state
  /// 
  /// The method handles various permission states:
  /// - Location services disabled
  /// - Permission denied (temporary)
  /// - Permission denied forever (permanent)
  /// 
  /// For the web demo, this method simulates location services
  /// with mock data to demonstrate the functionality.
  /// 
  /// References:
  /// - Getting Current Location: https://pub.dev/packages/geolocator#-getting-current-location
  /// - Location Permissions: https://pub.dev/packages/geolocator#-android--ios--web
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });

      await _getAddressFromLatLng(position);
    } catch (e) {
      _showSnackBar('Failed to get location: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Converts geographic coordinates to a human-readable address.
  /// 
  /// This method:
  /// 1. Simulates address lookup with a delay (for web demo)
  /// 2. Determines a mock city name based on the latitude
  /// 3. Constructs a human-readable address string
  /// 4. Updates the UI with the address
  /// 5. Handles any errors that occur during the process
  /// 
  /// For the web demo, this method simulates geocoding with mock data
  /// since the geocoding plugin may not work properly in web browsers.
  /// 
  /// The method uses the latitude to determine which UK city to display:
  /// - Latitude > 51.5: Edinburgh
  /// - Latitude < 51.4: Brighton
  /// - Otherwise: London
  /// 
  /// References:
  /// - Geocoding: https://pub.dev/packages/geocoding
  /// - Reverse Geocoding: https://pub.dev/packages/geocoding#-reverse-geocoding
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      // For web demo, simulate address lookup
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock address based on coordinates
      String mockCity = 'London';
      String mockCountry = 'United Kingdom';
      
      // Simulate different cities based on coordinates
      if (position.latitude > 51.5) {
        mockCity = 'Edinburgh';
      } else if (position.latitude < 51.4) {
        mockCity = 'Brighton';
      }
      
      setState(() {
        _currentAddress = '$mockCity, $mockCountry';
      });
    } catch (e) {
      setState(() {
        _currentAddress = 'Could not get address';
      });
    }
  }

  /// Shows a local notification about a nearby technology event.
  /// 
  /// This method:
  /// 1. Creates Android-specific notification details with:
  ///    - Channel ID: 'tech_news_location'
  ///    - Channel name: 'Location Notifications'
  ///    - Channel description: 'Notifications for technology events near your location'
  ///    - Importance: Maximum
  ///    - Priority: High
  /// 2. Creates notification details with the Android-specific settings
  /// 3. Shows the notification with a title, body, and payload
  /// 
  /// The notification alerts the user about a technology meetup
  /// happening nearby during the weekend.
  /// 
  /// References:
  /// - Showing Notifications: https://pub.dev/packages/flutter_local_notifications#-displaying-a-notification
  /// - Android Notification Details: https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/AndroidNotificationDetails-class.html
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'tech_news_location',
      'Location Notifications',
      channelDescription: 'Notifications for technology events near your location',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Tech Event Nearby',
      'There is a technology meetup in your area this weekend!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  /// Shows a temporary message to the user using a SnackBar.
  /// 
  /// This method displays a SnackBar at the bottom of the screen
  /// with the provided content. It's used to provide feedback
  /// about location operations and errors.
  /// 
  /// The SnackBar automatically disappears after a few seconds.
  /// 
  /// References:
  /// - SnackBar: https://api.flutter.dev/flutter/material/SnackBar-class.html
  /// - ScaffoldMessenger: https://api.flutter.dev/flutter/material/ScaffoldMessenger-class.html
  void _showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }

  /// Builds the complete location screen UI.
  /// 
  /// This method constructs the entire location interface with:
  /// - A Scaffold as the root widget
  /// - An AppBar with the screen title
  /// - A body that displays:
  ///   * A loading indicator during location operations
  ///   * The user's current position and address
  ///   * A list of nearby technology events
  /// - A floating action button for refreshing the location
  /// 
  /// The UI responds to the _isLoading state, showing either the
  /// loading indicator or the location content.
  /// 
  /// References:
  /// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
  /// - AppBar: https://api.flutter.dev/flutter/material/AppBar-class.html
  /// - ListView.builder: https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html
  /// - FloatingActionButton: https://api.flutter.dev/flutter/material/FloatingActionButton-class.html
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Tech Events'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_currentPosition != null)
                        Text(
                          'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}',
                        ),
                      const SizedBox(height: 8),
                      Text('Address: $_currentAddress'),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Tech Meetup $index'),
                        subtitle: const Text('This weekend • 5 miles away'),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: _showNotification,
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
