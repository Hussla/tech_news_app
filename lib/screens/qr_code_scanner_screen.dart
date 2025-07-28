/// QR code scanner screen for the Tech News application.
/// 
/// This screen provides a QR code scanning interface that allows users
/// to scan QR codes to access additional content or information.
/// It features camera access, scanning simulation, and result display.
/// 
/// The screen uses the following key Flutter components and plugins:
/// - [universal_html] - For web camera access
/// - [url_launcher] - For opening URLs from QR codes
/// - [HtmlElementView] - For displaying the camera feed on web
/// - [Scaffold] - Provides the basic material design visual structure
/// - [AlertDialog] - For displaying QR code results
/// 
/// For the web demo, camera access is simulated with mock functionality.
/// 
/// References:
/// - Web Camera Access: https://pub.dev/packages/universal_html
/// - URL Launcher: https://pub.dev/packages/url_launcher
/// - Platform Views: https://docs.flutter.dev/platform-integration/web/web-images#using-html-elements
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

/// The QR code scanner interface for the Tech News application.
/// 
/// This StatefulWidget provides a screen that allows users to scan
/// QR codes to access additional content or information. It features:
/// - Camera access for scanning QR codes
/// - Visual feedback during scanning
/// - Display of scanned QR code results
/// - Option to open URLs from QR codes
/// - Error handling for camera access issues
/// 
/// The screen uses web-specific functionality for camera access
/// and QR code scanning, with appropriate fallbacks for the web demo.
/// 
/// For the web demo, camera access is simulated with mock functionality
/// since the plugin may not work properly in web browsers.
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - QR Code Scanning: https://pub.dev/packages/qr_code_scanner
class QRCodeScannerScreen extends StatefulWidget {
  /// Creates a QRCodeScannerScreen widget
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

/// The state class for the QRCodeScannerScreen.
/// 
/// This State class manages:
/// - The scanned QR code text (_qrText)
/// - The scanning state (_isScanning)
/// - The camera permission status (_cameraPermissionGranted)
/// - The video element for displaying the camera feed (_videoElement)
/// - The media stream from the camera (_stream)
/// 
/// The class handles the complete QR code scanning workflow:
/// 1. Requesting camera permissions
/// 2. Setting up and stopping the camera
/// 3. Simulating QR code scanning for the web demo
/// 4. Displaying scan results in a dialogue
/// 5. Opening URLs from QR codes
/// 
/// For the web demo, camera access is simulated with mock functionality
/// since the plugin may not work properly in web browsers.
/// 
/// References:
/// - State: https://api.flutter.dev/flutter/widgets/State-class.html
/// - Web Camera Access: https://pub.dev/documentation/universal_html/latest/html/Navigator/getUserMedia.html
class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  /// The text content of the scanned QR code
  String _qrText = '';

  /// Whether the system is currently scanning for QR codes
  bool _isScanning = false;

  /// Whether camera permission has been granted
  bool _cameraPermissionGranted = false;

  /// The video element for displaying the camera feed
  html.VideoElement? _videoElement;

  /// The media stream from the camera
  html.MediaStream? _stream;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _requestCameraPermission();
    }
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  /// Requests camera permission from the user.
  /// 
  /// **Attribution**: Implementation pattern adapted from:
  /// URL: https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia
  /// Summary: Learnt how to properly request camera permissions using getUserMedia API,
  /// including the specific parameters for rear-facing camera ('environment' mode)
  /// and proper error handling for permission denied scenarios.
  /// 
  /// This method:
  /// 1. Attempts to access the device's camera using getUserMedia
  /// 2. Requests permission for the rear-facing camera (environment)
  /// 3. If successful:
  ///    * Updates the state to indicate permission is granted
  ///    * Stores the media stream
  ///    * Sets up the camera feed display
  /// 4. If permission is denied or an error occurs:
  ///    * Updates the state to indicate permission is not granted
  /// 
  /// The method is only called on web platforms where camera access
  /// requires explicit user permission.
  /// 
  /// For the web demo, this method simulates camera permission
  /// with mock functionality.
  /// 
  /// References:
  /// - Requesting Camera Permissions: https://pub.dev/documentation/universal_html/latest/html/Navigator/getUserMedia.html
  /// - Media Devices: https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices
  Future<void> _requestCameraPermission() async {
    try {
      final stream = await html.window.navigator.mediaDevices!.getUserMedia({
        'video': {'facingMode': 'environment'}
      });
      
      setState(() {
        _cameraPermissionGranted = true;
        _stream = stream;
      });
      
      _setupCamera(stream);
    } catch (e) {
      setState(() {
        _cameraPermissionGranted = false;
      });
    }
  }

  /// Sets up the camera feed display.
  /// 
  /// **Attribution**: Video element configuration adapted from:
  /// URL: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video
  /// Summary: Learnt how to properly configure HTML video elements for camera streams,
  /// including the srcObject property for MediaStream assignment and objectFit styling
  /// for maintaining aspect ratio in responsive containers.
  /// 
  /// This method:
  /// 1. Creates a new HTML video element
  /// 2. Connects the video element to the media stream from the camera
  /// 3. Configures the video element with:
  ///    * Autoplay enabled
  ///    * Full width (100%)
  ///    * Fixed height (300px)
  ///    * Cover object fit to maintain aspect ratio
  /// 
  /// The video element is used to display the camera feed in the
  /// HtmlElementView widget.
  /// 
  /// For the web demo, this method sets up the mock camera feed
  /// with appropriate styling.
  /// 
  /// References:
  /// - HTML Video Element: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video
  /// - Media Stream: https://developer.mozilla.org/en-US/docs/Web/API/MediaStream
  void _setupCamera(html.MediaStream stream) {
    _videoElement = html.VideoElement()
      ..srcObject = stream
      ..autoplay = true
      ..style.width = '100%'
      ..style.height = '300px'
      ..style.objectFit = 'cover';
  }

  /// Stops the camera feed and releases resources.
  /// 
  /// This method:
  /// 1. Checks if there is an active media stream
  /// 2. If a stream exists:
  ///    * Iterates through all tracks in the stream
  ///    * Stops each track to release the camera
  /// 
  /// This ensures proper cleanup of camera resources when the
  /// scanner is no longer in use or when the widget is disposed.
  /// 
  /// For the web demo, this method stops the mock camera feed
  /// and releases associated resources.
  /// 
  /// References:
  /// - Media Stream Tracks: https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack
  /// - Stopping Tracks: https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack/stop
  void _stopCamera() {
    if (_stream != null) {
      // For universal_html, we need to handle track stopping differently
      try {
        // Get tracks and stop them using the correct API
        final tracks = _stream!.getTracks();
        for (var track in tracks) {
          // Use dynamic call to avoid compile-time errors
          (track as dynamic).stop?.call();
        }
      } catch (e) {
        // Fallback: just log the error
        print('Could not stop camera tracks: $e');
      } finally {
        _stream = null;
      }
    }
  }

  /// Simulates QR code detection for the web demo.
  /// 
  /// This method:
  /// 1. Defines a list of mock QR code values
  /// 2. Selects a random QR code from the list based on current time
  /// 3. Updates the state with:
  ///    * The scanned QR code text
  ///    * Scanning state set to false
  /// 4. Displays the scan result in a dialogue
  /// 
  /// The method is used in the web demo to simulate QR code
  /// detection since the actual QR code scanner plugin may
  /// not work properly in web browsers.
  /// 
  /// The mock QR codes include:
  /// - Technology websites (Flutter, GitHub, Stack Overflow)
  /// - App demo information
  /// - Contact information
  /// 
  /// References:
  /// - Random Selection: https://api.dart.dev/stable/dart-core/DateTime-class.html
  /// - State Management: https://docs.flutter.dev/data-and-backend/state-mgmt/intro
  void _simulateQRScan() {
    // Simulate QR code detection for demo
    final mockQRCodes = [
      'https://flutter.dev',
      'https://github.com',
      'https://stackoverflow.com',
      'Tech News App Demo QR Code',
      'Contact: john@example.com',
    ];
    
    final randomCode = mockQRCodes[DateTime.now().millisecond % mockQRCodes.length];
    
    setState(() {
      _qrText = randomCode;
      _isScanning = false;
    });

    // Show result dialogue
    _showQRResult(randomCode);
  }

  /// Displays the QR code scan result in a dialogue.
  /// 
  /// This method:
  /// 1. Shows an AlertDialog with:
  ///    * A title indicating a QR code was detected
  ///    * A QR code icon
  ///    * The scanned QR code content
  ///    * Action buttons based on the QR code content
  /// 2. If the QR code contains a URL:
  ///    * Shows an "Open Link" button to launch the URL
  /// 3. Always shows a "Close" button to dismiss the dialogue
  /// 
  /// The dialogue provides a clear interface for users to view
  /// and interact with the scanned QR code content.
  /// 
  /// For the web demo, this method displays the result of
  /// the simulated QR code scan.
  /// 
  /// References:
  /// - AlertDialog: https://api.flutter.dev/flutter/material/AlertDialog-class.html
  /// - Dialogs: https://docs.flutter.dev/development/ui/widgets/material#dialogs
  /// - URL Launching: https://pub.dev/packages/url_launcher
  void _showQRResult(String qrCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Detected'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.qr_code, size: 50, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                qrCode,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            if (qrCode.startsWith('http'))
              TextButton(
                onPressed: () async {
                  final uri = Uri.parse(qrCode);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                child: const Text('Open Link'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Builds the complete QR code scanner screen UI.
  /// 
  /// This method constructs the entire QR code scanner interface with:
  /// - A Scaffold as the root widget
  /// - An AppBar with the screen title and scanning control
  /// - A body containing:
  ///   * A camera preview area (or placeholder if no permission)
  ///   * A scanning status indicator when actively scanning
  ///   * A control button to start scanning or enable camera
  ///   * A display of the last scanned QR code
  ///   * Instructions for using the scanner
  /// 
  /// The UI responds to the current state of the scanner:
  /// - Shows camera feed when permission is granted
  /// - Shows placeholder when camera access is not available
  /// - Displays scanning progress when actively scanning
  /// - Shows scan results after a QR code is detected
  /// 
  /// For the web demo, the UI simulates the QR code scanning
  /// functionality with mock interactions.
  /// 
  /// References:
  /// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
  /// - AppBar: https://api.flutter.dev/flutter/material/AppBar-class.html
  /// - Column Layout: https://api.flutter.dev/flutter/widgets/Column-class.html
  /// - HtmlElementView: https://docs.flutter.dev/platform-integration/web/web-images#using-html-elements
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          if (_cameraPermissionGranted)
            IconButton(
              icon: Icon(_isScanning ? Icons.stop : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  _isScanning = !_isScanning;
                });
                if (_isScanning) {
                  // Simulate scanning after 2 seconds
                  Timer(const Duration(seconds: 2), _simulateQRScan);
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _cameraPermissionGranted && _videoElement != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: HtmlElementView(
                        viewType: 'video-${_videoElement.hashCode}',
                        onPlatformViewCreated: (int viewId) {
                          html.document.getElementById('video-${_videoElement.hashCode}')?.append(_videoElement!);
                        },
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Camera access required for QR scanning',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            if (_isScanning)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Scanning for QR codes...'),
                ],
              )
            else
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _cameraPermissionGranted
                        ? () {
                            setState(() {
                              _isScanning = true;
                            });
                            Timer(const Duration(seconds: 2), _simulateQRScan);
                          }
                        : _requestCameraPermission,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: Text(_cameraPermissionGranted ? 'Start Scanning' : 'Enable Camera'),
                  ),
                  const SizedBox(height: 16),
                  if (_qrText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Last Scanned:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(_qrText),
                        ],
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 20),
            const Text(
              'Point your camera at a QR code to scan it. This demo will simulate QR code detection.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
