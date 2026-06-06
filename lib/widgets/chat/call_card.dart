import 'package:flutter/material.dart';

class CallCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final bool isVideo;
  final String avatarUrl;

  const CallCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.status,
    this.isVideo = false,
    this.avatarUrl = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBB86FC).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF0D0D0F),
            child: Text(
              title.isNotEmpty ? title[0].toUpperCase() : '?',
              style: const TextStyle(color: Color(0xFFEFFF8A), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      status == 'Missed' 
                          ? Icons.call_missed 
                          : status == 'Incoming' ? Icons.call_received : Icons.call_made,
                      size: 14,
                      color: status == 'Missed' ? Colors.redAccent : const Color(0xFFBB86FC),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isVideo ? Icons.videocam : Icons.call,
              color: const Color(0xFFEFFF8A),
            ),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF0D0D0F),
            ),
          ),
        ],
      ),
    );
  }
}
