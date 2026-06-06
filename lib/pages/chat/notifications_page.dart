import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database_helper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  String? _currentUsername;
  
  List<Map<String, dynamic>> _friendRequests = [];
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    
    if (userJson != null) {
      final Map<String, dynamic> user = jsonDecode(userJson);
      _currentUsername = user['username'];
      
      if (_currentUsername != null) {
        final db = DatabaseHelper.instance;
        
        final reqs = await db.getPendingFriendRequests(_currentUsername!);
        final notifs = await db.getNotifications(_currentUsername!);
        
        final allUsers = await db.getAllUsers(_currentUsername!);
        final List<Map<String, dynamic>> validSuggestions = [];
        
        for (var u in allUsers) {
          final targetUser = u['username'];
          final status = await db.checkConnectionStatus(_currentUsername!, targetUser);
          if (!status['isFollowing']! && !status['isFriend']! && !status['isPendingRequest']!) {
            validSuggestions.add(u);
          }
        }
        
        validSuggestions.shuffle();
        
        setState(() {
          _friendRequests = reqs;
          _notifications = notifs;
          _suggestions = validSuggestions.take(10).toList();
        });
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _acceptRequest(String sender) async {
    if (_currentUsername == null) return;
    await DatabaseHelper.instance.acceptFriendRequest(sender, _currentUsername!);
    _loadData();
  }

  Future<void> _declineRequest(String sender) async {
    if (_currentUsername == null) return;
    await DatabaseHelper.instance.declineFriendRequest(sender, _currentUsername!);
    _loadData();
  }
  
  Future<void> _sendFriendRequest(String receiver) async {
    if (_currentUsername == null) return;
    await DatabaseHelper.instance.sendFriendRequest(_currentUsername!, receiver);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16161A),
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)))
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_friendRequests.isNotEmpty) ...[
                const Text(
                  "Friend Requests",
                  style: TextStyle(
                    color: Color(0xFFBB86FC),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ..._friendRequests.map((req) => _buildFriendRequest(req['sender'])),
                const SizedBox(height: 20),
              ],
              
              if (_suggestions.isNotEmpty) ...[
                const Text(
                  "Friend Suggestions",
                  style: TextStyle(
                    color: Color(0xFFBB86FC),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final u = _suggestions[index];
                      return _buildSuggestionCard(u['username']);
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              const Text(
                "Notifications",
                style: TextStyle(
                  color: Color(0xFFBB86FC),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (_notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No new notifications.", style: TextStyle(color: Colors.white54)),
                )
              else
                ..._notifications.map((n) {
                  final title = (n['title'] ?? '').toString().toLowerCase();
                  IconData icon = Icons.notifications;
                  if (title.contains('message')) {
                    icon = Icons.message;
                  } else if (title.contains('follow')) {
                    icon = Icons.person_add;
                  } else if (title.contains('friend')) {
                    icon = Icons.people;
                  }
                  
                  return _buildNotification(
                    icon: icon,
                    title: n['title'] ?? '',
                    subtitle: n['body'] ?? '',
                    time: "recently",
                  );
                }),
            ],
          ),
    );
  }

  Widget _buildFriendRequest(String senderUsername) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFBB86FC),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(senderUsername, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('@$senderUsername', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: Color(0xFFEFFF8A)),
            onPressed: () => _acceptRequest(senderUsername),
            tooltip: "Accept",
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
            onPressed: () => _declineRequest(senderUsername),
            tooltip: "Reject",
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String username) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFBB86FC).withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF2E2E38),
            child: Icon(Icons.person, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            username,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SizedBox(
            height: 28,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB86FC),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _sendFriendRequest(username),
              child: const Text("Add", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotification({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFBB86FC).withAlpha(50),
            child: Icon(icon, color: const Color(0xFFBB86FC)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}
