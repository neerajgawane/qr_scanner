import 'package:flutter/material.dart';
import 'package:qr_scanner/home_page.dart'; // Importing the HomePage widget from another file

void main() {
  runApp(const MyApp()); // Entry point of the application, where MyApp widget is run
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); // Constructor for MyApp with an optional key parameter
  
  @override
  _MyAppState createState() => _MyAppState(); // Creates the mutable state for MyApp
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false; // State variable to keep track of dark mode status

  // Function to toggle dark mode
  void _toggleDarkMode(bool isDarkMode) {
    setState(() {
      _darkMode = isDarkMode; // Update state based on dark mode status
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disables the debug banner in the top-right corner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green, // Primary color of the theme
          brightness: _darkMode ? Brightness.dark : Brightness.light, // Sets brightness based on dark mode
        ),
        useMaterial3: true, // Enables Material Design 3 features
      ),
      home: HomePage(onThemeChanged: _toggleDarkMode), // Sets HomePage as the main screen of the app
    );
  }
}
