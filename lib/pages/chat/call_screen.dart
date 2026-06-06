import 'dart:async';
import 'package:flutter/material.dart';

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
  int _secondsElapsed = 0;
  Timer? _timer;
  bool _isMuted = false;
  bool _isSpeaker = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
              _formatDuration(_secondsElapsed),
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
      onTap: () => Navigator.pop(context),
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
