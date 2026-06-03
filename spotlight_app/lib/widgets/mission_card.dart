import 'package:flutter/material.dart';

import '../models/mission_model.dart';
import '../models/user_mission_state.dart';
import '../controllers/mission_board_controller.dart';

/// High-performance, reusable mission card widget.
/// Displays a mission with color-coded difficulty, escape hatch, and action buttons.
/// Uses purple and black color scheme for dark, professional look.
class MissionCard extends StatefulWidget {
  /// The mission blueprint to display
  final MissionModel mission;

  /// Current state of this mission's progress
  final MissionProgress missionProgress;

  /// The game controller for handling mission resolution
  final MissionBoardController controller;

  /// Callback when mission is marked as fully completed
  final VoidCallback? onCompleted;

  /// Callback when mission is marked as attempted (backed out)
  final VoidCallback? onAttempted;

  /// Callback for reroll action
  final VoidCallback? onReroll;

  /// Whether to allow interaction with this card
  final bool isInteractive;

  const MissionCard({
    super.key,
    required this.mission,
    required this.missionProgress,
    required this.controller,
    this.onCompleted,
    this.onAttempted,
    this.onReroll,
    this.isInteractive = true,
  });

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isResolving = false;

  // Color constants
  static const Color primaryPurple = Color(0xFF7B3FF2);
  static const Color accentPurple = Color(0xFF9D5FFF);
  static const Color darkPurpleBlack = Color(0xFF1a1a2e);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get color based on exposure level (purple variations)
  Color _getExposureColor() {
    switch (widget.mission.levelOfExposure) {
      case 1:
        return const Color(0xFF9D5FFF); // Light purple
      case 2:
        return const Color(0xFFB080FF); // Medium purple
      case 3:
        return const Color(0xFFC9A0FF); // Lighter purple
      case 4:
        return const Color(0xFFE0C3FF); // Pale purple
      default:
        return primaryPurple;
    }
  }

  /// Get difficulty label
  String _getDifficultyLabel() {
    switch (widget.mission.levelOfExposure) {
      case 1:
        return 'Level 1: Recon';
      case 2:
        return 'Level 2: Infiltration';
      case 3:
        return 'Level 3: Verbal';
      case 4:
        return 'Level 4: Interaction';
      default:
        return 'Unknown';
    }
  }

  /// Resolve mission and trigger callback
  void _resolveMission(bool accomplishedFully) {
    if (!widget.isInteractive || _isResolving) return;

    setState(() => _isResolving = true);
    _animationController.forward().then((_) {
      widget.controller.resolveMission(widget.mission.id, accomplishedFully);

      if (accomplishedFully) {
        widget.onCompleted?.call();
      } else {
        widget.onAttempted?.call();
      }

      // Reset animation for next use
      _animationController.reverse();
      if (mounted) setState(() => _isResolving = false);
    });
  }

  /// Reroll this mission
  void _rerollMission() {
    if (!widget.isInteractive) return;

    final canReroll = widget.controller.dailyRerollsRemaining > 0;
    if (!canReroll) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No rerolls remaining today. Try again tomorrow! 🎲'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    widget.controller.rerollMission(widget.mission.id);
    widget.onReroll?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isResolved = widget.missionProgress.state != UserMissionState.available &&
        widget.missionProgress.state != UserMissionState.inProgress;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getExposureColor(),
              _getExposureColor().withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: darkPurpleBlack,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== HEADER ==========
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission emoji
                  Text(
                    widget.mission.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),

                  // Title and difficulty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mission.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDifficultyLabel(),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getExposureColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ========== DESCRIPTION ==========
              Text(
                widget.mission.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // ========== ESCAPE HATCH (L3-L4 only) ==========
              if (widget.mission.levelOfExposure >= 3 &&
                  widget.mission.escapeHatchInstruction != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF78664E).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFD4A574).withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🚪 Escape Hatch',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4A574),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.mission.escapeHatchInstruction!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // ========== XP DISPLAY ==========
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryPurple.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '✨ Full Clear',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.mission.successXp} XP',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: accentPurple,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: primaryPurple.withValues(alpha: 0.3),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '💪 Attempt',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.mission.courageXp} XP',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ========== ACTION BUTTONS ==========
              if (isResolved)
                // RESOLVED STATE: Show completion status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _getExposureColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.missionProgress.state.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.missionProgress.state.displayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getExposureColor(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (widget.missionProgress.wasFullyCompleted == true)
                        Text(
                          '(${widget.mission.successXp} XP)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      if (widget.missionProgress.wasFullyCompleted == false)
                        Text(
                          '(${widget.mission.courageXp} XP)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                    ],
                  ),
                )
              else
                // ACTIVE STATE: Show action buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cleared button
                    ElevatedButton.icon(
                      onPressed: widget.isInteractive
                          ? () => _resolveMission(true)
                          : null,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Cleared'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentPurple.withValues(alpha: 0.8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tried button
                    OutlinedButton.icon(
                      onPressed: widget.isInteractive
                          ? () => _resolveMission(false)
                          : null,
                      icon: const Icon(Icons.thumb_up_outlined),
                      label: const Text('Tried'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryPurple,
                        side: BorderSide(
                          color: primaryPurple.withValues(alpha: 0.6),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Reroll button (if available)
                    if (widget.controller.dailyRerollsRemaining > 0) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed:
                            widget.isInteractive ? _rerollMission : null,
                        icon: const Icon(Icons.casino_outlined),
                        label: Text(
                          'Reroll (${widget.controller.dailyRerollsRemaining})',
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white60,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
