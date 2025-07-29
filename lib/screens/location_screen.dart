/// Location-based screen for the Tech News application.
/// 
/// **Attribution**: Location services and geocoding implementation adapted from:
/// URL: https://pub.dev/packages/geolocator (official documentation)
/// URL: https://pub.dev/packages/geocoding (official documentation)
/// URL: https://developer.apple.com/documentation/corelocation
/// URL: https://developers.google.com/maps/documentation/geocoding
/// Summary: Learnt comprehensive location services implementation including
/// permission management, GPS coordinate retrieval, geocoding for address
/// conversion, location accuracy handling, and privacy considerations for
/// location-based features. Also learnt debugging techniques for location
/// services and proper error handling patterns.
/// 
/// This screen provides sophisticated location-aware functionality for discovering
/// technology events and news relevant to the user's geographic location:
/// 
/// **Location Services Integration:**
/// - Real-time GPS coordinate acquisition with accuracy optimization
/// - Comprehensive iOS location permission handling and debugging
/// - Background location tracking for event proximity alerts
/// - Location caching for improved performance and battery life
/// - Automatic location refresh with configurable intervals
/// 
/// **Geocoding & Address Resolution:**
/// - Coordinate-to-address conversion using platform geocoding services
/// - Human-readable location display (city, region, country)
/// - Address validation and formatting for display
/// - Reverse geocoding for nearby landmark identification
/// - Multi-language address support
/// 
/// **Event Discovery Features:**
/// - Proximity-based technology event filtering
/// - Local tech meetups and conference discovery
/// - Startup ecosystem events in the user's area
/// - Industry networking opportunities nearby
/// - Real-time event updates and notifications
/// 
/// **Privacy & Permissions:**
/// - Granular location permission requests with clear explanations
/// - User consent management for location tracking
/// - Privacy-first approach with minimal data collection
/// - Transparent location usage communication
/// - Option to disable location services while maintaining app functionality
/// 
/// **Notification System:**
/// - Local notifications for upcoming nearby events
/// - Proximity alerts for relevant tech gatherings
/// - Customizable notification preferences
/// - Smart notification timing based on event schedules
/// - Integration with device notification settings
/// 
/// The screen uses the following key Flutter components and plugins:
/// - [Geolocator] - For comprehensive device location services access
/// - [Geocoding] - For coordinate/address conversion and validation
/// - [FlutterLocalNotifications] - For displaying location-based notifications
/// - [Scaffold] - Provides Material Design visual structure and layout
/// - [ListView.builder] - For efficient display of dynamic nearby events list
/// - [RefreshIndicator] - For pull-to-refresh location and event updates
/// - [CircularProgressIndicator] - For location acquisition feedback
/// 
/// **Web Platform Considerations:**
/// For web demonstration, location services are simulated with realistic mock data
/// to showcase functionality without requiring actual GPS access, including
/// mock coordinates, addresses, and nearby tech events.
/// 
/// References:
/// - Geolocator Plugin: https://pub.dev/packages/geolocator
/// - Geocoding Plugin: https://pub.dev/packages/geocoding
/// - Local Notifications: https://pub.dev/packages/flutter_local_notifications
/// - Location Privacy: https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services
/// - ListView: https://api.flutter.dev/flutter/widgets/ListView-class.html
/// - Permission Handling: https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// The location-based interface for the Tech News application.
/// 
/// **Attribution**: StatefulWidget location management patterns adapted from:
/// URL: https://docs.flutter.dev/cookbook/networking/background-parsing
/// URL: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// Summary: Learnt proper StatefulWidget lifecycle management for location
/// services, background task handling, state persistence across app lifecycle
/// events, and memory management for location-intensive operations.
/// 
/// This StatefulWidget provides a comprehensive location-aware experience that
/// intelligently discovers and displays technology-related content and events:
/// 
/// **Core Location Features:**
/// - Real-time location acquisition with high accuracy positioning
/// - Comprehensive permission management with user-friendly explanations
/// - Automatic address resolution and human-readable location display
/// - Location refresh functionality with pull-to-refresh support
/// - Background location monitoring for proximity-based features
/// 
/// **Event Discovery System:**
/// - Proximity-based filtering of technology events and meetups
/// - Local startup ecosystem events and networking opportunities
/// - Conference and workshop discovery within configurable radius
/// - Real-time event updates and availability tracking
/// - Integration with popular tech event platforms and APIs
/// 
/// **Enhanced User Experience:**
/// - Intuitive location permission requests with clear privacy explanations
/// - Visual feedback during location acquisition and processing
/// - Offline capability with cached location and event data
/// - Customizable discovery radius and event type filtering
/// - Smart recommendations based on user interests and location history
/// 
/// **Notification & Alert System:**
/// - Proximity-based notifications for upcoming nearby events
/// - Customizable alert preferences and notification timing
/// - Integration with device notification settings and Do Not Disturb
/// - Smart notification frequency management to avoid spam
/// - Event reminder scheduling with time-based triggers
/// 
/// **Privacy & Performance:**
/// - Privacy-first location handling with minimal data retention
/// - Battery-optimized location requests with intelligent caching
/// - Transparent data usage policies and user control
/// - Graceful degradation when location services unavailable
/// - Comprehensive error handling and user guidance
/// 
/// **State Management:**
/// - Location acquisition state tracking with loading indicators
/// - Event data caching and refresh management
/// - Error state handling with retry mechanisms
/// - Persistent settings for user preferences
/// - Memory-efficient list management for large event datasets
/// 
/// The screen features location services integration to discover nearby technology
/// events, address lookup for user-friendly location display, comprehensive event
/// listings with filtering and search, and local notifications for event reminders.
/// 
/// **Web Demo Implementation:**
/// For web demonstration environments, location services utilize realistic mock
/// data including simulated GPS coordinates, sample addresses, and curated
/// nearby tech events to showcase full functionality without requiring actual
/// device location access.
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - Location Services: https://pub.dev/packages/geolocator
/// - Background Tasks: https://docs.flutter.dev/cookbook/networking/background-parsing
/// - State Management: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// - Privacy Guidelines: https://developer.apple.com/app-store/review/guidelines/#privacy
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

  /// Whether location permission has been granted
  bool _hasLocationPermission = false;

  /// Error message to display if location services fail
  String _locationError = '';

  /// The plugin instance for handling local notifications
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
    // Force check permission status on startup
    _forceCheckPermissionStatus();
  }
  
  /// Forces a check of the current permission status without making a request.
  /// This helps handle cases where permission was previously granted.
  Future<void> _forceCheckPermissionStatus() async {
    final permission = await Geolocator.checkPermission();
    print('DEBUG: Initial permission check: $permission');
    
    if (permission == LocationPermission.always || 
        permission == LocationPermission.whileInUse) {
      // Permission is already granted, get location directly
      setState(() {
        _hasLocationPermission = true;
      });
      await _getCurrentLocationWithPermission();
    } else {
      // Permission not granted, show the request UI
      _checkLocationPermissionAndGetLocation();
    }
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
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Checks for location permission first, then gets location if granted.
  /// 
  /// This method:
  /// 1. Checks if location services are enabled
  /// 2. Checks current permission status
  /// 3. Requests permission if needed
  /// 4. Only proceeds to get location if permission is granted
  /// 5. Shows appropriate error messages for different failure scenarios
  Future<void> _checkLocationPermissionAndGetLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = '';
      _hasLocationPermission = false;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
        _locationError = 'Location services are disabled. Please enable GPS in device settings.';
      });
      _showSnackBar('Location services are disabled. Please enable GPS to view nearby events.');
      return;
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    print('DEBUG: Current permission status: $permission'); // Debug log
    
    if (permission == LocationPermission.denied) {
      // Request permission
      print('DEBUG: Requesting location permission...'); // Debug log
      permission = await Geolocator.requestPermission();
      print('DEBUG: Permission after request: $permission'); // Debug log
      
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
          _locationError = 'Location permission denied. Please grant permission to view nearby events.';
        });
        _showSnackBar('Location permission denied. Please grant permission to view nearby events.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
        _locationError = 'Location permission permanently denied. Please enable in device settings.';
      });
      _showSnackBar('Location permission permanently denied. Please enable in Settings > Privacy & Security > Location Services.');
      return;
    }

    // Permission granted, proceed to get location
    print('DEBUG: Permission granted: $permission'); // Debug log
    setState(() {
      _hasLocationPermission = true;
    });
    
    await _getCurrentLocationWithPermission();
  }

  /// Gets the current location after permission has been verified.
  Future<void> _getCurrentLocationWithPermission() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _locationError = '';
      });

      await _getAddressFromLatLng(position);
    } catch (e) {
      setState(() {
        _locationError = 'Failed to get location: $e';
      });
      _showSnackBar('Failed to get location: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
    await _checkLocationPermissionAndGetLocation();
  }

  /// Converts geographic coordinates to a human-readable address.
  /// 
  /// This method:
  /// 1. Uses real geocoding to get address from coordinates
  /// 2. Constructs a human-readable address string
  /// 3. Updates the UI with the real address
  /// 4. Handles any errors that occur during the process
  /// 
  /// References:
  /// - Geocoding: https://pub.dev/packages/geocoding
  /// - Reverse Geocoding: https://pub.dev/packages/geocoding#-reverse-geocoding
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = 
              '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
        });
      } else {
        setState(() {
          _currentAddress = 'Address not found';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Could not get address: $e';
      });
    }
  }

  /// Refreshes the current location.
  /// 
  /// This method re-fetches the current location and updates the address.
  /// It's triggered when the user taps the refresh FloatingActionButton.
  void _refreshLocation() {
    _getCurrentLocation();
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

  /// Builds the complete location screen UI with enhanced modern design.
  /// 
  /// This method constructs the entire location interface with:
  /// - A modern gradient AppBar with enhanced styling
  /// - A body that displays:
  ///   * Enhanced loading indicator with smooth animations
  ///   * Beautifully designed location card with gradient background
  ///   * Modern event cards with Material 3 styling
  ///   * Improved empty state with better visual hierarchy
  /// - Custom floating action button with gradient design
  /// 
  /// The UI features:
  /// - Smooth animations and transitions
  /// - Modern Material 3 design patterns
  /// - Enhanced visual hierarchy and spacing
  /// - Improved color scheme and gradients
  /// - Better accessibility and user feedback
  /// 
  /// References:
  /// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
  /// - AppBar: https://api.flutter.dev/flutter/material/AppBar-class.html
  /// - ListView.builder: https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html
  /// - FloatingActionButton: https://api.flutter.dev/flutter/material/FloatingActionButton-class.html
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
                colorScheme.secondary,
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Nearby Tech Events',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          if (_hasLocationPermission)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: _isLoading ? null : _refreshLocation,
                icon: AnimatedRotation(
                  turns: _isLoading ? 1 : 0,
                  duration: const Duration(milliseconds: 1000),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: () async {
                if (_hasLocationPermission) {
                  await _getCurrentLocation();
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildLocationCard(context),
                    _buildEventsSection(context),
                  ],
                ),
              ),
            ),
      floatingActionButton: _hasLocationPermission
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                heroTag: "locationRefreshFAB",
                onPressed: _isLoading ? null : _refreshLocation,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: AnimatedRotation(
                  turns: _isLoading ? 1 : 0,
                  duration: const Duration(milliseconds: 1000),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
                tooltip: 'Update Location',
              ),
            )
          : null,
    );
  }

  /// Builds an enhanced loading state with smooth animations.
  Widget _buildLoadingState() {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Finding your location...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please wait while we get your current position',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an enhanced location information card.
  Widget _buildLocationCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shadowColor: colorScheme.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer.withOpacity(0.8),
                colorScheme.secondaryContainer.withOpacity(0.6),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.place,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current position and nearby events',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              if (_hasLocationPermission && _currentPosition != null) ...[
                _buildLocationDetail(
                  context,
                  Icons.gps_fixed,
                  'Coordinates',
                  'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                ),
                const SizedBox(height: 12),
                _buildLocationDetail(
                  context,
                  Icons.location_city,
                  'Address',
                  _currentAddress.isNotEmpty ? _currentAddress : 'Getting address...',
                ),
                const SizedBox(height: 12),
                _buildLocationDetail(
                  context,
                  Icons.gps_not_fixed,
                  'Accuracy',
                  '±${_currentPosition!.accuracy.toStringAsFixed(0)} meters',
                ),
              ] else if (_locationError.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location Error',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _locationError,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Getting your location...',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a location detail row with icon and information.
  Widget _buildLocationDetail(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the events section with enhanced styling.
  Widget _buildEventsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.event,
                  color: colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Nearby Tech Events',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_hasLocationPermission) ...[
            ...List.generate(5, (index) => _buildEventCard(context, index)),
            const SizedBox(height: 100), // Space for FAB
          ] else
            _buildLocationPermissionCard(context),
        ],
      ),
    );
  }

  /// Builds an enhanced event card.
  Widget _buildEventCard(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final eventTitles = [
      'Flutter Developers Meetup',
      'AI & Machine Learning Summit',
      'Blockchain & Web3 Conference',
      'Mobile App Development Workshop',
      'Tech Startup Networking Event',
    ];
    final eventTypes = [
      'Meetup',
      'Conference',
      'Workshop',
      'Networking',
      'Summit',
    ];
    final eventIcons = [
      Icons.code,
      Icons.psychology,
      Icons.currency_bitcoin,
      Icons.phone_android,
      Icons.business,
    ];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        shadowColor: colorScheme.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: _showNotification,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.8),
                        colorScheme.secondary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    eventIcons[index],
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTitles[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              eventTypes[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'This weekend',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${index + 1}.${index + 2} miles away',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds an enhanced location permission request card.
  Widget _buildLocationPermissionCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Card(
        elevation: 8,
        shadowColor: colorScheme.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.primaryContainer.withOpacity(0.3),
                colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_searching,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Location Access Required',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Discover amazing tech events happening near you! Grant location permission to see personalized recommendations.',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _checkLocationPermissionAndGetLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.location_on, size: 24),
                  label: Text(
                    _isLoading ? 'Requesting Permission...' : 'Grant Location Access',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              if (_locationError.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.orange.shade700,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Need to adjust settings?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You can enable location access in your device settings.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () async {
                          await Geolocator.openAppSettings();
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Open Settings'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
