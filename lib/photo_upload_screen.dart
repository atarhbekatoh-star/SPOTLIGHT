import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060914),
      appBar: AppBar(
        title: const Text(
          "Profile Photo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // PROFILE IMAGE PREVIEW
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF11162D),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent, width: 2),
                image: _image != null
                    ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _image == null
                  ? const Icon(Icons.person, size: 100, color: Colors.white24)
                  : null,
            ),
            const SizedBox(height: 40),

            // UPLOAD BUTTONS
            _buildUploadButton(
              label: "Take a Photo",
              icon: Icons.camera_alt,
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 15),
            _buildUploadButton(
              label: "Choose from Gallery",
              icon: Icons.photo_library,
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF11162D),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
