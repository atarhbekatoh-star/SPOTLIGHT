import 'package:flutter/material.dart';

enum MessageStatus { sent, delivered, read }

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final MessageStatus status;
  final String time;
  final String? replyToMessage;
  final List<String> reactions;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.time,
    this.status = MessageStatus.sent,
    this.replyToMessage,
    this.reactions = const [],
  }) : super(key: key);

  void _showLongPressMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16161A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.reply, color: Colors.white),
                title: const Text('Reply', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.forward, color: Colors.white),
                title: const Text('Forward', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.white),
                title: const Text('Copy', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showLongPressMenu(context),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFFBB86FC) : const Color(0xFF16161A),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (replyToMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    replyToMessage!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    _buildStatusIcon(),
                  ],
                ],
              ),
              if (reactions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D0F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    reactions.join(' '),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case MessageStatus.sent:
        iconData = Icons.check;
        iconColor = Colors.white70;
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all;
        iconColor = Colors.white70;
        break;
      case MessageStatus.read:
        iconData = Icons.done_all;
        iconColor = Colors.blue;
        break;
    }

    return Icon(iconData, size: 14, color: iconColor);
  }
}
