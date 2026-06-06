import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../pages/other_user_profile_page.dart';

class GlobalSearchBar extends StatefulWidget {
  final String currentUsername;
  const GlobalSearchBar({super.key, required this.currentUsername});

  @override
  State<GlobalSearchBar> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends State<GlobalSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await DatabaseHelper.instance.getAllUsers(widget.currentUsername);
    setState(() {
      _allUsers = users;
    });
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final lowerQuery = query.toLowerCase();
    setState(() {
      _searchResults = _allUsers.where((user) {
        final username = (user['username'] ?? '').toString().toLowerCase();
        final fullName = (user['fullName'] ?? '').toString().toLowerCase();
        return username.contains(lowerQuery) || fullName.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onTap: () => setState(() => _isSearching = true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search friends...',
            hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFFBB86FC)),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                      setState(() => _isSearching = false);
                      FocusScope.of(context).unfocus();
                    },
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFF16161A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (_isSearching && _searchController.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF16161A),
              borderRadius: BorderRadius.circular(15),
            ),
            constraints: const BoxConstraints(maxHeight: 250),
            child: _searchResults.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('No users found', style: TextStyle(color: Colors.white54)),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF423682),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          user['username'] ?? 'Unknown',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          user['fullName'] ?? '',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        onTap: () {
                          _searchController.clear();
                          _onSearchChanged('');
                          setState(() => _isSearching = false);
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtherUserProfilePage(
                                user: user,
                                currentUsername: widget.currentUsername,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
      ],
    );
  }
}
