import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';

class ListeningExercisesScreen extends StatefulWidget {
  const ListeningExercisesScreen({Key? key}) : super(key: key);

  @override
  State<ListeningExercisesScreen> createState() => _ListeningExercisesScreenState();
}

class _ListeningExercisesScreenState extends State<ListeningExercisesScreen> with TickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  int _currentExercise = 0;
  int? _selectedAnswer;
  bool _isPlaying = false;
  bool _hasAnswered = false;
  bool _showCorrectAnswer = false;
  int _score = 0;
  bool _audioPlayed = false;
  bool _ttsReady = false;
  
  // Animation controllers for visual effects
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  // Enhanced listening exercises with Kinyarwanda phrases
  final List<Map<String, dynamic>> _exercises = [
    {
      'audioText': 'Muraho',
      'phonetic': '/mu-ra-ho/',
      'question': 'What greeting did you hear?',
      'options': ['Hello', 'Goodbye', 'Thank you', 'Good morning'],
      'correctAnswer': 0,
      'explanation': 'Muraho is the most common greeting in Kinyarwanda, meaning "Hello"',
      'difficulty': 'Easy',
      'category': 'Greetings'
    },
    {
      'audioText': 'Murakoze cyane',
      'phonetic': '/mu-ra-ko-ze cha-ne/',
      'question': 'What did you hear?',
      'options': ['Hello', 'Goodbye', 'Thank you very much', 'Good morning'],
      'correctAnswer': 2,
      'explanation': 'Murakoze cyane means "Thank you very much" in Kinyarwanda',
      'difficulty': 'Easy',
      'category': 'Polite Expressions'
    },
    {
      'audioText': 'Mwiriwe',
      'phonetic': '/mwi-ri-we/',
      'question': 'What time of day greeting is this?',
      'options': ['Good morning', 'Good afternoon', 'Good evening', 'Good night'],
      'correctAnswer': 2,
      'explanation': 'Mwiriwe is used to greet someone in the evening',
      'difficulty': 'Medium',
      'category': 'Time-based Greetings'
    },
    {
      'audioText': 'Mwaramutse',
      'phonetic': '/mwa-ra-mut-se/',
      'question': 'When would you use this greeting?',
      'options': ['In the morning', 'In the afternoon', 'In the evening', 'At night'],
      'correctAnswer': 0,
      'explanation': 'Mwaramutse is the traditional morning greeting in Kinyarwanda',
      'difficulty': 'Medium',
      'category': 'Time-based Greetings'
    },
    {
      'audioText': 'Muramuke neza',
      'phonetic': '/mu-ra-mu-ke ne-za/',
      'question': 'What is this person wishing you?',
      'options': ['Good day', 'Safe travels', 'Sleep well', 'Good luck'],
      'correctAnswer': 2,
      'explanation': 'Muramuke neza is said when wishing someone a good night\'s sleep',
      'difficulty': 'Hard',
      'category': 'Well-wishes'
    },
    {
      'audioText': 'Ni mwiza',
      'phonetic': '/ni mwi-za/',
      'question': 'What does this phrase express?',
      'options': ['It is good', 'It is bad', 'It is big', 'It is small'],
      'correctAnswer': 0,
      'explanation': 'Ni mwiza means "It is good/beautiful" in Kinyarwanda',
      'difficulty': 'Medium',
      'category': 'Descriptions'
    },
    {
      'audioText': 'Amakuru',
      'phonetic': '/a-ma-ku-ru/',
      'question': 'What is this person asking about?',
      'options': ['Your name', 'The news/how are things', 'The time', 'The weather'],
      'correctAnswer': 1,
      'explanation': 'Amakuru literally means "news" but is used to ask "How are things?"',
      'difficulty': 'Hard',
      'category': 'Questions'
    },
    {
      'audioText': 'Ese umeze gute',
      'phonetic': '/e-se u-me-ze gu-te/',
      'question': 'What question is being asked?',
      'options': ['What is your name?', 'Where are you from?', 'How are you?', 'What time is it?'],
      'correctAnswer': 2,
      'explanation': 'Ese umeze gute is a formal way to ask "How are you?" in Kinyarwanda',
      'difficulty': 'Hard',
      'category': 'Questions'
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _initAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-US"); // Use English with African accent if available
      await _flutterTts.setSpeechRate(0.7); // Slower speech for learning
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(0.9); // Slightly lower pitch
      
      // Try to set voice to a more suitable one
      List<dynamic> voices = await _flutterTts.getVoices;
      if (voices.isNotEmpty) {
        // Look for voices that might sound more natural
        var preferredVoice = voices.firstWhere(
          (voice) => voice["name"].toString().toLowerCase().contains("female") ||
                     voice["name"].toString().toLowerCase().contains("african") ||
                     voice["name"].toString().toLowerCase().contains("samantha"),
          orElse: () => voices.first,
        );
        await _flutterTts.setVoice(preferredVoice);
      }
      
      setState(() {
        _ttsReady = true;
      });

      _flutterTts.setStartHandler(() {
        setState(() {
          _isPlaying = true;
        });
        _waveController.repeat();
      });

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isPlaying = false;
          _audioPlayed = true;
        });
        _waveController.stop();
        _waveController.reset();
      });

      _flutterTts.setErrorHandler((msg) {
        setState(() {
          _isPlaying = false;
        });
        _waveController.stop();
        print('TTS Error: $msg');
      });

    } catch (e) {
      print('TTS initialization error: $e');
      setState(() {
        _ttsReady = false;
      });
    }
  }

  Future<void> _playAudio() async {
    if (!_ttsReady) {
      _showAudioFallback();
      return;
    }

    try {
      if (_isPlaying) {
        await _flutterTts.stop();
        setState(() {
          _isPlaying = false;
        });
        _waveController.stop();
      } else {
        // Speak the Kinyarwanda phrase
        final currentExercise = _exercises[_currentExercise];
        await _flutterTts.speak(currentExercise['audioText']);
      }
    } catch (e) {
      print('TTS play error: $e');
      _showAudioFallback();
    }
  }

  void _showAudioFallback() {
    final currentExercise = _exercises[_currentExercise];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.volume_up, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Audio: "${currentExercise['audioText']}"'),
                  Text(
                    'Pronunciation: ${currentExercise['phonetic']}',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 4),
      ),
    );
    
    setState(() {
      _audioPlayed = true;
    });
  }

  void _selectAnswer(int index) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswer = index;
      _hasAnswered = true;
      _showCorrectAnswer = true;
      
      if (index == _exercises[_currentExercise]['correctAnswer']) {
        _score++;
      }
    });

    // Provide feedback sound/haptic
    _provideFeedback(index == _exercises[_currentExercise]['correctAnswer']);

    // Auto-advance after 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        _nextExercise();
      }
    });
  }

  void _provideFeedback(bool isCorrect) {
    // You could add sound effects here
    if (isCorrect) {
      // Play success sound or haptic feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Correct! Well done!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _nextExercise() {
    if (_currentExercise < _exercises.length - 1) {
      setState(() {
        _currentExercise++;
        _selectedAnswer = null;
        _hasAnswered = false;
        _showCorrectAnswer = false;
        _audioPlayed = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.orange),
            SizedBox(width: 8),
            Text('Exercise Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Score',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _score >= _exercises.length * 0.7 
                      ? [Colors.green, Colors.green.shade300]
                      : [Colors.orange, Colors.orange.shade300],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${((_score / _exercises.length) * 100).round()}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$_score/${_exercises.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              _score >= _exercises.length * 0.7 
                  ? 'Excellent! Your listening skills are improving!' 
                  : _score >= _exercises.length * 0.5
                      ? 'Good work! Keep practicing to improve.'
                      : 'Keep practicing! You\'re learning and getting better.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetExercise();
            },
            child: Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _resetExercise() {
    setState(() {
      _currentExercise = 0;
      _selectedAnswer = null;
      _hasAnswered = false;
      _showCorrectAnswer = false;
      _score = 0;
      _audioPlayed = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = _exercises[_currentExercise];
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.headphones, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Listening Exercises',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Train your Kinyarwanda listening',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentExercise + 1}/${_exercises.length}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar with animation
          Container(
            height: 6,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (_currentExercise + 1) / _exercises.length,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
          
          // Difficulty badge
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(currentExercise['difficulty']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    currentExercise['difficulty'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    currentExercise['category'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  
                  // Enhanced Audio Player Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade50, Colors.white],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Audio visualization with animations
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isPlaying ? _pulseAnimation.value : 1.0,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: _isPlaying 
                                        ? [Colors.orange, Colors.deepOrange]
                                        : [Colors.blue, Colors.blue.shade700],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isPlaying ? Colors.orange : Colors.blue).withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: _playAudio,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: _isPlaying ? Colors.orange : Colors.blue,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Audio status and text
                        if (_audioPlayed && !_isPlaying)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'You heard: "${currentExercise['audioText']}"',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pronunciation: ${currentExercise['phonetic']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: [
                              Text(
                                _isPlaying ? 'Listen carefully...' : 'Tap to listen',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _isPlaying ? Colors.orange : Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Listen to the Kinyarwanda phrase',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        
                        // TTS status indicator
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _ttsReady ? Icons.mic : Icons.mic_off,
                              size: 16,
                              color: _ttsReady ? Colors.green : Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _ttsReady ? 'Voice ready' : 'Text mode',
                              style: TextStyle(
                                fontSize: 12,
                                color: _ttsReady ? Colors.green : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Question Section with enhanced styling
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.quiz,
                              color: Colors.orange,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                currentExercise['question'],
                                style: TextStyle(
                                  fontSize: isTablet ? 22 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Enhanced Answer options
                        ...List.generate(
                          currentExercise['options'].length,
                          (index) => Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => _selectAnswer(index),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _getOptionColor(index),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _getOptionBorderColor(index),
                                    width: 2,
                                  ),
                                  boxShadow: _selectedAnswer == index
                                      ? [
                                          BoxShadow(
                                            color: _getOptionBorderColor(index).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _getOptionIconColor(index),
                                        border: Border.all(
                                          color: _getOptionBorderColor(index),
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: _getOptionIcon(index) ?? 
                                            Text(
                                              String.fromCharCode(65 + index), // A, B, C, D
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _selectedAnswer == index 
                                                    ? Colors.white 
                                                    : _getOptionBorderColor(index),
                                              ),
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        currentExercise['options'][index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: _getOptionTextColor(index),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Enhanced Explanation
                        if (_showCorrectAnswer)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.blue.shade50, Colors.blue.shade25],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Explanation',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  currentExercise['explanation'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue.shade700,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Enhanced Score display
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade50, Colors.orange.shade25],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.orange.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Colors.orange,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Column(
                          children: [
                            Text(
                              'Current Score',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange.shade600,
                              ),
                            ),
                            Text(
                              '$_score/${_exercises.length}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          child: Center(
                            child: Text(
                              '${_exercises.length > 0 ? ((_score / _exercises.length) * 100).round() : 0}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getOptionColor(int index) {
    if (!_showCorrectAnswer) {
      return _selectedAnswer == index ? Colors.blue.shade50 : Colors.grey.shade50;
    }
    
    if (index == _exercises[_currentExercise]['correctAnswer']) {
      return Colors.green.shade50;
    } else if (_selectedAnswer == index) {
      return Colors.red.shade50;
    }
    return Colors.grey.shade50;
  }

  Color _getOptionBorderColor(int index) {
    if (!_showCorrectAnswer) {
      return _selectedAnswer == index ? Colors.blue : Colors.grey.shade300;
    }
    
    if (index == _exercises[_currentExercise]['correctAnswer']) {
      return Colors.green;
    } else if (_selectedAnswer == index) {
      return Colors.red;
    }
    return Colors.grey.shade300;
  }

  Color _getOptionIconColor(int index) {
    if (!_showCorrectAnswer) {
      return _selectedAnswer == index ? Colors.blue : Colors.transparent;
    }
    
    if (index == _exercises[_currentExercise]['correctAnswer']) {
      return Colors.green;
    } else if (_selectedAnswer == index) {
      return Colors.red;
    }
    return Colors.transparent;
  }

  Color _getOptionTextColor(int index) {
    if (!_showCorrectAnswer) {
      return _selectedAnswer == index ? Colors.blue.shade800 : Colors.grey.shade800;
    }
    
    if (index == _exercises[_currentExercise]['correctAnswer']) {
      return Colors.green.shade800;
    } else if (_selectedAnswer == index) {
      return Colors.red.shade800;
    }
    return Colors.grey.shade800;
  }

  Widget? _getOptionIcon(int index) {
    if (!_showCorrectAnswer) {
      return _selectedAnswer == index 
          ? Icon(Icons.check, color: Colors.white, size: 18)
          : null;
    }
    
    if (index == _exercises[_currentExercise]['correctAnswer']) {
      return Icon(Icons.check, color: Colors.white, size: 18);
    } else if (_selectedAnswer == index) {
      return Icon(Icons.close, color: Colors.white, size: 18);
    }
    return null;
  }
}
