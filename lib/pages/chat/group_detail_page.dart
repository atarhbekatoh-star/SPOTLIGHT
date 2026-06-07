import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_models.dart';

class GroupDetailPage extends StatelessWidget {
  final Group group;
  final String myUserId;

  const GroupDetailPage({Key? key, required this.group, required this.myUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final messages = chatProvider.chats.where((c) => c.replyToMessageId == group.id).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        title: Text(group.name),
        backgroundColor: const Color(0xFF16161A),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF16161A),
                  title: const Text('Members', style: TextStyle(color: Colors.white)),
                  content: Text(group.members.join(', '), style: const TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              chatProvider.leaveGroup(group.id, myUserId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].text, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(messages[index].timestamp.toString(), style: const TextStyle(color: Colors.grey)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        chatProvider.sendMessage(ChatMessage(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          senderId: myUserId,
                          text: val,
                          timestamp: DateTime.now(),
                          isRead: true,
                          isDelivered: true,
                          type: 'text',
                          replyToMessageId: group.id,
                          reactions: {},
                        ));
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFF16161A),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
