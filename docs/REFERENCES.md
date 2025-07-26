# Tech News App - Documentation References

This document provides a comprehensive list of all references used in the Tech News application, including official Flutter and Dart documentation, design patterns, and technical resources.

## 📚 **Core Flutter & Dart Documentation**

### **State Management**
- [State Management with Provider](https://docs.flutter.dev/data-and-backend/state-mgmt/simple) - Official Flutter guide on using the Provider package for state management
- [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) - Flutter class for managing state changes and notifying listeners
- [Consumer](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) - Provider widget for rebuilding parts of the UI when state changes

### **Asynchronous Programming**
- [Asynchronous Programming](https://dart.dev/codelabs/async-await) - Dart guide on using async/await for asynchronous operations
- [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html) - Dart class for representing a value that will be available in the future
- [Error Handling](https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control) - Best practices for error handling in Dart

### **HTTP & Networking**
- [HTTP Requests in Flutter](https://docs.flutter.dev/cookbook/networking/fetch-data) - Flutter cookbook for making HTTP requests
- [HTTP Package](https://pub.dev/packages/http) - Dart package for making HTTP requests
- [JSON Serialisation](https://docs.flutter.dev/data-and-backend/json) - Flutter guide on working with JSON data

## 📱 **Mobile Features & Plugins**

### **Authentication**
- [Firebase Authentication](https://firebase.flutter.dev/docs/auth/overview) - FlutterFire documentation for Firebase authentication
- [Google Sign-In](https://firebase.flutter.dev/docs/auth/social#google) - Firebase authentication with Google
- [Anonymous Authentication](https://firebase.flutter.dev/docs/auth/anonymous) - Firebase authentication without user accounts

### **Local Storage**
- [sqflite Plugin](https://pub.dev/packages/sqflite) - Flutter plugin for SQLite database operations
- [Local Persistence](https://docs.flutter.dev/data-and-backend/local-data) - Flutter guide on local data storage
- [Repository Pattern](https://www.martinfowler.com/eaaCatalog/repository.html) - Design pattern for abstracting data access

### **Notifications**
- [flutter_local_notifications Plugin](https://pub.dev/packages/flutter_local_notifications) - Flutter plugin for local notifications
- [Notification Channels](https://developer.android.com/training/notify-user/channels) - Android guide on notification channels
- [Initialisation](https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/FlutterLocalNotificationsPlugin/initialize.html) - Documentation for initializing the notification plugin

### **Device Features**
- [Geolocator Plugin](https://pub.dev/packages/geolocator) - Flutter plugin for accessing device location
- [Geocoding Plugin](https://pub.dev/packages/geocoding) - Flutter plugin for converting coordinates to addresses
- [speech_to_text Plugin](https://pub.dev/packages/speech_to_text) - Flutter plugin for speech recognition
- [qr_code_scanner Plugin](https://pub.dev/packages/qr_code_scanner) - Flutter plugin for QR code scanning
- [url_launcher Plugin](https://pub.dev/packages/url_launcher) - Flutter plugin for launching URLs

## 🎨 **UI & Design**

### **Widgets & Layout**
- [Scaffold](https://api.flutter.dev/flutter/material/Scaffold-class.html) - Flutter widget providing basic material design visual structure
- [AppBar](https://api.flutter.dev/flutter/material/AppBar-class.html) - Flutter widget for app bars
- [ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html) - Flutter widget for scrollable lists
- [Column](https://api.flutter.dev/flutter/widgets/Column-class.html) - Flutter widget for vertical layouts
- [Hero Animations](https://docs.flutter.dev/ui/animations/hero-animations) - Flutter guide on hero animations for smooth transitions

### **Navigation**
- [Navigation](https://docs.flutter.dev/ui/navigation) - Flutter guide on navigation between screens
- [Bottom Navigation](https://docs.flutter.dev/ui/navigation/bottom-navigation) - Flutter guide on bottom navigation bars
- [Navigator](https://api.flutter.dev/flutter/widgets/Navigator-class.html) - Flutter class for managing routes

## 🛠️ **Architecture & Patterns**

### **Design Patterns**
- [Singleton Pattern](https://en.wikipedia.org/wiki/Singleton_pattern) - Creational design pattern ensuring a class has only one instance
- [Repository Pattern](https://www.martinfowler.com/eaaCatalog/repository.html) - Design pattern for abstracting data access
- [State Management with Provider](https://docs.flutter.dev/data-and-backend/state-mgmt/simple) - Flutter's recommended approach for state management

### **Database**
- [SQLite](https://www.sqlite.org/index.html) - Lightweight disk-based database used by sqflite
- [SQL CREATE TABLE](https://www.sqlite.org/lang_createtable.html) - SQLite documentation for creating tables
- [Database Schema](https://pub.dev/documentation/sqflite/latest/sqflite/Database/createTable.html) - sqflite documentation for creating database schemas

## 🌐 **Web Integration**

### **Web-Specific Features**
- [Web Camera Access](https://pub.dev/documentation/universal_html/latest/html/Navigator/getUserMedia.html) - Documentation for accessing camera on web
- [Platform Views](https://docs.flutter.dev/platform-integration/web/web-images#using-html-elements) - Flutter documentation for using HTML elements in Flutter web
- [Web Images](https://docs.flutter.dev/platform-integration/web/web-images) - Flutter guide on handling images in web applications

## 📄 **Testing Documentation**

### **Testing Frameworks**
- [Flutter Testing Guide](https://docs.flutter.dev/testing) - Official Flutter guide on testing Flutter applications
- [Widget Testing](https://docs.flutter.dev/testing/widget-tests) - Flutter guide on testing UI components
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests) - Flutter guide on testing complete user flows
- [flutter_test Package](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) - Flutter's built-in testing framework
- [Test Coverage](https://docs.flutter.dev/testing/code-coverage) - Flutter guide on measuring test coverage

### **Testing Best Practices**
- [Arrange-Act-Assert Pattern](https://www.artofunittesting.com/phases/arrange-act-assert) - Standard pattern for structuring tests
- [Mocking Dependencies](https://pub.dev/packages/mockito) - Dart package for creating mock objects in tests
- [Fake Async](https://pub.dev/packages/fake_async) - Dart package for controlling asynchronous operations in tests
- [Golden File Testing](https://docs.flutter.dev/testing/ui-testing#golden-file-testing) - Flutter technique for testing UI appearance

## 📄 **Additional Resources**
- [Flutter App Structure](https://docs.flutter.dev/development/ui/interactive) - Flutter guide on application structure
- [Material Design in Flutter](https://docs.flutter.dev/design/material) - Flutter guide on implementing Material Design
- [Flutter Application Lifecycle](https://docs.flutter.dev/development/data-and-backend/firebase) - Flutter guide on application lifecycle
