import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  int _selectedMoodIndex = -1;
  final TextEditingController _journalController = TextEditingController();

  final List<Map<String, String>> _moods = [
    {'emoji': '😄', 'label': 'Joy'},
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😐', 'label': 'Moody'},
    {'emoji': '😔', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Angry'},
  ];

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

            // ACTION BUTTONS
            _buildActionButton("ADD PHOTO", Icons.camera_alt, purpleGlow),
            const SizedBox(height: 12),
            _buildActionButton("VOICE ENTRY", Icons.mic, purpleGlow),

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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Journal Entry Saved!")),
                  );
                },
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

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {}, // Link to your photo logic here
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
