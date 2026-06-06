import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../chat_page.dart';
import 'chat/active_chat_page.dart';
import '../providers/app_provider.dart';
import 'connections_list_page.dart';

class OtherUserProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;
  final String currentUsername;

  const OtherUserProfilePage({super.key, required this.user, required this.currentUsername});

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  bool _isFollowing = false;
  bool _isFriend = false;
  late String _username;

  @override
  void initState() {
    super.initState();
    _username = widget.user['username'] ?? 'Unknown User';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadConnectionStatus(widget.currentUsername, _username);
    });
  }

  Future<void> _toggleFollow() async {
    final appProvider = context.read<AppProvider>();
    final status = appProvider.getConnectionStatus(_username) ?? {'isFollowing': false};
    final bool isCurrentlyFollowing = status['isFollowing'] == true;

    if (isCurrentlyFollowing) {
      await appProvider.unfollowUser(widget.currentUsername, _username);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unfollowed $_username')));
    } else {
      await appProvider.followUser(widget.currentUsername, _username);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are now following $_username')));
    }
  }

  Future<void> _toggleFriend() async {
    final appProvider = context.read<AppProvider>();
    final status = appProvider.getConnectionStatus(_username) ?? {'isFriend': false, 'isPendingRequest': false};
    
    if (status['isFriend'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are already friends!')));
    } else if (status['isPendingRequest'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Friend request is pending.')));
    } else {
      await appProvider.sendFriendRequest(widget.currentUsername, _username);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Friend request sent to $_username')));
    }
  }

  void _sendMessage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveChatPage(userName: _username),
      ),
    );
  }

  void _showCallPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16161A),
        title: const Text('Start a Call', style: TextStyle(color: Colors.white)),
        content: const Text('Do you want a Voice Call or Video Call?', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Starting Voice Call with $_username...')));
            },
            child: const Text('Voice Call', style: TextStyle(color: Color(0xFFBB86FC))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Starting Video Call with $_username...')));
            },
            child: const Text('Video Call', style: TextStyle(color: Color(0xFFBB86FC))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final status = appProvider.getConnectionStatus(_username) ?? {};
    bool isFollowing = status['isFollowing'] == true;
    bool isFriend = status['isFriend'] == true;
    bool isPending = status['isPendingRequest'] == true;

    return Scaffold(
      backgroundColor: const Color(0xFF100E1E), // Match dark theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _username,
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF423682), width: 3),
                  color: Colors.grey[800],
                ),
                child: const Icon(Icons.person, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            // Username
            Text(
              _username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (widget.user['fullName'] != null)
              Text(
                widget.user['fullName'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),
            const SizedBox(height: 20),
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Posts', '0', null),
                _buildStatColumn('Followers', isFollowing ? '1' : '0', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectionsListPage(
                        username: _username,
                        initialTabIndex: 0,
                      ),
                    ),
                  );
                }),
                _buildStatColumn('Following', '0', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectionsListPage(
                        username: _username,
                        initialTabIndex: 1,
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 30),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFollowing ? Colors.grey[800] : const Color(0xFF423682),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _toggleFollow,
                      icon: Icon(_isFollowing ? Icons.check : Icons.person_add, color: Colors.white, size: 18),
                      label: Text(
                        _isFollowing ? "Following" : "Follow",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFriend ? Colors.green[700] : Colors.grey[800],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _toggleFriend,
                      icon: Icon(_isFriend ? Icons.people : Icons.person_add_alt_1, color: Colors.white, size: 18),
                      label: Text(
                        _isFriend ? "Friends" : "Add Friend",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFF423682)),
                        ),
                      ),
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.message, color: Colors.white, size: 18),
                      label: const Text(
                        "Message",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFFBB86FC)),
                        ),
                      ),
                      onPressed: _showCallPrompt,
                      icon: const Icon(Icons.call, color: Colors.white, size: 18),
                      label: const Text(
                        "Call",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Stats Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Posts', '0', null),
                _buildStatColumn('Followers', isFollowing ? '1' : '0', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectionsListPage(
                        username: _username,
                        initialTabIndex: 0,
                      ),
                    ),
                  );
                }),
                _buildStatColumn('Following', '0', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectionsListPage(
                        username: _username,
                        initialTabIndex: 1,
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 32),
            // Placeholder for posts or gallery
            Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xFF151325),
              child: const Center(
                child: Text(
                  "No Recent Activity",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
