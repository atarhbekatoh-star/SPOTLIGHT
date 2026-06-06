import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  int _selectedMoodIndex = -1;
  final TextEditingController _journalController = TextEditingController();
  String? _imagePath;
  String? _voiceNote;

  final List<Map<String, String>> _moods = [
    {'emoji': '😄', 'label': 'Joy'},
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😐', 'label': 'Moody'},
    {'emoji': '😔', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Angry'},
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _showVoiceNoteDialog() async {
    final controller = TextEditingController(text: _voiceNote ?? '');
    const Color purpleGlow = Color(0xFFBB86FC);
    const Color darkBackground = Color(0xFF060914);
    const Color cardBackground = Color(0xFF11162D);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: purpleGlow.withAlpha(80)),
        ),
        title: Row(
          children: [
            Icon(Icons.mic, color: purpleGlow, size: 22),
            const SizedBox(width: 10),
            Text(
              'Voice Memo',
              style: TextStyle(
                color: purpleGlow,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Type your voice memo here...',
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: darkBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: purpleGlow.withAlpha(50)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: purpleGlow.withAlpha(50)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: purpleGlow),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: purpleGlow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Save Memo',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _voiceNote = result.trim();
      });
    }
  }

  Future<void> _saveReflection() async {
    if (_journalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please write how you feel before saving.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final entry = {
      'text': _journalController.text,
      'mood': _selectedMoodIndex >= 0 ? _moods[_selectedMoodIndex]['label'] : null,
      'imagePath': _imagePath,
      'voiceNote': _voiceNote,
      'date': DateTime.now().toIso8601String(),
    };

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('journal_entries') ?? [];
    existing.add(jsonEncode(entry));
    await prefs.setStringList('journal_entries', existing);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✨ Journal entry saved!'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    setState(() {
      _journalController.clear();
      _selectedMoodIndex = -1;
      _imagePath = null;
      _voiceNote = null;
    });
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color purpleGlow = Color(0xFFBB86FC);
    const Color darkBackground = Color(0xFF060914);
    const Color cardBackground = Color(0xFF11162D);

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: purpleGlow),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "MY JORNAL",
          style: TextStyle(
            color: purpleGlow,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Your thoughts today...",
              style: TextStyle(color: purpleGlow.withAlpha(200), fontSize: 16),
            ),
            const SizedBox(height: 15),

            // JOURNAL INPUT BOX
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: purpleGlow.withAlpha(50)),
              ),
              child: TextField(
                controller: _journalController,
                maxLines: 6,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Today I tried a new conversation with...",
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // ADD PHOTO BUTTON
            _buildActionButton("ADD PHOTO", Icons.camera_alt, purpleGlow, _pickImage),
            // SELECTED IMAGE PREVIEW
            if (_imagePath != null) ...[
              const SizedBox(height: 12),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: purpleGlow.withAlpha(80)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        File(_imagePath!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _imagePath = null),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(180),
                          shape: BoxShape.circle,
                          border: Border.all(color: purpleGlow.withAlpha(120)),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // VOICE ENTRY BUTTON
            _buildActionButton("VOICE ENTRY", Icons.mic, purpleGlow, _showVoiceNoteDialog),
            // VOICE NOTE PREVIEW
            if (_voiceNote != null) ...[
              const SizedBox(height: 12),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: purpleGlow.withAlpha(80)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: purpleGlow.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.mic, color: purpleGlow, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _voiceNote!,
                            style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              fontSize: 14,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _voiceNote = null),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(180),
                          shape: BoxShape.circle,
                          border: Border.all(color: purpleGlow.withAlpha(120)),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 35),
            Text(
              "How do you feel?",
              style: TextStyle(color: purpleGlow.withAlpha(200), fontSize: 16),
            ),
            const SizedBox(height: 15),

            // MOOD SELECTOR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_moods.length, (index) {
                bool isSelected = _selectedMoodIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMoodIndex = index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? purpleGlow.withAlpha(51)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: purpleGlow.withAlpha(77),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: isSelected ? 35 : 28,
                          ),
                          child: Text(
                            _moods[index]['emoji']!,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isSelected ? 1.0 : 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _moods[index]['label']!,
                            style: const TextStyle(
                              color: purpleGlow,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveReflection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleGlow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Save Reflection",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, letterSpacing: 1.1),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withAlpha(128)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
