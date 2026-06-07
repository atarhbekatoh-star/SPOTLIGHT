import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_models.dart';

class ChannelDetailPage extends StatelessWidget {
  final Channel channel;

  const ChannelDetailPage({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final messages = chatProvider.chats.where((c) => c.replyToMessageId == channel.id).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        title: Text(channel.name),
        backgroundColor: const Color(0xFF16161A),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              chatProvider.editChannel(channel.id, channel.name + " (Edited)", channel.description);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              chatProvider.deleteChannel(channel.id);
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
                          senderId: 'me',
                          text: val,
                          timestamp: DateTime.now(),
                          isRead: true,
                          isDelivered: true,
                          type: 'text',
                          replyToMessageId: channel.id,
                          reactions: {},
                        ));
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Post an update...",
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
