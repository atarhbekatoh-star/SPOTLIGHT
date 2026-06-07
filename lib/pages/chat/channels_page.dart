import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/chat/channel_card.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_models.dart';
import 'channel_detail_page.dart';

class ChannelsPage extends StatelessWidget {
  const ChannelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final channels = chatProvider.channels;
    final followedChannels = channels.where((c) => chatProvider.followedChannels.contains(c.id)).toList();
    final discoverChannels = channels.where((c) => !chatProvider.followedChannels.contains(c.id)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (followedChannels.isNotEmpty) ...[
            _buildSectionTitle('Followed Channels'),
            ...followedChannels.map((c) => GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChannelDetailPage(channel: c)));
                  },
                  child: ChannelCard(
                    name: c.name,
                    description: c.description,
                    membersCount: c.followersCount,
                    isFollowed: true,
                  ),
                )),
            const SizedBox(height: 20),
          ],
          
          _buildSectionTitle('Discover Channels'),
          if (discoverChannels.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No channels available. Create one!", style: TextStyle(color: Colors.white54)),
            ),
          ...discoverChannels.map((c) => GestureDetector(
                onTap: () {
                  chatProvider.toggleFollowChannel(c.id);
                },
                child: ChannelCard(
                  name: c.name,
                  description: c.description,
                  membersCount: c.followersCount,
                  isFollowed: false,
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Simple create logic
          final newChannel = Channel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'New Channel \${chatProvider.channels.length + 1}',
            description: 'A newly created channel.',
            avatarUrl: '',
            followersCount: 1,
            isFollowing: true,
            bannerUrl: '',
          );
          chatProvider.createChannel(newChannel);
          chatProvider.toggleFollowChannel(newChannel.id);
        },
        backgroundColor: const Color(0xFFEFFF8A),
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Create Channel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFEFFF8A),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
