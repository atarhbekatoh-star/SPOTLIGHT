import 'package:flutter/material.dart';

class MessageReactionBar extends StatelessWidget {
  final Function(String) onReactionSelected;

  const MessageReactionBar({
    Key? key,
    required this.onReactionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reactions = ['❤️', '👍', '😂', '🔥', '😮', '😢'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((emoji) {
          return GestureDetector(
            onTap: () => onReactionSelected(emoji),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
