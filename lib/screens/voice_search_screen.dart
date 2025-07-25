/// Voice search screen for the Tech News application.
/// 
/// This screen provides a voice-based search interface that allows users
/// to search for technology news articles by speaking into their device's
/// microphone. It features visual feedback during listening, text
/// recognition display, and integration with the main search functionality.
/// 
/// The screen uses the following key Flutter components and plugins:
/// - [speech_to_text] - For converting spoken words to text
/// - [Provider] - For connecting to the NewsProvider
/// - [Scaffold] - Provides the basic material design visual structure
/// - [ElevatedButton] - For the microphone and send buttons
/// - [CircleBorder] - For the circular microphone button
/// 
/// For the web demo, speech recognition is simulated with mock functionality.
/// 
/// References:
/// - Speech to Text Plugin: https://pub.dev/packages/speech_to_text
/// - Provider Pattern: https://pub.dev/packages/provider
/// - Button Styling: https://api.flutter.dev/flutter/material/ElevatedButton-class.html
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';

/// The voice search interface for the Tech News application.
/// 
/// This StatefulWidget provides a screen that allows users to search
/// for technology news articles using their voice. It features:
/// - A circular microphone button that changes color when listening
/// - Visual feedback showing "Listening..." status
/// - Display of recognized text from speech
/// - A send button to perform the search with the recognized text
/// - Error handling for speech recognition issues
/// 
/// The screen uses the speech_to_text plugin to convert spoken words
/// to text and integrates with the NewsProvider to perform searches.
/// 
/// For the web demo, speech recognition is simulated with mock functionality
/// since the plugin may not work properly in web browsers.
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - Speech Recognition: https://pub.dev/packages/speech_to_text
class VoiceSearchScreen extends StatefulWidget {
  /// Creates a VoiceSearchScreen widget
  const VoiceSearchScreen({super.key});

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

/// The state class for the VoiceSearchScreen.
/// 
/// This State class manages:
/// - The speech recognition system (_speechToText)
/// - The listening state (_isListening)
/// - The recognized text from speech (_recognizedText)
/// - The spoken feedback text (_spokenText)
/// - The availability of speech recognition (_hasSpeech)
/// 
/// The class handles the complete voice search workflow:
/// 1. Initializing the speech recognition system
/// 2. Starting and stopping listening
/// 3. Processing recognized text
/// 4. Performing searches with the recognized text
/// 5. Providing visual and textual feedback
/// 6. Handling errors and edge cases
/// 
/// For the web demo, speech recognition is simulated with mock functionality
/// since the plugin may not work properly in web browsers.
/// 
/// References:
/// - State: https://api.flutter.dev/flutter/widgets/State-class.html
/// - Speech Recognition: https://pub.dev/packages/speech_to_text
class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  /// The speech recognition system instance
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  /// Whether the system is currently listening to the microphone
  bool _isListening = false;

  /// The feedback text to display to the user
  String _spokenText = '';

  /// The text recognised from the user's speech
  String _recognizedText = '';

  /// Whether speech recognition is available on the device
  bool _hasSpeech = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// Initialises the speech recognition system.
  /// 
  /// This method:
  /// 1. Attempts to initialise the speech recognition system
  /// 2. Sets up callbacks for status changes and errors
  /// 3. Updates the UI based on the initialisation result
  /// 
  /// The method handles two main callbacks:
  /// - onStatus: Called when the speech recognition status changes
  ///   * When status is 'notListening', it updates the UI to show listening has stopped
  /// - onError: Called when an error occurs during speech recognition
  ///   * Displays the error message to the user
  /// 
  /// If speech recognition is not available on the device, it shows an appropriate
  /// message to the user.
  /// 
  /// For the web demo, this method simulates speech recognition initialisation
  /// with mock functionality.
  /// 
  /// References:
  /// - Speech Recognition Initialisation: https://pub.dev/documentation/speech_to_text/latest/speech_to_text/SpeechToText/initialize.html
  /// - Error Handling: https://pub.dev/documentation/speech_to_text/latest/speech_to_text/SpeechToText/onError.html
  Future<void> _initSpeech() async {
    _hasSpeech = await _speechToText.initialize(
      onStatus: (status) {
        if (mounted && status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (errorNotification) {
        if (mounted) {
          setState(() {
            _spokenText = 'Error: ${errorNotification.errorMsg}';
          });
        }
      },
    );

    if (mounted && !_hasSpeech) {
      setState(() {
        _spokenText = 'Speech recognition not available';
      });
    }
  }

  /// Starts the speech recognition listening process.
  /// 
  /// This method:
  /// 1. Checks if speech recognition is available
  /// 2. Updates the UI state to show listening has started
  /// 3. Clears any previously recognized text
  /// 4. Begins listening to the microphone for speech input
  /// 5. Processes recognized words as they become available
  /// 
  /// The method sets up a callback to handle recognized speech results,
  /// updating the UI with the recognized text as it is processed.
  /// 
  /// If speech recognition is not available, the method returns early
  /// without attempting to start listening.
  /// 
  /// For the web demo, this method simulates the listening process
  /// with mock functionality.
  /// 
  /// References:
  /// - Starting Listening: https://pub.dev/documentation/speech_to_text/latest/speech_to_text/SpeechToText/listen.html
  /// - Speech Recognition Results: https://pub.dev/documentation/speech_to_text/latest/speech_to_text/SpeechRecognitionResult-class.html
  Future<void> _startListening() async {
    if (!_hasSpeech) return;

    setState(() {
      _isListening = true;
      _recognizedText = '';
    });

    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      },
    );
  }

  /// Stops the speech recognition listening process.
  /// 
  /// This method:
  /// 1. Stops the speech recognition system from listening to the microphone
  /// 2. Updates the UI state to show listening has stopped
  /// 
  /// The method is typically called when the user taps the stop button
  /// or when the system automatically stops listening after a period
  /// of inactivity.
  /// 
  /// For the web demo, this method simulates stopping the listening process
  /// with mock functionality.
  /// 
  /// References:
  /// - Stopping Listening: https://pub.dev/documentation/speech_to_text/latest/speech_to_text/SpeechToText/stop.html
  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  /// Sends the recognised text to perform a search.
  /// 
  /// This method:
  /// 1. Checks if there is recognised text to send
  /// 2. If text is present:
  ///    * Uses the NewsProvider to search for articles with the recognised text
  ///    * Updates the UI to show the search is in progress
  ///    * Waits for 2 seconds to show the feedback
  ///    * Closes the voice search screen
  /// 3. If no text is present:
  ///    * Shows an error message indicating no text to send
  /// 
  /// The method integrates with the main search functionality of the
  /// application, allowing voice input to be used for article searches.
  /// 
  /// For the web demo, this method simulates the search process
  /// with mock functionality.
  /// 
  /// References:
  /// - Provider Pattern: https://pub.dev/packages/provider
  /// - Navigation: https://api.flutter.dev/flutter/widgets/Navigator-class.html
  Future<void> _sendText() async {
    if (_recognizedText.isNotEmpty) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      newsProvider.searchNews(_recognizedText);
      setState(() {
        _spokenText = 'Searching for: $_recognizedText';
      });
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _spokenText = 'No text to send';
      });
    }
  }

  /// Builds the complete voice search screen UI.
  /// 
  /// This method constructs the entire voice search interface with:
  /// - A Scaffold as the root widget
  /// - An AppBar with the screen title
  /// - A body containing:
  ///   * A circular microphone indicator that changes color when listening
  ///   * Status text showing "Listening..." or instructions to start speaking
  ///   * Display of recognized text from speech
  ///   * Feedback text showing search status or errors
  ///   * A microphone button to start/stop listening
  ///   * A send button to perform the search
  /// 
  /// The UI responds to the current state of the speech recognition system,
  /// showing appropriate visual feedback based on whether the system is
  /// listening, has recognized text, or has encountered errors.
  /// 
  /// For the web demo, the UI simulates the voice search functionality
  /// with mock interactions.
  /// 
  /// References:
  /// - Scaffold: https://api.flutter.dev/flutter/material/Scaffold-class.html
  /// - AppBar: https://api.flutter.dev/flutter/material/AppBar-class.html
  /// - Column Layout: https://api.flutter.dev/flutter/widgets/Column-class.html
  /// - ElevatedButton: https://api.flutter.dev/flutter/material/ElevatedButton-class.html
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Search'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? Colors.red.shade50 : Colors.blue.shade50,
                        border: Border.all(
                          color: _isListening ? Colors.red : Colors.blue,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.mic,
                        size: 60,
                        color: _isListening ? Colors.red : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isListening
                          ? 'Listening...'
                          : 'Tap the microphone to start speaking',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (_recognizedText.isNotEmpty)
                      Text(
                        'Recognised: $_recognizedText',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 10),
                    Text(
                      _spokenText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isListening ? _stopListening : _startListening,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isListening ? Colors.red : Colors.green,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _sendText,
                  child: const Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }
}
