import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/chat/call_card.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({Key? key}) : super(key: key);

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  List<Map<String, dynamic>> _callHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCallHistory();
  }

  Future<void> _loadCallHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final callHistoryStr = prefs.getStringList('call_history') ?? [];
    
    setState(() {
      _callHistory = callHistoryStr.map((str) => jsonDecode(str) as Map<String, dynamic>).toList();
      _isLoading = false;
    });
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final minutes = date.minute.toString().padLeft(2, '0');
      return '${date.month}/${date.day} at ${date.hour}:$minutes';
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatDuration(int seconds) {
    if (seconds == 0) return '';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return ' (${m}m ${s}s)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)))
        : _callHistory.isEmpty
          ? const Center(child: Text("No calls yet.", style: TextStyle(color: Colors.grey)))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle('Call History'),
                ..._callHistory.map((call) {
                  return CallCard(
                    title: call['receiver'] ?? 'Unknown',
                    subtitle: '${_formatDate(call['date'])}${_formatDuration(call['duration'] ?? 0)}',
                    status: call['status'] ?? 'Unknown',
                    isVideo: call['isVideo'] == true,
                  );
                }).toList(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFBB86FC),
        child: const Icon(Icons.add_call, color: Colors.black),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFBB86FC),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
