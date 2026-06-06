import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16161A),
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Friend Requests",
            style: TextStyle(
              color: Color(0xFFBB86FC),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildFriendRequest("John Smith", "@johnsmith"),
          _buildFriendRequest("Emily Chen", "@emilyc"),
          const SizedBox(height: 20),
          const Text(
            "Other Notifications",
            style: TextStyle(
              color: Color(0xFFBB86FC),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildNotification(
            icon: Icons.campaign,
            title: "Channel Follow",
            subtitle: "Sarah started following your channel.",
            time: "2h ago",
          ),
          _buildNotification(
            icon: Icons.group_add,
            title: "Group Invite",
            subtitle: "You've been invited to 'Flutter Devs'.",
            time: "5h ago",
          ),
          _buildNotification(
            icon: Icons.star,
            title: "New Badge Earned!",
            subtitle: "You unlocked the 'Social Butterfly' badge.",
            time: "1d ago",
          ),
        ],
      ),
    );
  }

  Widget _buildFriendRequest(String name, String username) {
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
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(username, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: Color(0xFFEFFF8A)),
            onPressed: () {},
            tooltip: "Accept",
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
            onPressed: () {},
            tooltip: "Reject",
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
