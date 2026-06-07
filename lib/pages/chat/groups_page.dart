import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/chat/group_card.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_models.dart';
import 'group_detail_page.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final groups = chatProvider.groups;
    // For simulation, let's say "myUserId" is current user.
    final String myUserId = 'me'; 
    final myGroups = groups.where((g) => g.members.contains(myUserId)).toList();
    final discoverGroups = groups.where((g) => !g.members.contains(myUserId)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (myGroups.isNotEmpty) ...[
            _buildSectionTitle('My Groups'),
            ...myGroups.map((g) => GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => GroupDetailPage(group: g, myUserId: myUserId)));
                  },
                  child: GroupCard(
                    name: g.name,
                    lastMessage: 'Tap to view messages',
                    time: '',
                    unreadCount: 0,
                    memberAvatars: g.members,
                    isMember: true,
                  ),
                )),
            const SizedBox(height: 20),
          ],
          
          _buildSectionTitle('Discover Groups'),
          if (discoverGroups.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No groups available. Create one!", style: TextStyle(color: Colors.white54)),
            ),
          ...discoverGroups.map((g) => GestureDetector(
                onTap: () {
                  chatProvider.joinGroup(g.id, myUserId);
                },
                child: GroupCard(
                  name: g.name,
                  lastMessage: g.description,
                  time: '',
                  memberAvatars: g.members,
                  isMember: false,
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newGroup = Group(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'New Group \${chatProvider.groups.length + 1}',
            description: 'A brand new group.',
            avatarUrl: '',
            members: [myUserId],
            admins: [myUserId],
          );
          chatProvider.createGroup(newGroup);
        },
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
