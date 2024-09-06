import 'package:flutter/material.dart';
import 'package:qr_scanner/generate_qr.dart'; // Import the widget for generating QR codes
import 'package:qr_scanner/scan_qr.dart'; // Import the widget for scanning QR codes
import 'package:qr_scanner/settings_page.dart'; // Import the settings page widget

class HomePage extends StatelessWidget {
  // Define a callback function for changing the theme
  final Function(bool) onThemeChanged;

  // Constructor for HomePage requiring onThemeChanged function as a parameter
  const HomePage({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs in the TabBar
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner & Generator'), // Title of the AppBar
          backgroundColor: Colors.green, // Background color of the AppBar
          centerTitle: true, // Center the title in the AppBar
          actions: [
            IconButton(
              icon: const Icon(Icons.settings), // Settings icon in the AppBar
              onPressed: () {
                // When the settings icon is pressed, navigate to the SettingsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(onThemeChanged: onThemeChanged),
                  ),
                );
              },
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Scan Code'), // First tab for scanning QR codes
              Tab(text: 'Generate Code'), // Second tab for generating QR codes
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ScanQRCode(), // Widget for scanning QR codes (first tab)
            GenerateQRCode(), // Widget for generating QR codes (second tab)
          ],
        ),
      ),
    );
  }
}
