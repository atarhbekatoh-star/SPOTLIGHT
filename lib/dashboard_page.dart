import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'pages/other_user_profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await DatabaseHelper.instance.getAllUsers();
    setState(() {
      _allUsers = users;
    });
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final lowerQuery = query.toLowerCase();
    setState(() {
      _searchResults = _allUsers.where((user) {
        final username = (user['username'] ?? '').toString().toLowerCase();
        return username.contains(lowerQuery);
      }).toList();
    });
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            user['username'] ?? 'Unknown',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("Tap to view profile", style: TextStyle(color: Colors.white54)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUserProfilePage(user: user),
              ),
            );
          },
        );
      },
    );
  }

  // --- FRIEND'S GAME MECHANICS STATE ---
  int xp = 30;
  int currentLevelIndex = 0;

  final List<Map<String, dynamic>> levels = [
    {"title": "Extra", "icon": "🎭", "color": Colors.grey},
    {"title": "Supporting Role", "icon": "🎬", "color": Colors.blueAccent},
    {"title": "Main Character", "icon": "✨", "color": Colors.purpleAccent},
    {"title": "Leading Role", "icon": "👑", "color": Colors.amber},
  ];

  void _gainXP() {
    setState(() {
      xp += 25; // Bigger jump for better feel
      if (xp >= 100) {
        if (currentLevelIndex < levels.length - 1) {
          xp = 0;
          currentLevelIndex++;
          _showLevelUpDialog();
        } else {
          xp = 100; // Maxed out
        }
      }
    });
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("LEVEL UP! 🎉", style: TextStyle(color: Colors.white)),
        content: Text(
          "You are now a ${levels[currentLevelIndex]['title']}!",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("LFG!"),
          ),
        ],
      ),
    );
  }

  // --- BUILD THE INDIVIDUAL PAGES ---
  
  // Index 0: Home Page
  Widget _buildHomePage() {
    return Center(
      child: Text(
        "Home - Your Progress",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  // Index 1: Paths Page (Harvested from your friend's Path.dart!)
  Widget _buildPathsPage() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 40),
              children: [
                // Generating some sample path nodes using friend's helper UI
                _buildPathNode(3, true),
                _buildConnector(),
                _buildPathNode(2, false),
                _buildConnector(),
                _buildPathNode(1, false),
                _buildConnector(),
                _buildPathNode(0, false),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _gainXP,
                    child: const Text("Gain 25 XP"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Index 2: Practice Page
  Widget _buildPracticePage() {
    return Center(
      child: Text(
        "Practice - Mic Access",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  // Index 3: Profile Page
  Widget _buildProfilePage() {
    return Center(
      child: Text(
        "Profile - Awards",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  // --- FRIEND'S PATH WIDGET BUILDERS ---
  Widget _buildHeader() {
    final currentLevel = levels[currentLevelIndex];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: const Color(0xFF1F1B2E),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "${currentLevel['icon']} ${currentLevel['title']}",
                style: GoogleFonts.playfairDisplay(
                  color: currentLevel['color'],
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: xp / 100,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(currentLevel['color']),
              ),
              const SizedBox(height: 5),
              Text(
                "XP: $xp / 100",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathNode(int levelIdx, bool isCompleted) {
    final level = levels[levelIdx];
    return Center(
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Selected: ${level['title']}")),
          );
        },
        child: CircleAvatar(
          radius: 35,
          backgroundColor: isCompleted ? level['color'] : Colors.grey[800],
          child: Text(
            level['icon'],
            style: const TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildConnector() {
    return Center(
      child: Container(
        width: 4,
        height: 40,
        color: Colors.grey[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically switch the body layout matching your navigation indices
    final List<Widget> pages = [
      _buildHomePage(),
      _buildPathsPage(),
      _buildPracticePage(),
      _buildProfilePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF100E1E), // Your beautiful dark theme background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search users...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : Text(
                "SPOTLIGHT",
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _searchResults.clear();
                } else {
                  _isSearching = true;
                  _loadUsers(); // Refresh users list when opening search
                }
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: _isSearching && _searchController.text.isNotEmpty
          ? _buildSearchResults()
          : pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF151325), // Your navigation bar color
        selectedItemColor: const Color(0xFF423682), // Your brand accent accent color
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Paths'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Practice'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}