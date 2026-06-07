import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _masterPushEnabled = true;
  bool _friendRequests = true;
  bool _messages = true;
  bool _channels = true;
  bool _groups = true;
  bool _calls = true;
  bool _emails = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _masterPushEnabled = prefs.getBool('notif_masterPush') ?? true;
      _friendRequests = prefs.getBool('notif_friendRequests') ?? true;
      _messages = prefs.getBool('notif_messages') ?? true;
      _channels = prefs.getBool('notif_channels') ?? true;
      _groups = prefs.getBool('notif_groups') ?? true;
      _calls = prefs.getBool('notif_calls') ?? true;
      _emails = prefs.getBool('notif_emails') ?? false;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('Push Notifications'),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFBB86FC).withAlpha(50)),
            ),
            child: SwitchListTile(
              title: const Text('Allow Push Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Master toggle for all push notifications'),
              value: _masterPushEnabled,
              activeColor: const Color(0xFFBB86FC),
              onChanged: (val) {
                setState(() => _masterPushEnabled = val);
                _saveBool('notif_masterPush', val);
              },
            ),
          ),
          const SizedBox(height: 20),
          Opacity(
            opacity: _masterPushEnabled ? 1.0 : 0.5,
            child: AbsorbPointer(
              absorbing: !_masterPushEnabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Social & Chat'),
                  _buildSwitchTile(
                    title: 'Friend Requests',
                    value: _friendRequests,
                    onChanged: (val) {
                      setState(() => _friendRequests = val);
                      _saveBool('notif_friendRequests', val);
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _buildSwitchTile(
                    title: 'Direct Messages',
                    value: _messages,
                    onChanged: (val) {
                      setState(() => _messages = val);
                      _saveBool('notif_messages', val);
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _buildSwitchTile(
                    title: 'Group Chats',
                    value: _groups,
                    onChanged: (val) {
                      setState(() => _groups = val);
                      _saveBool('notif_groups', val);
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _buildSwitchTile(
                    title: 'Channels',
                    value: _channels,
                    onChanged: (val) {
                      setState(() => _channels = val);
                      _saveBool('notif_channels', val);
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _buildSwitchTile(
                    title: 'Voice & Video Calls',
                    value: _calls,
                    onChanged: (val) {
                      setState(() => _calls = val);
                      _saveBool('notif_calls', val);
                    },
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('Email Notifications'),
          _buildSwitchTile(
            title: 'Weekly Digest & Updates',
            value: _emails,
            onChanged: (val) {
              setState(() => _emails = val);
              _saveBool('notif_emails', val);
            },
            theme: theme,
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
        value: value,
        activeColor: const Color(0xFFBB86FC),
        onChanged: onChanged,
      ),
    );
  }
}
