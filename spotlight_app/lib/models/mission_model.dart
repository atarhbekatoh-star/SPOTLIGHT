import 'package:flutter/foundation.dart';

/// Represents the static blueprint of a mission/quest.
/// This is immutable and defines the core properties of a mission.
@immutable
class MissionModel {
  /// Unique identifier for the mission
  final String id;

  /// Mission title (spy/RPG themed)
  final String title;

  /// Detailed mission briefing
  final String description;

  /// Difficulty level (1-4):
  /// 1: Digital/Observation (no social interaction)
  /// 2: Physical Presence (being around people)
  /// 3: Short Scripted Interaction (brief social contact)
  /// 4: Interactive Micro-Conversation (back-and-forth dialogue)
  final int levelOfExposure;

  /// Safe exit strategy for high-anxiety missions
  /// If null, no escape hatch is provided
  final String? escapeHatchInstruction;

  /// XP awarded for full mission completion
  final int successXp;

  /// XP awarded for attempting the mission (partial completion)
  final int courageXp;

  /// Mission category (e.g., "Reconnaissance", "Infiltration", "Social Engineering")
  final String category;

  /// Mission icon emoji for visual recognition
  final String emoji;

  /// Mission color theme (hex string)
  final String colorTheme;

  /// Estimated time to complete in minutes
  final int estimatedMinutes;

  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.levelOfExposure,
    this.escapeHatchInstruction,
    required this.successXp,
    required this.courageXp,
    required this.category,
    required this.emoji,
    required this.colorTheme,
    required this.estimatedMinutes,
  });

  /// Convert MissionModel to JSON map for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'levelOfExposure': levelOfExposure,
      'escapeHatchInstruction': escapeHatchInstruction,
      'successXp': successXp,
      'courageXp': courageXp,
      'category': category,
      'emoji': emoji,
      'colorTheme': colorTheme,
      'estimatedMinutes': estimatedMinutes,
    };
  }

  /// Create MissionModel from JSON map
  factory MissionModel.fromMap(Map<String, dynamic> map) {
    return MissionModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      levelOfExposure: map['levelOfExposure'] as int,
      escapeHatchInstruction: map['escapeHatchInstruction'] as String?,
      successXp: map['successXp'] as int,
      courageXp: map['courageXp'] as int,
      category: map['category'] as String,
      emoji: map['emoji'] as String? ?? '🎯',
      colorTheme: map['colorTheme'] as String? ?? '#FF6B6B',
      estimatedMinutes: map['estimatedMinutes'] as int? ?? 5,
    );
  }

  /// Create a copy of this mission with optional field replacements
  MissionModel copyWith({
    String? id,
    String? title,
    String? description,
    int? levelOfExposure,
    String? escapeHatchInstruction,
    int? successXp,
    int? courageXp,
    String? category,
    String? emoji,
    String? colorTheme,
    int? estimatedMinutes,
  }) {
    return MissionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      levelOfExposure: levelOfExposure ?? this.levelOfExposure,
      escapeHatchInstruction: escapeHatchInstruction ?? this.escapeHatchInstruction,
      successXp: successXp ?? this.successXp,
      courageXp: courageXp ?? this.courageXp,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      colorTheme: colorTheme ?? this.colorTheme,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissionModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
