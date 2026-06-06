import 'package:flutter/material.dart';
import '../../widgets/chat/call_card.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Ongoing Calls'),
          const CallCard(
            title: 'Design Sync',
            subtitle: 'Started 5 mins ago',
            status: 'Outgoing',
            isVideo: true,
          ),
          const SizedBox(height: 16),
          
          _buildSectionTitle('Upcoming Calls'),
          const CallCard(
            title: 'Marketing Standup',
            subtitle: 'Today, 3:00 PM',
            status: 'Incoming',
            isVideo: false,
          ),
          const CallCard(
            title: 'John Doe',
            subtitle: 'Tomorrow, 10:00 AM',
            status: 'Incoming',
            isVideo: true,
          ),
          const SizedBox(height: 16),
          
          _buildSectionTitle('Call History'),
          const CallCard(
            title: 'Jane Smith',
            subtitle: 'Yesterday, 4:30 PM',
            status: 'Missed',
            isVideo: false,
          ),
          const CallCard(
            title: 'Alex Johnson',
            subtitle: 'Yesterday, 1:15 PM',
            status: 'Outgoing',
            isVideo: true,
          ),
          const CallCard(
            title: 'Team Alpha',
            subtitle: 'Monday, 11:00 AM',
            status: 'Incoming',
            isVideo: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFBB86FC),
        child: const Icon(Icons.add_call, color: Colors.black),
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
