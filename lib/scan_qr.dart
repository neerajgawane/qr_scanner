import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For handling platform-specific operations
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; // For scanning QR codes
import 'package:url_launcher/url_launcher.dart';  // For launching URLs
import 'dart:core'; // Core Dart library

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState(); // Create the state for ScanQRCode
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String qrResult = "\"Scanned data will appear here\""; // Default text before scanning

  // List of potentially harmful keywords or domains
  final List<String> harmfulSites = [
    "phishing.com",
    "malware.com",
    "dangerous-site.com",
    // Add more harmful domains here
  ];

  // Function to start the QR code scanning process
  Future<void> scanQR() async {
    try {
      // Invoke the QR scanner
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        qrResult = qrCode.toString(); // Update the result with scanned data
      });

      // Validate if the QR code is a harmful URL
      if (_isPotentiallyHarmful(qrResult)) {
        _showHarmfulUrlAlert(); // Show warning if harmful
      } else {
        _openScannedURL(qrResult); // Open the URL if safe
      }
    } on PlatformException {
      qrResult = 'Failed to read QR Code'; // Handle exception if QR code reading fails
    } catch (error) {
      qrResult = 'Failed to read QR Code'; // Handle any other errors
    }
  }

  // Check if the URL is harmful
  bool _isPotentiallyHarmful(String url) {
    for (String harmfulSite in harmfulSites) {
      if (url.contains(harmfulSite)) {
        return true; // Return true if URL contains harmful domain
      }
    }
    return false; // Return false if URL does not contain harmful domains
  }

  // Show an alert dialog if the URL is potentially harmful
  void _showHarmfulUrlAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning!'), // Title of the alert dialog
        content: const Text('This URL may lead to a harmful or unsafe website. Proceed with caution.'), // Warning message
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _openScannedURL(qrResult); // Proceed to open the URL
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  // Open the scanned URL using a URL launcher
  Future<void> _openScannedURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url); // Launch the URL if it can be launched
    } else {
      throw 'Could not launch $url'; // Throw an error if URL cannot be launched
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          children: [
            Image.asset(height: 200, 'assets/images/scanner.png'), // Display scanner image
            const SizedBox(height: 30),
            Text(
              qrResult == '-1' ? "\"Scanned data will appear here\"" : qrResult, // Display scanned result or default message
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                scanQR(); // Trigger QR code scanning on tap
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.greenAccent, // Background color of the button
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: const Text(
                  'Scan QR Code',
                  style: TextStyle(fontWeight: FontWeight.bold), // Button text style
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
