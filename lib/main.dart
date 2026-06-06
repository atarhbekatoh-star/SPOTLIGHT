import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'providers/app_provider.dart';
import 'welcome_page.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'skills_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'journal_page.dart';
import 'reminder_page.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/daily_mission_card.dart';
import 'widgets/continue_learning_list.dart';
import 'widgets/quick_actions_grid.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeMode _themeMode =
      ThemeMode.dark; // Default to dark as per existing design

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotlight',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;
  final String userName;
  final String fullName;

  const MainScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.userName,
    required this.fullName,
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
      DashboardView(onNavigateToProfile: () => _onTabTapped(3), userName: widget.userName),
      ChatPage(),
      const SkillsPage(), // Practice tab
      ProfilePage(
        currentThemeMode: widget.currentThemeMode,
        onThemeChanged: widget.onThemeChanged,
        userName: widget.userName,
        fullName: widget.fullName,
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
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outlined), label: 'chat'),
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
  final String userName;

  const DashboardView({super.key, required this.onNavigateToProfile, required this.userName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color purpleGlow = Color(0xFFBB86FC);

    return Stack(
      children: [
        // Background Glow effect top right
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [purpleGlow.withAlpha(40), Colors.transparent],
              ),
            ),
          ),
        ),
        // Background Glow effect middle left
        Positioned(
          top: 300,
          left: -150,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [purpleGlow.withAlpha(30), Colors.transparent],
              ),
            ),
          ),
        ),

        SafeArea(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.easeOutQuart,
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(onProfileTap: onNavigateToProfile, userName: userName),
                  const SizedBox(height: 30),

                  Row(
                    children: [
                      const Icon(Icons.rocket_launch, color: purpleGlow, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "TODAY'S MISSION",
                        style: theme.textTheme.titleSmall?.copyWith(letterSpacing: 1.2, color: purpleGlow),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const DailyMissionCard(),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_graph, color: purpleGlow, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "CONTINUE LEARNING",
                            style: theme.textTheme.titleSmall?.copyWith(letterSpacing: 1.2, color: purpleGlow),
                          ),
                        ],
                      ),
                      const Text(
                        "See All",
                        style: TextStyle(
                          color: purpleGlow,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const ContinueLearningList(),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Icon(Icons.flash_on, color: purpleGlow, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "QUICK ACTIONS",
                        style: theme.textTheme.titleSmall?.copyWith(letterSpacing: 1.2, color: purpleGlow),
                      ),
                    ],
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReminderPage(userName: userName)),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                  // AI Suggestion Banner
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: purpleGlow.withAlpha(20),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: purpleGlow.withAlpha(50)),
                      boxShadow: [
                        BoxShadow(color: purpleGlow.withAlpha(10), blurRadius: 20, spreadRadius: 5)
                      ]
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: purpleGlow.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lightbulb_outline, color: purpleGlow),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            "Tip: Consistency beats intensity. 5 minutes of practice today is better than 1 hour tomorrow.",
                            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
