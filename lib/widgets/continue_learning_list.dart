import 'package:flutter/material.dart';

class ContinueLearningList extends StatelessWidget {
  const ContinueLearningList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> items = [
      {
        "title": "Start Conversations",
        "progress": 0.8,
        "color": Colors.blueAccent,
        "icon": Icons.chat_bubble_outline,
      },
      {
        "title": "Public Speaking",
        "progress": 0.4,
        "color": Colors.orangeAccent,
        "icon": Icons.mic_none,
      },
      {
        "title": "Active Listening",
        "progress": 0.1,
        "color": Colors.purpleAccent,
        "icon": Icons.hearing,
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item['icon'], color: item['color'], size: 24),
                ),
                Text(
                  item['title'],
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: item['progress'],
                    backgroundColor: theme.scaffoldBackgroundColor,
                    color: item['color'],
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
