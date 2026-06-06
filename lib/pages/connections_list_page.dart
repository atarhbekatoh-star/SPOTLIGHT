import 'package:flutter/material.dart';
import '../database_helper.dart';

class ConnectionsListPage extends StatefulWidget {
  final String username;
  final int initialTabIndex; // 0 for Followers, 1 for Following

  const ConnectionsListPage({
    super.key,
    required this.username,
    this.initialTabIndex = 0,
  });

  @override
  State<ConnectionsListPage> createState() => _ConnectionsListPageState();
}

class _ConnectionsListPageState extends State<ConnectionsListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> _followers = [];
  List<String> _following = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    final db = DatabaseHelper.instance;
    final followers = await db.getFollowers(widget.username);
    final following = await db.getFollowing(widget.username);

    if (mounted) {
      setState(() {
        _followers = followers;
        _following = following;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF100E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.username, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFBB86FC),
          labelColor: const Color(0xFFBB86FC),
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: "Followers"),
            Tab(text: "Following"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_followers, "No followers yet."),
                _buildList(_following, "Not following anyone yet."),
              ],
            ),
    );
  }

  Widget _buildList(List<String> users, String emptyMessage) {
    if (users.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: const TextStyle(color: Colors.white54)),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final u = users[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF423682),
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(u, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          // You could add an onTap here to navigate to their profile, but basic list is enough for now.
        );
      },
    );
  }
}
