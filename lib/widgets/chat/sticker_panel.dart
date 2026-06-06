import 'package:flutter/material.dart';

class StickerPanel extends StatelessWidget {
  const StickerPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF16161A),
      child: const Center(
        child: Text(
          'Sticker Panel Mock',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
