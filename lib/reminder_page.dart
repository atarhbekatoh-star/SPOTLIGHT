import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderPage extends StatefulWidget {
  final String userName;
  const ReminderPage({super.key, required this.userName});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  static const Color purpleGlow = Color(0xFFBB86FC);
  static const Color darkBackground = Color(0xFF060914);
  static const Color cardBackground = Color(0xFF11162D);

  List<Map<String, dynamic>> _reminders = [];

  // Category metadata
  static const Map<String, IconData> _categoryIcons = {
    'Mission': Icons.rocket_launch,
    'Personal': Icons.person,
    'Study': Icons.menu_book,
    'Health': Icons.favorite,
  };

  static const Map<String, Color> _categoryColors = {
    'Mission': Color(0xFF64B5F6),
    'Personal': Color(0xFFCE93D8),
    'Study': Color(0xFF81C784),
    'Health': Color(0xFFEF5350),
  };

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  // ---------------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------------

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('spotlight_reminders');
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      setState(() {
        _reminders = decoded.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('spotlight_reminders', jsonEncode(_reminders));
  }

  // ---------------------------------------------------------------------------
  // Add / Delete
  // ---------------------------------------------------------------------------

  void _addReminder(Map<String, dynamic> reminder) {
    setState(() {
      _reminders.insert(0, reminder);
    });
    _saveReminders();
  }

  void _deleteReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
    _saveReminders();
  }

  // ---------------------------------------------------------------------------
  // Dialog
  // ---------------------------------------------------------------------------

  void _showAddReminderDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    DateTime? pickedDate;
    TimeOfDay? pickedTime;
    String selectedCategory = 'Mission';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- Header ----------
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: purpleGlow.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_active,
                            color: purpleGlow, size: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'NEW REMINDER',
                        style: TextStyle(
                          color: purpleGlow,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ---------- Title field ----------
                    _dialogTextField(
                      controller: titleCtrl,
                      hint: 'Reminder title',
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 14),

                    // ---------- Description field ----------
                    _dialogTextField(
                      controller: descCtrl,
                      hint: 'Description (optional)',
                      icon: Icons.notes,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    // ---------- Date picker ----------
                    _dialogPickerTile(
                      icon: Icons.calendar_today,
                      label: pickedDate != null
                          ? '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}'
                          : 'Pick a date',
                      onTap: () async {
                        final date = await showDatePicker(
                          context: ctx,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (c, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: purpleGlow,
                                surface: cardBackground,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (date != null) {
                          setDialogState(() => pickedDate = date);
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // ---------- Time picker ----------
                    _dialogPickerTile(
                      icon: Icons.access_time,
                      label: pickedTime != null
                          ? pickedTime!.format(ctx)
                          : 'Pick a time',
                      onTap: () async {
                        final time = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay.now(),
                          builder: (c, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: purpleGlow,
                                surface: cardBackground,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (time != null) {
                          setDialogState(() => pickedTime = time);
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // ---------- Category chips ----------
                    Text(
                      'CATEGORY',
                      style: TextStyle(
                        color: purpleGlow.withAlpha(180),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categoryColors.keys.map((cat) {
                        final isSelected = selectedCategory == cat;
                        final catColor = _categoryColors[cat]!;
                        return GestureDetector(
                          onTap: () =>
                              setDialogState(() => selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? catColor.withAlpha(40)
                                  : Colors.white.withAlpha(8),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected
                                    ? catColor
                                    : Colors.white.withAlpha(25),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_categoryIcons[cat],
                                    size: 16,
                                    color: isSelected
                                        ? catColor
                                        : Colors.white54),
                                const SizedBox(width: 6),
                                Text(
                                  cat,
                                  style: TextStyle(
                                    color: isSelected
                                        ? catColor
                                        : Colors.white54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // ---------- Save button ----------
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a title'),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          final reminder = {
                            'id': DateTime.now().millisecondsSinceEpoch,
                            'title': titleCtrl.text.trim(),
                            'description': descCtrl.text.trim(),
                            'date': pickedDate?.toIso8601String() ??
                                DateTime.now().toIso8601String(),
                            'time': pickedTime != null
                                ? '${pickedTime!.hour}:${pickedTime!.minute.toString().padLeft(2, '0')}'
                                : '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
                            'category': selectedCategory,
                          };
                          _addReminder(reminder);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reminder saved! ✨'),
                              backgroundColor: Colors.deepPurple,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purpleGlow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 6,
                          shadowColor: purpleGlow.withAlpha(100),
                        ),
                        child: const Text(
                          'Save Reminder',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Dialog helper widgets
  // ---------------------------------------------------------------------------

  Widget _dialogTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: darkBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: purpleGlow.withAlpha(40)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: purpleGlow.withAlpha(150), size: 20),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withAlpha(60)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _dialogPickerTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: darkBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: purpleGlow.withAlpha(40)),
        ),
        child: Row(
          children: [
            Icon(icon, color: purpleGlow.withAlpha(180), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: label.startsWith('Pick')
                    ? Colors.white.withAlpha(100)
                    : Colors.white,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios,
                color: purpleGlow.withAlpha(80), size: 14),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: purpleGlow),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MY REMINDERS',
          style: TextStyle(
            color: purpleGlow,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        backgroundColor: purpleGlow,
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
      body: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeOutQuart,
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: child,
            ),
          );
        },
        child: _reminders.isEmpty ? _buildEmptyState() : _buildReminderList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty state
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: purpleGlow.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                color: purpleGlow.withAlpha(120),
                size: 72,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No reminders yet',
              style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap + to create your first reminder',
              style: TextStyle(
                color: Colors.white.withAlpha(90),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reminder list
  // ---------------------------------------------------------------------------

  Widget _buildReminderList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      itemCount: _reminders.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 400 + (index * 80)),
          tween: Tween<double>(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, double val, child) {
            return Opacity(
              opacity: val,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - val)),
                child: child,
              ),
            );
          },
          child: _buildReminderCard(_reminders[index], index),
        );
      },
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder, int index) {
    final String category = reminder['category'] ?? 'Mission';
    final Color catColor = _categoryColors[category] ?? purpleGlow;
    final IconData catIcon = _categoryIcons[category] ?? Icons.rocket_launch;

    // Parse date
    DateTime date;
    try {
      date = DateTime.parse(reminder['date']);
    } catch (_) {
      date = DateTime.now();
    }
    final String dateStr =
        '${_monthName(date.month)} ${date.day}, ${date.year}';
    final String timeStr = reminder['time'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: catColor.withAlpha(40)),
          boxShadow: [
            BoxShadow(
              color: catColor.withAlpha(15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row — icon, category pill, delete
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: catColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(catIcon, color: catColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: catColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: catColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => _deleteReminder(index),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.delete_outline,
                          color: Colors.white.withAlpha(80), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                reminder['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              // Description
              if ((reminder['description'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  reminder['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withAlpha(130),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Date + Time row
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      color: purpleGlow.withAlpha(130), size: 14),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: TextStyle(
                      color: Colors.white.withAlpha(120),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time,
                      color: purpleGlow.withAlpha(130), size: 14),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(timeStr),
                    style: TextStyle(
                      color: Colors.white.withAlpha(120),
                      fontSize: 12,
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

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  String _formatTime(String raw) {
    if (raw.isEmpty) return '--:--';
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    int hour = int.tryParse(parts[0]) ?? 0;
    final min = parts[1];
    final suffix = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return '$hour:$min $suffix';
  }
}
