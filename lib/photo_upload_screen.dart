import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  File? _image;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060914),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Profile Photo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PROFILE IMAGE

              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),

                    height: 210,
                    width: 210,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4D8DFF),
                          Color(0xFF7B61FF),
                        ],
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withAlpha(70),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(4),

                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF11162D),

                          image: _image != null
                              ? DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),

                        child: _image == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 95,
                                color: Colors.white24,
                              )
                            : null,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: const Color(0xFF4D8DFF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF060914),
                        width: 3,
                      ),
                    ),

                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "Upload a profile picture",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Choose an image from your computer or device.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 40),

              // BUTTON

              _buildUploadButton(
                label: "Choose Image",
                icon: Icons.upload_rounded,
                onPressed: _pickImage,
              ),
            ],
          ),
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
      width: double.infinity,
      height: 56,

      child: ElevatedButton.icon(
        onPressed: onPressed,

        icon: Icon(icon, size: 22),

        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF11162D),
          foregroundColor: Colors.white,

          elevation: 0,

          side: BorderSide(
            color: Colors.white.withAlpha(18),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}