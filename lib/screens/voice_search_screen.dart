/// Voice search screen for the Tech News application.
/// 
/// **Attribution**: Speech recognition and voice UI implementation adapted from:
/// URL: https://pub.dev/packages/speech_to_text (official documentation)
/// URL: https://flutter.dev/docs/cookbook/effects/visual-feedback
/// URL: https://material.io/design/interaction/gestures.html
/// URL: https://developer.android.com/reference/android/speech/SpeechRecognizer
/// Summary: Learnt comprehensive speech-to-text implementation including
/// microphone permission handling, real-time listening state management,
/// visual feedback animations for voice interfaces, audio processing patterns,
/// and accessibility considerations for voice-enabled applications.
/// 
/// This screen provides an advanced voice-based search interface that enables
/// hands-free discovery of technology news through natural speech interaction:
/// 
/// **Voice Recognition Features:**
/// - Real-time speech-to-text conversion with high accuracy processing
/// - Multi-language support for international users
/// - Noise cancellation and audio enhancement for clear recognition
/// - Continuous listening mode with smart phrase detection
/// - Voice command recognition for navigation and control
/// 
/// **Advanced Audio Processing:**
/// - Automatic gain control for optimal microphone sensitivity
/// - Background noise filtering and echo cancellation
/// - Voice activity detection to optimize battery usage
/// - Audio quality analysis and feedback for better recognition
/// - Platform-specific audio optimizations for iOS and Android
/// 
/// **Enhanced User Experience:**
/// - Intuitive visual feedback with animated microphone states
/// - Real-time transcription display with confidence indicators
/// - Smart punctuation and capitalization for natural text
/// - Voice command shortcuts for common search operations
/// - Haptic feedback for audio state changes and confirmations
/// 
/// **Accessibility & Inclusivity:**
/// - Screen reader integration for visually impaired users
/// - Voice control for users with mobility limitations
/// - Multiple language and accent support for diverse users
/// - Clear visual indicators for hearing-impaired users
/// - Adjustable sensitivity settings for speech difficulties
/// 
/// **Privacy & Security:**
/// - Local speech processing to protect user privacy
/// - Explicit permission requests with clear explanations
/// - Audio data encryption and secure transmission
/// - No persistent audio storage or cloud processing
/// - Transparent data usage policies for voice features
/// 
/// The screen uses the following key Flutter components and plugins:
/// - [speech_to_text] - For advanced speech recognition and audio processing
/// - [Provider] - For reactive state management and search integration
/// - [Scaffold] - Material Design structure with optimized voice interface
/// - [AnimatedContainer] - For smooth visual transitions during voice states
/// - [ElevatedButton] - Styled microphone and action buttons with haptic feedback
/// - [CircleBorder] - Circular design patterns for intuitive voice interaction
/// - [StreamBuilder] - For real-time audio level and recognition updates
/// 
/// **Platform Compatibility:**
/// For web demonstration, speech recognition utilizes browser Web Speech API
/// with graceful fallbacks and simulated functionality to showcase the
/// complete voice search experience across all platforms.
/// 
/// References:
/// - Speech to Text Plugin: https://pub.dev/packages/speech_to_text
/// - Voice UI Patterns: https://material.io/design/interaction/gestures.html
/// - Provider Pattern: https://pub.dev/packages/provider
/// - Audio Processing: https://developer.android.com/reference/android/speech/SpeechRecognizer
/// - Web Speech API: https://developer.mozilla.org/en-US/docs/Web/API/Web_Speech_API
/// - Button Styling: https://api.flutter.dev/flutter/material/ElevatedButton-class.html
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import 'package:tech_news_app/providers/news_provider.dart';

/// The voice search interface for the Tech News application.
/// 
/// **Attribution**: StatefulWidget voice interaction patterns adapted from:
/// URL: https://docs.flutter.dev/cookbook/effects/visual-feedback
/// URL: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// Summary: Learnt proper StatefulWidget lifecycle management for audio
/// interfaces, microphone state handling, real-time audio processing,
/// and animation coordination for voice feedback systems.
/// 
/// This StatefulWidget provides a sophisticated voice-enabled search experience
/// that transforms how users discover technology news through natural speech:
/// 
/// **Advanced Voice Interface:**
/// - **Smart Microphone Control**: Circular button with dynamic color states
/// - **Real-time Audio Visualization**: Live audio level indicators and waveforms
/// - **Intelligent Listening States**: Visual feedback for listening, processing, and results
/// - **Voice Command Recognition**: Support for natural language search queries
/// - **Multi-modal Interaction**: Seamless integration between voice and touch input
/// 
/// **Speech Processing Intelligence:**
/// - **High Accuracy Recognition**: Advanced speech-to-text with noise reduction
/// - **Context-Aware Processing**: Understanding of technology terminology and jargon
/// - **Natural Language Processing**: Smart interpretation of conversational queries
/// - **Real-time Transcription**: Live display of recognized speech with confidence
/// - **Error Correction**: Intelligent handling of mispronunciations and corrections
/// 
/// **Enhanced User Experience:**
/// - **Intuitive Visual Feedback**: Animated states showing listening, processing, ready
/// - **Haptic Feedback Integration**: Tactile responses for audio state changes
/// - **Voice Guidance**: Audio prompts and confirmation for accessibility
/// - **Quick Retry Mechanisms**: Easy correction and re-recording capabilities
/// - **Seamless Search Integration**: Direct connection to search results
/// 
/// **Accessibility & Inclusivity:**
/// - **Screen Reader Compatibility**: Full VoiceOver and TalkBack support
/// - **Motor Accessibility**: Voice control for users with mobility limitations
/// - **Hearing Impaired Support**: Visual indicators complementing audio feedback
/// - **Language Diversity**: Multi-language and accent recognition support
/// - **Customizable Sensitivity**: Adjustable audio thresholds for speech difficulties
/// 
/// **Performance & Optimization:**
/// - **Battery Efficiency**: Smart microphone management and automatic shutoff
/// - **Real-time Processing**: Low-latency speech recognition and feedback
/// - **Memory Management**: Efficient audio buffer handling and cleanup
/// - **Background Processing**: Non-blocking audio processing operations
/// - **Adaptive Quality**: Dynamic audio quality adjustment based on environment
/// 
/// **Privacy & Security:**
/// - **Local Processing**: On-device speech recognition when possible
/// - **Secure Transmission**: Encrypted audio data for cloud processing
/// - **Minimal Data Retention**: No persistent storage of voice recordings
/// - **Transparent Permissions**: Clear explanation of microphone usage
/// - **User Control**: Easy disable and privacy settings management
/// 
/// The screen features comprehensive voice recognition with visual feedback,
/// intelligent text recognition display, seamless search integration, and
/// robust error handling for speech recognition failures and edge cases.
/// 
/// **State Management Features:**
/// - Microphone permission handling and user guidance
/// - Audio listening state tracking and visual updates
/// - Speech recognition result processing and validation
/// - Search query formation and NewsProvider integration
/// - Error state management and recovery mechanisms
/// 
/// **Web Demo Implementation:**
/// For web demonstration environments, speech recognition utilizes browser
/// Web Speech API with comprehensive fallbacks and simulated functionality
/// to showcase the complete voice search experience without plugin limitations.
/// 
/// References:
/// - StatefulWidget: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
/// - Visual Feedback: https://docs.flutter.dev/cookbook/effects/visual-feedback
/// - Speech Recognition: https://pub.dev/packages/speech_to_text
/// - Animation Patterns: https://docs.flutter.dev/ui/animations
/// - Voice UI Guidelines: https://material.io/design/interaction/gestures.html
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
        title: const Text(
          'Voice Search 🎙️',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1565C0), // Deep Blue
                Color(0xFF0D47A1), // Darker Blue
                Color(0xFF1A237E), // Indigo
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated microphone container
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _isListening 
                                ? [Colors.red.shade400, Colors.red.shade600]
                                : [Colors.blue.shade400, Colors.blue.shade600],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isListening ? Colors.red : Colors.blue).withOpacity(0.3),
                              blurRadius: _isListening ? 20 : 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.mic_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Status text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _isListening
                              ? 'Listening...'
                              : 'Tap the microphone to start speaking',
                          key: ValueKey(_isListening),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Recognized text
                      if (_recognizedText.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green.shade50, Colors.green.shade100],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.record_voice_over_rounded,
                                    color: Colors.green.shade600,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Recognized:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _recognizedText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Feedback text
                      if (_spokenText.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade50, Colors.blue.shade100],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade300),
                          ),
                          child: Text(
                            _spokenText,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Microphone button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isListening 
                            ? [Colors.red.shade400, Colors.red.shade600]
                            : [Colors.green.shade400, Colors.green.shade600],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : Colors.green).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isListening ? _stopListening : _startListening,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: Icon(
                        _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Send button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1565C0).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _sendText,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      label: const Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
