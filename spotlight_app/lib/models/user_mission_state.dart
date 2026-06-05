import 'package:flutter/foundation.dart';

/// Enum representing the current state of a user's mission engagement
enum UserMissionState {
  /// Mission has been generated but not yet started
  available('Available', '🎯'),

  /// User is currently attempting the mission
  inProgress('In Progress', '⚡'),

  /// User successfully completed the mission
  completed('Completed', '✅'),

  /// User attempted but used escape hatch (partial completion)
  attempted('Attempted', '🛡️'),

  /// Mission was passed over (not selected for the day)
  passed('Passed', '⏭️'),

  /// Mission is locked due to insufficient level progression
  locked('Locked', '🔒');

  final String displayName;
  final String emoji;

  const UserMissionState(this.displayName, this.emoji);

  /// Check if this state allows user interaction
  bool get isInteractive => this == UserMissionState.available || this == UserMissionState.inProgress;

  /// Check if this state represents a resolved mission
  bool get isResolved => this == UserMissionState.completed || this == UserMissionState.attempted;
}

/// Tracks the runtime state of a mission instance for a specific user/day
@immutable
class MissionProgress {
  /// Unique identifier for this progress instance
  final String progressId;

  /// Reference to the mission blueprint
  final String missionId;

  /// Current state of the mission
  final UserMissionState state;

  /// Timestamp when mission was assigned to the user
  final DateTime assignedAt;

  /// Timestamp when mission was completed/attempted (null if not yet resolved)
  final DateTime? completedAt;

  /// Whether the mission was fully completed (true) or just attempted (false)
  final bool? wasFullyCompleted;

  /// XP earned from this mission (0 if not yet completed)
  final int xpEarned;

  /// Optional user notes about the mission attempt
  final String? userNotes;

  const MissionProgress({
    required this.progressId,
    required this.missionId,
    required this.state,
    required this.assignedAt,
    this.completedAt,
    this.wasFullyCompleted,
    this.xpEarned = 0,
    this.userNotes,
  });

  /// Convert MissionProgress to JSON map
  Map<String, dynamic> toMap() {
    return {
      'progressId': progressId,
      'missionId': missionId,
      'state': state.name,
      'assignedAt': assignedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'wasFullyCompleted': wasFullyCompleted,
      'xpEarned': xpEarned,
      'userNotes': userNotes,
    };
  }

  /// Create MissionProgress from JSON map
  factory MissionProgress.fromMap(Map<String, dynamic> map) {
    return MissionProgress(
      progressId: map['progressId'] as String,
      missionId: map['missionId'] as String,
      state: UserMissionState.values.byName(map['state'] as String),
      assignedAt: DateTime.parse(map['assignedAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      wasFullyCompleted: map['wasFullyCompleted'] as bool?,
      xpEarned: map['xpEarned'] as int? ?? 0,
      userNotes: map['userNotes'] as String?,
    );
  }

  /// Create a copy with optional field replacements
  MissionProgress copyWith({
    String? progressId,
    String? missionId,
    UserMissionState? state,
    DateTime? assignedAt,
    DateTime? completedAt,
    bool? wasFullyCompleted,
    int? xpEarned,
    String? userNotes,
  }) {
    return MissionProgress(
      progressId: progressId ?? this.progressId,
      missionId: missionId ?? this.missionId,
      state: state ?? this.state,
      assignedAt: assignedAt ?? this.assignedAt,
      completedAt: completedAt ?? this.completedAt,
      wasFullyCompleted: wasFullyCompleted ?? this.wasFullyCompleted,
      xpEarned: xpEarned ?? this.xpEarned,
      userNotes: userNotes ?? this.userNotes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissionProgress &&
          runtimeType == other.runtimeType &&
          progressId == other.progressId;

  @override
  int get hashCode => progressId.hashCode;
}
