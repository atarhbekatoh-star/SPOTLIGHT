import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'skills_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'journal_page.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/daily_mission_card.dart';
import 'widgets/continue_learning_list.dart';
import 'widgets/quick_actions_grid.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode =
      ThemeMode.dark; // Default to dark as per existing design

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotlight',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: MainScreen(
        currentThemeMode: _themeMode,
        onThemeChanged: _changeTheme,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;

  const MainScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardView(onNavigateToProfile: () => _onTabTapped(3)),
     const ChatPage(),
      const SkillsPage(), // Practice tab
      ProfilePage(
        currentThemeMode: widget.currentThemeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Practice',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  final VoidCallback onNavigateToProfile;

  const DashboardView({super.key, required this.onNavigateToProfile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(onProfileTap: onNavigateToProfile),
            const SizedBox(height: 30),

            Text(
              "TODAY'S MISSION",
              style: theme.textTheme.titleSmall?.copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 15),
            const DailyMissionCard(),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "CONTINUE LEARNING",
                  style: theme.textTheme.titleSmall?.copyWith(
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "See All",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const ContinueLearningList(),

            const SizedBox(height: 30),
            Text(
              "QUICK ACTIONS",
              style: theme.textTheme.titleSmall?.copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 15),
            QuickActionsGrid(
              onJournalTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JournalPage()),
                );
              },
              onRemindersTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Reminders coming soon!")),
                );
              },
            ),

            const SizedBox(height: 30),
            // AI Suggestion Banner
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: theme.primaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: theme.primaryColor.withAlpha(50)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: theme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tip: Consistency beats intensity. 5 minutes of practice today is better than 1 hour tomorrow.",
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
