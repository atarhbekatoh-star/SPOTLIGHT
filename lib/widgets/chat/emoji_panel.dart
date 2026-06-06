import 'package:flutter/material.dart';
import 'gif_panel.dart';
import 'sticker_panel.dart';

class EmojiPanel extends StatelessWidget {
  const EmojiPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        height: 250,
        color: const Color(0xFF16161A),
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Color(0xFFBB86FC),
              labelColor: Color(0xFFBB86FC),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Emojis'),
                Tab(text: 'GIFs'),
                Tab(text: 'Stickers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildMockEmojiGrid(),
                  const GifPanel(),
                  const StickerPanel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockEmojiGrid() {
    final emojis = ['😀', '😂', '😍', '🔥', '👍', '🙏', '🎉', '❤️', '😢', '😮', '😎', '🤔'];
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            emojis[index],
            style: const TextStyle(fontSize: 24),
          ),
        );
      },
    );
  }
}
