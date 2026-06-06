import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'database_helper.dart';

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

  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  
  List<Map<String, dynamic>> _pastJournals = [];

  @override
  void initState() {
    super.initState();
    _loadPastJournals();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _loadPastJournals() async {
    final journals = await DatabaseHelper.instance.readAllJournals();
    if (mounted) {
      setState(() {
        _pastJournals = journals;
      });
    }
  }

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

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      if (mounted) {
        setState(() {
          _isRecording = false;
          if (path != null) {
            _voiceNote = path;
          }
        });
      }
    } else {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        if (mounted) {
          setState(() {
            _isRecording = true;
            _voiceNote = null;
          });
        }
      }
    }
  }

  Future<void> _togglePlayback() async {
    if (_voiceNote == null) return;
    
    if (_isPlaying) {
      await _audioPlayer.pause();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(_voiceNote!));
      if (mounted) setState(() => _isPlaying = true);
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

    await DatabaseHelper.instance.createJournal(entry);

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
      _isPlaying = false;
    });
    _loadPastJournals();
  }

  @override
  void dispose() {
    _journalController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
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
            _buildActionButton(
              _isRecording ? "STOP RECORDING" : "VOICE ENTRY",
              _isRecording ? Icons.stop : Icons.mic,
              _isRecording ? Colors.redAccent : purpleGlow,
              _toggleRecording,
            ),
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
                        GestureDetector(
                          onTap: _togglePlayback,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: purpleGlow.withAlpha(40),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: purpleGlow, size: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Voice note recorded",
                            style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              fontSize: 14,
                              height: 1.4,
                            ),
                            maxLines: 1,
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
                      onTap: () async {
                        await _audioPlayer.stop();
                        if (mounted) {
                          setState(() {
                            _voiceNote = null;
                            _isPlaying = false;
                          });
                        }
                      },
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
            if (_pastJournals.isNotEmpty) ...[
              Text(
                "Past Journals",
                style: TextStyle(color: purpleGlow.withAlpha(200), fontSize: 16),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pastJournals.length,
                itemBuilder: (context, index) {
                  final entry = _pastJournals[index];
                  return JournalEntryCard(entry: entry);
                },
              ),
              const SizedBox(height: 30),
            ],
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

class JournalEntryCard extends StatefulWidget {
  final Map<String, dynamic> entry;

  const JournalEntryCard({super.key, required this.entry});

  @override
  State<JournalEntryCard> createState() => _JournalEntryCardState();
}

class _JournalEntryCardState extends State<JournalEntryCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    final voiceNote = widget.entry['voiceNote'];
    if (voiceNote == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(voiceNote));
      if (mounted) setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color purpleGlow = Color(0xFFBB86FC);
    const Color cardBackground = Color(0xFF11162D);

    final date = DateTime.tryParse(widget.entry['date'] ?? '') ?? DateTime.now();
    final formattedDate = "\${date.day}/\${date.month}/\${date.year} \${date.hour}:\${date.minute.toString().padLeft(2, '0')}";
    final mood = widget.entry['mood'];
    final text = widget.entry['text'];
    final imagePath = widget.entry['imagePath'];
    final voiceNote = widget.entry['voiceNote'];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: purpleGlow.withAlpha(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: TextStyle(color: purpleGlow.withAlpha(180), fontSize: 13),
              ),
              if (mood != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: purpleGlow.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    mood.toString(),
                    style: const TextStyle(color: purpleGlow, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (text != null && text.toString().isNotEmpty)
            Text(
              text.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
            ),
          if (imagePath != null) ...[
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[900],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                ),
              ),
            ),
          ],
          if (voiceNote != null) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: purpleGlow.withAlpha(40)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _togglePlay,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: purpleGlow.withAlpha(_isPlaying ? 80 : 40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: purpleGlow, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Voice Recording",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
