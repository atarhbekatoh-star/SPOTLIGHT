import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _isAccountPrivate = false;
  String _friendRequestPermission = 'Everyone';
  bool _showActivityStatus = true;
  bool _allowDataCollection = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAccountPrivate = prefs.getBool('privacy_isAccountPrivate') ?? false;
      _friendRequestPermission = prefs.getString('privacy_friendRequestPermission') ?? 'Everyone';
      _showActivityStatus = prefs.getBool('privacy_showActivityStatus') ?? true;
      _allowDataCollection = prefs.getBool('privacy_allowDataCollection') ?? true;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color purpleGlow = Color(0xFFBB86FC);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('Account Privacy'),
          _buildSwitchTile(
            title: 'Private Account',
            subtitle: 'Only approved followers can see your posts and activity.',
            value: _isAccountPrivate,
            onChanged: (val) {
              setState(() => _isAccountPrivate = val);
              _saveBool('privacy_isAccountPrivate', val);
            },
            theme: theme,
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Interactions'),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: const Text('Friend Requests'),
              subtitle: Text('Currently: $_friendRequestPermission'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showFriendRequestDialog(theme),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.block, color: Colors.redAccent),
              title: const Text('Blocked Accounts'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No blocked accounts.')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Activity & Data'),
          _buildSwitchTile(
            title: 'Activity Status',
            subtitle: 'Let others see when you are online.',
            value: _showActivityStatus,
            onChanged: (val) {
              setState(() => _showActivityStatus = val);
              _saveBool('privacy_showActivityStatus', val);
            },
            theme: theme,
          ),
          const SizedBox(height: 10),
          _buildSwitchTile(
            title: 'Data Personalization',
            subtitle: 'Allow data collection for tailored experiences and AI insights.',
            value: _allowDataCollection,
            onChanged: (val) {
              setState(() => _allowDataCollection = val);
              _saveBool('privacy_allowDataCollection', val);
            },
            theme: theme,
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Security'),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.lock_outline, color: purpleGlow),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password change link sent to email.')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFFBB86FC),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 12)),
        value: value,
        activeColor: const Color(0xFFBB86FC),
        onChanged: onChanged,
      ),
    );
  }

  void _showFriendRequestDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: const Text('Friend Requests'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Everyone', 'Friends of Friends', 'Nobody'].map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _friendRequestPermission,
                activeColor: const Color(0xFFBB86FC),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _friendRequestPermission = val;
                    });
                    _saveString('privacy_friendRequestPermission', val);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
