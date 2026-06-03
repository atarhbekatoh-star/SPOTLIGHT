# Spotlight Mission Board Architecture

## Overview
A production-ready Flutter/Dart architecture for a social anxiety gamification app that frames real-world social challenges as RPG missions.

---

## 1. PROJECT STRUCTURE

```
lib/
├── models/
│   ├── mission_model.dart           # Immutable blueprint for missions
│   ├── user_mission_state.dart      # State tracking & progress models
│   └── seed_missions.dart           # 16 curated missions across all levels
│
├── controllers/
│   └── mission_board_controller.dart # Core game logic & state management
│
├── widgets/
│   └── mission_card.dart            # Reusable mission card component
│
├── pages/
│   └── practice_page.dart           # Main Mission Board UI
│
├── main.dart                        # App entry point
├── welcome_page.dart
├── login_page.dart
└── register_page.dart
```

---

## 2. CORE COMPONENTS

### 2.1 DATA MODELS

#### `MissionModel` (Immutable Blueprint)
Represents the static definition of a mission:
```dart
MissionModel(
  id: 'l3_m001',
  title: 'Barista Negotiation',
  description: '...',
  levelOfExposure: 3,           // 1-4 difficulty scale
  escapeHatchInstruction: '...',  // Safe exit strategy
  successXp: 100,               // Full completion reward
  courageXp: 65,                // Partial/attempted reward
  category: 'Social Engineering',
  emoji: '☕',
  colorTheme: '#FF9F45',
  estimatedMinutes: 8,
)
```

**Key Fields:**
- `levelOfExposure`: Determines difficulty tier
  - **1**: Digital/Observation (no interaction)
  - **2**: Physical Presence (being around people)
  - **3**: Short Scripted Interaction (brief verbal exchange)
  - **4**: Interactive Micro-Conversation (back-and-forth dialogue)
- `successXp`: Awarded for full mission completion
- `courageXp`: Awarded for attempting (even if backing out)
- `escapeHatchInstruction`: Provides safe exit strategy (only for L3-L4)

#### `UserMissionState` (Enum)
Tracks the runtime state of a mission:
```dart
enum UserMissionState {
  available,      // Ready to attempt
  inProgress,     // Currently attempting
  completed,      // Successfully completed
  attempted,      // Tried but used escape hatch
  passed,         // Passed over for the day
  locked,         // Requires progression unlock
}
```

#### `MissionProgress` (Immutable Runtime State)
Tracks user's engagement with a specific mission instance:
```dart
MissionProgress(
  progressId: 'unique_id',
  missionId: 'l3_m001',
  state: UserMissionState.completed,
  assignedAt: DateTime.now(),
  completedAt: DateTime.now(),
  wasFullyCompleted: true,      // true = success, false = attempted
  xpEarned: 100,
  userNotes: '...',             // Optional reflection
)
```

---

### 2.2 CORE GAMEPLAY LOGIC: `MissionBoardController`

State management using `ChangeNotifier` pattern.

#### The Exposure Filter
```dart
// Generates exactly 3 randomized missions each day
// Ensures missions do NOT exceed user's max exposure level
List<MissionModel> getMissionsByLevel(int maxLevel)
void _initializeDailyBoard()  // Called daily
```

**Psychology Principle:** Customized challenge ladder prevents overwhelming users.

#### The Psychology Engine (Courage XP)
```dart
int resolveMission(String missionId, bool accomplishedFully)
```

**Rules:**
- If `accomplishedFully = true`: Award full `successXp` ✅
- If `accomplishedFully = false`: Award partial `courageXp` 💪

**Key Insight:** Rewarding effort (not just completion) validates the psychological principle that *showing up and trying* is already a win for socially anxious people.

#### Anxiety Reroll (Analysis Paralysis Prevention)
```dart
bool rerollMission(String missionIdToReplace)  // max 1 per day
```

**Rules:**
- User can swap ONE mission per day if overwhelmed
- Limit enforced via `_maxRerollsPerDay = 1`
- Prevents endless decision-making paralysis

---

### 2.3 SEED MISSIONS

16 production-ready missions across all 4 levels:

#### Level 1: Reconnaissance (4 missions)
- Social Radar Calibration
- Digital Presence Mission
- Email Infiltration
- Like & Learn

#### Level 2: Infiltration (4 missions)
- Crowd Immersion
- Vendor Dialogue (No Purchase)
- Parallel Play Protocol
- Compliment Delivery System

#### Level 3: Verbal Interaction (4 missions)
- Barista Negotiation
- Checkout Chit-Chat
- Phone Call Protocol
- Group Chat Participation

#### Level 4: Micro-Conversations (4 missions)
- Casual Hangout Initiation
- Active Listening Deep Dive
- Group Integration
- Authentic Self-Disclosure

**Design Principles:**
- ✍️ Copywriting mimics undercover operations / cozy RPG quest log tone
- 🛡️ Every L3-L4 mission includes an escape hatch
- ⭐ XP values scale with difficulty
- 🎯 Missions are achievable yet challenging

---

## 3. UI COMPONENTS

### 3.1 `MissionCard` Widget

**Features:**
- ✨ Color-coded by exposure level (green → yellow → orange → red)
- 🛡️ Escape Hatch container (amber box) for L3-L4 missions
- 💪 Two action buttons:
  - **Cleared**: Mark full completion (green button)
  - **Tried**: Mark as attempted/backed out (yellow button)
- 🔄 Reroll button (if rerolls remain)
- 📊 XP display showing both reward types
- 🎨 Visual states: Active, In Progress, Completed

**Color Scheme:**
```dart
Level 1: #7AC74F (Soothing green)
Level 2: #F4D35E (Warm yellow)
Level 3: #FF9F45 (Warm orange)
Level 4: #E63946 (Alert coral/red)
```

---

### 3.2 `PracticePage` Widget

The main Mission Board interface featuring:
- 📋 Today's briefing (available/resolved count, rerolls remaining)
- 📊 Exposure level selector with level-up button
- 🎯 Active missions carousel (MissionCard × 3)
- ✨ Completed missions summary
- 💡 Motivational footer with psychology-driven message

---

## 4. STATE MANAGEMENT

**Pattern:** `ChangeNotifier` + `ListenableBuilder`

**Why this approach?**
- ✅ Minimal dependencies (no Riverpod/BLoC learning curve)
- ✅ Built into Flutter (Provider package optional)
- ✅ Easy to test
- ✅ Suitable for single-screen game logic

**Usage in PracticePage:**
```dart
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    // Automatically rebuilds when _controller notifies
    return MissionCard(
      controller: _controller,
      // ...
    );
  },
)
```

---

## 5. PSYCHOLOGICAL DESIGN PRINCIPLES

### 5.1 Exposure Hierarchy
Missions are **intentionally ordered** from least to most anxiety-provoking:
- L1: No human interaction required
- L2: Passive presence around people
- L3: Structured, time-limited interaction
- L4: Reciprocal dialogue & vulnerability

### 5.2 Courage XP System
**Problem:** Traditional gamification rewards only "perfect" wins.
**Solution:** Award `courageXp` for *attempting* missions, even if user retreats via escape hatch.

**Psychology:** Validates effort and reinforces that showing up = success for anxiety sufferers.

### 5.3 Escape Hatch Instructions
For L3-L4 missions, every card displays a **specific, actionable exit strategy** (amber shield box):
- Provides psychological safety
- Reduces anticipatory anxiety
- Gives user back sense of control

### 5.4 One Reroll Per Day
**Problem:** Unlimited rerolls enable avoidance/analysis paralysis.
**Solution:** Hard limit of 1 reroll/day encourages commitment while respecting overwhelm.

---

## 6. INTEGRATION GUIDE

### 6.1 Add to Navigation (main.dart)

The `PracticePage` is already imported and ready to use:

```dart
// In your tab navigator or route handler:
PracticePage()
```

### 6.2 Connect to Dashboard / Navigation Flow

```dart
// In dashboard_page.dart or navigation logic:
GestureDetector(
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const PracticePage()),
  ),
  child: const Text('🎮 Practice'),
)
```

### 6.3 Progression System (Future Enhancement)

```dart
// When user completes all L1 missions:
void checkForLevelUp() {
  if (_controller.resolvedMissions.length >= 3) {
    _controller.unlockExposureLevel(2);
    _controller.generateNewDailyBoard();
    // Show celebratory UI
  }
}
```

---

## 7. TESTING & VALIDATION

### 7.1 Unit Tests (MissionBoardController)

```dart
test('Exposure filter respects max level', () {
  final controller = MissionBoardController(initialMaxExposureLevel: 1);
  final board = controller.activeMissionBoard;
  
  expect(board.length, 3);
  expect(board.every((m) => m.levelOfExposure <= 1), true);
});

test('resolveMission awards correct XP', () {
  final controller = MissionBoardController();
  final xpBefore = controller.totalXpEarned;
  
  controller.resolveMission('l1_m001', true);
  
  expect(controller.totalXpEarned, greaterThan(xpBefore));
});

test('Reroll respects daily limit', () {
  final controller = MissionBoardController();
  
  expect(controller.rerollMission('l1_m001'), true);
  expect(controller.rerollMission('l1_m002'), false); // Second attempt fails
});
```

### 7.2 Widget Tests (MissionCard)

```dart
testWidgets('MissionCard shows escape hatch for L3+ missions', (tester) async {
  final mission = SeedMissions.getMissionById('l3_m001');
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MissionCard(
          mission: mission!,
          missionProgress: MissionProgress(...),
          controller: controller,
        ),
      ),
    ),
  );
  
  expect(find.text('Escape Hatch (Safe Exit)'), findsOneWidget);
  expect(find.byIcon(Icons.shield), findsOneWidget);
});
```

---

## 8. FUTURE ENHANCEMENTS

- [ ] **Persistent Storage:** SQLite/Hive for daily history
- [ ] **Achievement Badges:** Unlock achievements for milestone completions
- [ ] **Social Leaderboard:** Safe, anonymous community comparisons
- [ ] **Therapy Integration:** Share progress with mental health professionals
- [ ] **Adaptive Difficulty:** ML-based mission scheduling based on user patterns
- [ ] **Reflection Journal:** User notes become micro-learning database
- [ ] **Streak System:** Gamified consistency rewards
- [ ] **Community Missions:** Collaborative challenges

---

## 9. FILES CREATED

```
📄 lib/models/mission_model.dart
📄 lib/models/user_mission_state.dart
📄 lib/models/seed_missions.dart
📄 lib/controllers/mission_board_controller.dart
📄 lib/widgets/mission_card.dart
📄 lib/pages/practice_page.dart
📄 MISSION_BOARD_ARCHITECTURE.md (this file)
```

---

## 10. QUICK START

1. **View Practice Page:**
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(builder: (_) => const PracticePage()),
   )
   ```

2. **Access Game Logic:**
   ```dart
   final controller = MissionBoardController(initialMaxExposureLevel: 1);
   controller.resolveMission('l1_m001', true);  // Full completion
   controller.rerollMission('l1_m001');          // Swap mission
   ```

3. **Check Progress:**
   ```dart
   print(controller.getDaySummary());
   // {
   //   'totalXpEarned': 150,
   //   'missionsCompleted': 1,
   //   'missionsAttempted': 1,
   //   'availableCount': 1,
   //   'rerollsRemaining': 1,
   // }
   ```

---

## 11. DESIGN PHILOSOPHY

This architecture embodies:
- **Behavioral Psychology:** Exposure hierarchy, courage rewards, safe exits
- **Player Psychology:** RPG framing, XP systems, level progression
- **Accessibility:** Simple state management, clear separation of concerns
- **Scalability:** Easily add new missions, difficulty levels, or reward systems
- **Compassion:** Designed specifically for socially anxious users—no judgment, only encouragement

---

**Built with ❤️ for introverts by an expert Flutter developer + behavioral psychology specialist.**
