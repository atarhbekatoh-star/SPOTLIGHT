import 'package:flutter/foundation.dart';

import '../models/mission_model.dart';
import '../models/user_mission_state.dart';
import '../models/seed_missions.dart';

/// Core game logic controller for the Mission Board system.
/// Implements behavioral psychology principles and gamification mechanics.
class MissionBoardController extends ChangeNotifier {
  // ============= STATE =============
  late List<MissionModel> _activeMissionBoard;
  late Map<String, MissionProgress> _missionProgress;
  late int _userCurrentMaxExposureLevel;
  int _dailyRerollsUsed = 0;
  static const int _maxRerollsPerDay = 1;

  // ============= INITIALIZATION =============
  MissionBoardController({int initialMaxExposureLevel = 1}) {
    _userCurrentMaxExposureLevel = initialMaxExposureLevel.clamp(1, 4);
    _activeMissionBoard = [];
    _missionProgress = {};
    _initializeDailyBoard();
  }

  // ============= GETTERS =============
  List<MissionModel> get activeMissionBoard => List.unmodifiable(_activeMissionBoard);
  int get userCurrentMaxExposureLevel => _userCurrentMaxExposureLevel;
  int get dailyRerollsRemaining => _maxRerollsPerDay - _dailyRerollsUsed;
  int get totalXpEarned => _missionProgress.values
      .fold(0, (sum, progress) => sum + progress.xpEarned);

  Map<String, MissionProgress> get allMissionProgress =>
      Map.unmodifiable(_missionProgress);

  /// Get progress for a specific mission
  MissionProgress? getMissionProgress(String missionId) =>
      _missionProgress[missionId];

  /// Get all resolved missions for today
  List<MissionProgress> get resolvedMissions =>
      _missionProgress.values
          .where((progress) => progress.state.isResolved)
          .toList();

  /// Get all available (unresolved) missions for today
  List<MissionProgress> get availableMissions =>
      _missionProgress.values
          .where((progress) => progress.state.isInteractive)
          .toList();

  // ============= CORE MECHANICS =============

  /// THE EXPOSURE FILTER: Generate 8-10 random missions each day
  /// ensuring they do not exceed the user's current maximum exposure level.
  void _initializeDailyBoard() {
    _activeMissionBoard =
        SeedMissions.getRandomMissionPool(_userCurrentMaxExposureLevel, count: 10);

    // Initialize progress tracking for each mission
    _missionProgress.clear();
    for (final mission in _activeMissionBoard) {
      final progressId = '${mission.id}_${DateTime.now().millisecondsSinceEpoch}';
      _missionProgress[mission.id] = MissionProgress(
        progressId: progressId,
        missionId: mission.id,
        state: UserMissionState.available,
        assignedAt: DateTime.now(),
      );
    }

    _dailyRerollsUsed = 0;
    notifyListeners();
  }

  /// THE PSYCHOLOGY ENGINE: Resolve a mission and award appropriate XP.
  /// 
  /// [missionId] - The ID of the mission to resolve
  /// [accomplishedFully] - true if fully completed, false if user backed out but tried
  ///
  /// Returns the XP earned (either successXp or courageXp)
  int resolveMission(String missionId, bool accomplishedFully) {
    final mission = SeedMissions.getMissionById(missionId);
    if (mission == null) {
      throw Exception('Mission not found: $missionId');
    }

    final currentProgress = _missionProgress[missionId];
    if (currentProgress == null) {
      throw Exception('Mission progress not found: $missionId');
    }

    final xpAwarded =
        accomplishedFully ? mission.successXp : mission.courageXp;

    // Update progress
    _missionProgress[missionId] = currentProgress.copyWith(
      state:
          accomplishedFully ? UserMissionState.completed : UserMissionState.attempted,
      completedAt: DateTime.now(),
      wasFullyCompleted: accomplishedFully,
      xpEarned: xpAwarded,
    );

    // Psychology principle: REWARD THE EFFORT
    // Even "backing out" earns XP because attempting = courage growth
    debugPrint(
        'Mission Resolved: ${mission.title} | Type: ${accomplishedFully ? "Full" : "Attempted"} | XP: $xpAwarded');

    notifyListeners();
    return xpAwarded;
  }

  /// ANXIETY REROLL: Swap one mission for another from the available pool.
  /// Limited to 1 reroll per day to prevent analysis paralysis.
  ///
  /// [missionIdToReplace] - The ID of the mission to swap out
  ///
  /// Returns true if reroll succeeded, false if reroll limit reached
  bool rerollMission(String missionIdToReplace) {
    if (_dailyRerollsUsed >= _maxRerollsPerDay) {
      debugPrint('Reroll limit reached for today');
      return false;
    }

    // Mark old mission as passed
    final oldProgress = _missionProgress[missionIdToReplace];
    if (oldProgress != null) {
      _missionProgress[missionIdToReplace] =
          oldProgress.copyWith(state: UserMissionState.passed);
    }

    // Remove from active board
    _activeMissionBoard
        .removeWhere((mission) => mission.id == missionIdToReplace);

    // Get a new random mission of same or lower difficulty
    final allAvailable =
        SeedMissions.getMissionsByLevel(_userCurrentMaxExposureLevel);
    final unused = allAvailable
        .where((mission) =>
            !_activeMissionBoard.any((m) => m.id == mission.id) &&
            mission.id != missionIdToReplace)
        .toList();

    if (unused.isEmpty) {
      // Fallback: shuffle entire pool and pick first available
      unused.addAll(SeedMissions.getMissionsByLevel(_userCurrentMaxExposureLevel));
    }

    unused.shuffle();
    final newMission = unused.first;

    // Add new mission to board
    _activeMissionBoard.add(newMission);
    final newProgressId =
        '${newMission.id}_reroll_${DateTime.now().millisecondsSinceEpoch}';
    _missionProgress[newMission.id] = MissionProgress(
      progressId: newProgressId,
      missionId: newMission.id,
      state: UserMissionState.available,
      assignedAt: DateTime.now(),
    );

    _dailyRerollsUsed++;
    debugPrint(
        'Mission Rerolled: ${newMission.title} (Rerolls used: $_dailyRerollsUsed/$_maxRerollsPerDay)');

    notifyListeners();
    return true;
  }

  /// Mark a mission as in-progress (user has started attempting it)
  void markMissionInProgress(String missionId) {
    final progress = _missionProgress[missionId];
    if (progress != null) {
      _missionProgress[missionId] =
          progress.copyWith(state: UserMissionState.inProgress);
      notifyListeners();
    }
  }

  /// Add optional user notes/reflection to a completed mission
  void addMissionNotes(String missionId, String notes) {
    final progress = _missionProgress[missionId];
    if (progress != null && progress.state.isResolved) {
      _missionProgress[missionId] = progress.copyWith(userNotes: notes);
      notifyListeners();
    }
  }

  // ============= PROGRESSION & DIFFICULTY SCALING =============

  /// Unlock the next exposure level based on user progression
  /// (This would be called by a user progression system)
  void unlockExposureLevel(int newLevel) {
    _userCurrentMaxExposureLevel = newLevel.clamp(1, 4);
    debugPrint('Exposure level unlocked: $_userCurrentMaxExposureLevel');
    notifyListeners();
  }

  /// Generate fresh daily board (called when user logs in next day)
  void generateNewDailyBoard() {
    _initializeDailyBoard();
    debugPrint('New daily board generated');
  }

  /// Get summary statistics for the day
  Map<String, dynamic> getDaySummary() {
    final completed = resolvedMissions
        .where((progress) => progress.state == UserMissionState.completed)
        .length;
    final attempted = resolvedMissions
        .where((progress) => progress.state == UserMissionState.attempted)
        .length;

    return {
      'totalXpEarned': totalXpEarned,
      'missionsCompleted': completed,
      'missionsAttempted': attempted,
      'totalResolved': resolvedMissions.length,
      'availableCount': availableMissions.length,
      'rerollsRemaining': dailyRerollsRemaining,
    };
  }

  @override
  void dispose() {
    super.dispose();
  }
}
