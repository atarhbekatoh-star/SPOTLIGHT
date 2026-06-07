import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database_helper.dart';

class CallScreen extends StatefulWidget {
  final String userName;
  final bool isVideoCall;

  const CallScreen({
    Key? key,
    required this.userName,
    this.isVideoCall = false,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;
  bool _isSpeaker = false;
  bool _isLoading = true;
  bool _isOnline = false;

  Timer? _callTimer;
  Timer? _ringTimer;
  int _durationSeconds = 0;
  String _callStatus = 'Calling...';

  @override
  void initState() {
    super.initState();
    _checkOnlineStatus();
  }

  Future<void> _checkOnlineStatus() async {
    try {
      final users = await DatabaseHelper.instance.getAllUsers();
      final otherUser = users.firstWhere((u) => u['username'] == widget.userName, orElse: () => {});
      bool isOnline = false;
      if (otherUser.isNotEmpty) {
        String today = DateTime.now().toIso8601String().split('T')[0];
        if (otherUser['lastLoginDate'] == today) {
          isOnline = true;
        }
      }
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
          _isLoading = false;
          _callStatus = isOnline ? 'Ringing...' : 'Calling...';
        });
      }
      
      // Simulate answer or missed
      if (isOnline) {
        _ringTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _callStatus = '00:00';
            });
            _startCallTimer();
          }
        });
      } else {
        _ringTimer = Timer(const Duration(seconds: 10), () {
          if (mounted) {
            setState(() {
              _callStatus = 'Missed';
            });
            _endCallAndSave('Missed', 0);
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _durationSeconds++;
          final minutes = (_durationSeconds ~/ 60).toString().padLeft(2, '0');
          final seconds = (_durationSeconds % 60).toString().padLeft(2, '0');
          _callStatus = '$minutes:$seconds';
        });
      }
    });
  }

  Future<void> _endCallAndSave(String status, int duration) async {
    final prefs = await SharedPreferences.getInstance();
    final callHistoryStr = prefs.getStringList('call_history') ?? [];
    
    final callRecord = {
      'caller': 'Me',
      'receiver': widget.userName,
      'status': status,
      'duration': duration,
      'date': DateTime.now().toIso8601String(),
      'isVideo': widget.isVideoCall,
    };
    
    callHistoryStr.insert(0, jsonEncode(callRecord));
    await prefs.setStringList('call_history', callHistoryStr);
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _ringTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isLoading ? '...' : _callStatus,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            CircleAvatar(
              radius: 80,
              backgroundColor: const Color(0xFFBB86FC),
              child: Text(
                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: 'Mute',
                    color: _isMuted ? Colors.white : Colors.grey,
                    onTap: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                    },
                  ),
                  _buildEndCallButton(),
                  _buildIconButton(
                    icon: _isSpeaker ? Icons.volume_up : Icons.volume_down,
                    label: 'Speaker',
                    color: _isSpeaker ? Colors.white : Colors.grey,
                    onTap: () {
                      setState(() {
                        _isSpeaker = !_isSpeaker;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16161A),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: () async {
        await _endCallAndSave(_durationSeconds > 0 ? 'Answered' : 'Missed', _durationSeconds);
        if (mounted) Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.call_end,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
