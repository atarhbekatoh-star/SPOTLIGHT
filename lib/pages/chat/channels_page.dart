import 'package:flutter/material.dart';
import '../../widgets/chat/channel_card.dart';

class ChannelsPage extends StatelessWidget {
  const ChannelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Followed Channels'),
          const ChannelCard(
            name: 'Flutter Devs',
            description: 'All about Flutter framework, Dart, and cross-platform app development. Share your projects and ask questions!',
            membersCount: 12500,
            isFollowed: true,
          ),
          const ChannelCard(
            name: 'UI/UX Inspiration',
            description: 'Daily doses of beautiful user interfaces and user experience design discussions.',
            membersCount: 8400,
            isFollowed: true,
          ),
          const SizedBox(height: 20),
          
          _buildSectionTitle('Discover Channels'),
          const ChannelCard(
            name: 'Tech News Daily',
            description: 'Stay updated with the latest happenings in the tech world. Hardware, software, and AI.',
            membersCount: 45000,
            isFollowed: false,
          ),
          const ChannelCard(
            name: 'Mobile Gamers',
            description: 'Find players, discuss strategies, and share your best moments in mobile gaming.',
            membersCount: 3200,
            isFollowed: false,
          ),
          const ChannelCard(
            name: 'Startup Founders',
            description: 'Network with other founders, share insights, and get advice on building your company.',
            membersCount: 5600,
            isFollowed: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFFEFFF8A),
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Create Channel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFEFFF8A),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
