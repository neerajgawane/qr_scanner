import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for using shared preferences

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeChanged; // Callback function to change the theme

  const SettingsPage({super.key, required this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState(); // Create the state for SettingsPage
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> history = []; // List to hold QR code history

  @override
  void initState() {
    super.initState();
    _loadHistory(); // Load the QR code history when the page initializes
  }

  // Load QR code history from shared preferences
  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get the instance of shared preferences
    setState(() {
      history = prefs.getStringList('qr_history') ?? []; // Retrieve history or initialize to empty list
    });
  }

  // Clear the QR code history from shared preferences
  Future<void> _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get the instance of shared preferences
    await prefs.remove('qr_history'); // Remove the history entry
    setState(() {
      history.clear(); // Clear the local history list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // Title of the settings page
        backgroundColor: Colors.green, // Background color of the AppBar
        centerTitle: true, // Center the title in the AppBar
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Switch for toggling dark mode
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: Theme.of(context).brightness == Brightness.dark, // Check if the current theme is dark mode
            onChanged: (value) {
              widget.onThemeChanged(value); // Call the callback to change the theme
            },
          ),
          const SizedBox(height: 20),
          // List tile to show QR code history
          ListTile(
            title: const Text('QR Code History'),
            trailing: const Icon(Icons.history), // History icon
            onTap: () {
              _showHistoryDialog(); // Show the QR code history dialog
            },
          ),
          const SizedBox(height: 20),
          // Button to clear QR code history
          ElevatedButton(
            onPressed: _clearHistory, // Call the method to clear history
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, // Background color of the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners of the button
              ),
            ),
            child: const Text(
              'Clear History',
              style: TextStyle(fontWeight: FontWeight.bold), // Bold text style
            ),
          ),
        ],
      ),
    );
  }

  // Display QR code history in a dialog
  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('QR Code History'), // Title of the dialog
          content: SizedBox(
            width: double.maxFinite, // Full width of the dialog
            height: 300, // Fixed height of the dialog
            child: history.isNotEmpty
                ? ListView.builder(
                    itemCount: history.length, // Number of items in the history list
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(history[index]), // Display history item
                        leading: const Icon(Icons.qr_code), // QR code icon
                      );
                    },
                  )
                : const Center(
                    child: Text('No history available'), // Message if no history items are available
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog when 'Close' button is pressed
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}



