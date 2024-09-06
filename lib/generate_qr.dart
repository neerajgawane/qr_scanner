import 'dart:typed_data'; // Import for handling byte data
import 'dart:ui'; // Import for working with images
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart'; // Import for saving images to the gallery
import 'package:flutter/rendering.dart'; // Import for rendering images
import 'package:qr_flutter/qr_flutter.dart'; // Import for QR code generation
import 'package:share_plus/share_plus.dart'; // Import for sharing content
import 'package:path_provider/path_provider.dart'; // Import for finding directory paths
import 'dart:io'; // Import for file operations

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key}); // Constructor for GenerateQRCode

  @override
  State<GenerateQRCode> createState() => _GenerateQRCodeState(); // Create the state for GenerateQRCode
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  final TextEditingController urlController = TextEditingController(); // Controller for the text field input
  final GlobalKey _qrKey = GlobalKey(); // Key to identify the widget for capturing its image

  // Method to save QR code as an image in the gallery
  Future<void> _saveQRCode() async {
    if (urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate a QR code first!')),
      );
      return;
    }
    try {
      RenderRepaintBoundary? boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture QR code')),
        );
        return;
      }
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(pngBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['isSuccess'] ? 'QR Code saved to gallery!' : 'Failed to save QR Code')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save QR Code')),
      );
    }
  }

  // Method to share QR code as an image
  Future<void> _shareQRCode() async {
    if (urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate a QR code first!')),
      );
      return;
    }
    try {
      RenderRepaintBoundary? boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture QR code')),
        );
        return;
      }
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getTemporaryDirectory()).path; // Get the temporary directory path
      final file = File('$directory/qr_code.png'); // Define the path and name of the image file
      await file.writeAsBytes(pngBytes); // Write the QR code image to the file

      await Share.shareXFiles([XFile(file.path)], text: 'Check out this QR code!'); // Share the QR code image
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share QR Code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _qrKey,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: urlController.text.isNotEmpty
                      ? QrImageView(data: urlController.text, size: 200) // Display QR code if URL is provided
                      : Image.asset('assets/images/generate.png', height: 200, width: 200), // Placeholder image if no URL
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  labelText: 'Enter URL or Text', // Label for the text field
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {}); // Trigger a rebuild to update the QR code display
                },
                icon: const Icon(Icons.qr_code, size: 24),
                label: const Text(
                  'Generate QR Code',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _shareQRCode, // Calls the share method
                    icon: const Icon(Icons.share, size: 24),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _saveQRCode, // Calls the save method
                    icon: const Icon(Icons.save_alt, size: 24),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
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
}
