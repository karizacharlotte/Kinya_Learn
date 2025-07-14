import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  ThemeProvider() {
    _loadTheme();
  }
  
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    notifyListeners();
  }
  
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    notifyListeners();
  }
  
  void setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    notifyListeners();
  }
  
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    primaryColor: Colors.orange,
    scaffoldBackgroundColor: Colors.grey[50],
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey[600],
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.grey[800]),
      bodyMedium: TextStyle(color: Colors.grey[600]),
      titleLarge: TextStyle(color: Colors.grey[900]),
      titleMedium: TextStyle(color: Colors.grey[800]),
    ),
    iconTheme: IconThemeData(
      color: Colors.grey[600],
    ),
    dividerColor: Colors.grey[300],
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
    ),
  );
  
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    primaryColor: Colors.orange,
    scaffoldBackgroundColor: Colors.grey[900],
    cardColor: Colors.grey[800],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[900],
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey[400],
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
    iconTheme: IconThemeData(
      color: Colors.white70,
    ),
    dividerColor: Colors.grey[700],
    cardTheme: CardTheme(
      color: Colors.grey[800],
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.3),
    ),
  );
}
