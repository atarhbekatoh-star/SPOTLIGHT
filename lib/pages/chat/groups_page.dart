import 'package:flutter/material.dart';
import '../../widgets/chat/group_card.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('My Groups'),
          const GroupCard(
            name: 'Project Alpha Team',
            lastMessage: 'Alice: I just pushed the latest changes.',
            time: '10:42 AM',
            unreadCount: 3,
            memberAvatars: ['a', 'b', 'c', 'd'],
            isMember: true,
          ),
          const GroupCard(
            name: 'Weekend Getaway',
            lastMessage: 'Bob: Are we still on for Saturday?',
            time: 'Yesterday',
            unreadCount: 0,
            memberAvatars: ['x', 'y', 'z'],
            isMember: true,
          ),
          const SizedBox(height: 20),
          
          _buildSectionTitle('Discover Groups'),
          const GroupCard(
            name: 'Local Photographers',
            lastMessage: 'Share your latest snaps!',
            time: '',
            memberAvatars: ['1', '2', '3', '4', '5'],
            isMember: false,
          ),
          const GroupCard(
            name: 'Book Club - SciFi',
            lastMessage: 'Discussing Dune this month.',
            time: '',
            memberAvatars: ['a', 'b'],
            isMember: false,
          ),
          const GroupCard(
            name: 'Fitness Enthusiasts',
            lastMessage: 'Workout plans and tips.',
            time: '',
            memberAvatars: ['a', 'b', 'c'],
            isMember: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFBB86FC),
        child: const Icon(Icons.group_add, color: Colors.black),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFBB86FC),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
