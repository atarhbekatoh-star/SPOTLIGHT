import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;

  const ProfilePage({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode =
        currentThemeMode == ThemeMode.dark ||
        (currentThemeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6200EA), Color(0xFF1A237E)],
                      ),
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 4,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Sam",
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 5),
            Text("Level 1 Learner", style: theme.textTheme.titleSmall),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SwitchListTile(
                title: const Text("Dark Theme"),
                secondary: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                value: isDarkMode,
                activeTrackColor: Colors.purpleAccent.withAlpha(100),
                onChanged: (bool value) {
                  onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Settings coming soon!")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
