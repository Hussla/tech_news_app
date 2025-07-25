/// Local notification service for the Tech News application.
/// 
/// This service provides local notification functionality using the
/// flutter_local_notifications plugin. It handles initialisation
/// and display of notifications to keep users informed about news updates.
/// 
/// The service uses the following key Flutter components and plugins:
/// - [flutter_local_notifications] - For displaying local notifications
/// - [FlutterLocalNotificationsPlugin] - The main class for notification operations
/// - [AndroidInitializationSettings] - For configuring Android notification settings
/// - [NotificationDetails] - For specifying notification appearance and behavior
/// 
/// References:
/// - flutter_local_notifications Plugin: https://pub.dev/packages/flutter_local_notifications
/// - Local Notifications: https://docs.flutter.dev/data-and-backend/notifications
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// The local notification service for the Tech News application.
/// 
/// This utility class provides static methods for initializing and
/// displaying local notifications to users. It uses the
/// flutter_local_notifications plugin to show alerts about news updates.
/// 
/// The service handles:
/// - Initialization of the notification system
/// - Configuration of notification channels (Android)
/// - Display of notifications with appropriate settings
/// 
/// The class uses a static instance of FlutterLocalNotificationsPlugin
/// to manage all notification operations throughout the application.
/// 
/// References:
/// - flutter_local_notifications: https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/FlutterLocalNotificationsPlugin-class.html
/// - Notification Channels: https://developer.android.com/training/notify-user/channels
class LocalNotificationService {
  /// The shared instance of the FlutterLocalNotificationsPlugin.
  /// 
  /// This static field provides a single point of access to the
  /// notification system throughout the application.
  /// 
  /// References:
  /// - FlutterLocalNotificationsPlugin: https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/FlutterLocalNotificationsPlugin-class.html
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// initialises the local notification system.
  /// 
  /// This method:
  /// 1. Creates Android-specific initialisation settings with the app icon
  /// 2. Creates general initialisation settings for all platforms
  /// 3. initialises the notification plugin with these settings
  /// 4. Sets up a callback for notification responses (currently empty)
  /// 
  /// The method should be called once when the application starts
  /// to set up the notification system.
  /// 
  /// Returns a Future<void> to handle the asynchronous nature of
  /// the initialisation process.
  /// 
  /// References:
  /// - Initialisation: https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/FlutterLocalNotificationsPlugin/initialize.html
  /// - Android Settings: https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/AndroidInitializationSettings-class.html
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {},
    );
  }

  /// Displays a local notification to the user.
  /// 
  /// This method:
  /// 1. Creates Android-specific notification details with:
  ///    * Channel ID: 'tech_news'
  ///    * Channel name: 'Technology News'
  ///    * Channel description: 'Notifications for technology news updates'
  ///    * Maximum importance and high priority
  ///    * showWhen set to false to hide the timestamp
  /// 2. Creates general notification details for all platforms
  /// 3. Shows the notification with the specified ID, title, and body
  /// 4. Includes a payload to identify the notification type
  /// 
  /// The method is used to alert users about new technology news articles
  /// and other important updates.
  /// 
  /// Returns a Future<void> to handle the asynchronous nature of
  /// the notification display process.
  /// 
  /// References:
  /// - Show Notification: https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/FlutterLocalNotificationsPlugin/show.html
  /// - Android Notification Details: https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/AndroidNotificationDetails-class.html
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'tech_news',
      'Technology News',
      channelDescription: 'Notifications for technology news updates',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'news_item',
    );
  }
}
