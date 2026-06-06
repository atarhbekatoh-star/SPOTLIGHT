import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final List<String> memberAvatars;
  final bool isMember;

  const GroupCard({
    Key? key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    required this.memberAvatars,
    this.isMember = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFBB86FC),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'G',
                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF16161A),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xFFEFFF8A),
                      child: Text(
                        '+${memberAvatars.length}',
                        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isMember)
                      Text(
                        time,
                        style: TextStyle(
                          color: unreadCount > 0 ? const Color(0xFFBB86FC) : Colors.grey,
                          fontSize: 12,
                          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                if (isMember)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            color: unreadCount > 0 ? Colors.white : Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBB86FC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBB86FC),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(80, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Join Group', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
