# quest_gamification

RPG-style gamification engine for Flutter health & wellness apps.

XP, levels, badges, streaks, and streak shields — all wired up in a single `recordEvent()` call.

---

## Features

- **XP & Levels** — Award XP for user actions; configurable fixed or linear level formulas
- **Badges** — Condition-based badge definitions; add new badges without touching engine code
- **Streaks** — Daily activity streak tracking with longest-streak records
- **Streak Shields** — Earned insurance that protects a streak when the user misses one day
- **Built-in UI Widgets** — `QuestXpBar`, `QuestLevelCard`, `QuestStreakCard`, `QuestBadgeGrid`, `QuestAchievementToast`
- **Storage Adapters** — Firestore (callback design, no direct dependency), Hive, and InMemory
- **Presets** — `fitness`, `sleep`, `mental`, `corporate` configs ready to use

---

## Installation

```yaml
dependencies:
  quest_gamification: ^0.1.0
```

```sh
flutter pub get
```

---

## Quick Start

```dart
import 'package:quest_gamification/quest_gamification.dart';

// 1. Set up the engine with a preset config
final engine = GamificationEngine(
  config: QuestConfig.fitness(),
  repository: InMemoryProgressRepository(), // swap for Hive or Firestore in production
);

// 2. Record an action — XP, streak, and badge evaluation run automatically
final result = await engine.recordEvent(QuestEvent.workoutCompleted);

// 3. React to the result
if (result.leveledUp) showLevelUpAnimation(result.progress.level);
if (result.hasNewBadges) showBadgeToast(result.newBadges);

print(result); // GamificationResult(xp: +50, levelUp: true, badges: [初回ワークアウト])
```

---

## Core Concepts

### QuestConfig

All rules live in `QuestConfig`: which events give XP, how levels are calculated, and what badges exist.

```dart
// Use a preset
final config = QuestConfig.fitness();

// Or build a custom config
final config = QuestConfig(
  xpMap: {
    'task_completed': 20,
    'daily_goal': 50,
    'streak_milestone': 100,
  },
  badges: myBadges,
  xpPerLevel: 200,
  levelFormula: LevelFormula.linear, // XP required increases each level
  shieldGrantInterval: 7,            // earn a shield every 7-day streak
  maxShields: 3,
);
```

**Level formulas:**

| Formula | Behaviour |
|---------|-----------|
| `LevelFormula.fixed` | Every level costs `xpPerLevel` XP (default: 100) |
| `LevelFormula.linear` | Each level costs `xpPerLevel * level` — RPG-style scaling |

### QuestEvent

Wrap any user action as a `QuestEvent` whose `eventId` matches a key in `xpMap`:

```dart
// Built-in constants (fitness preset)
QuestEvent.workoutCompleted  // eventId: 'workout_completed'
QuestEvent.weightRecorded    // eventId: 'weight_recorded'
QuestEvent.mealRecorded      // eventId: 'meal_recorded'

// Custom event
const myEvent = QuestEvent('habit_checked');

// Event with metadata (used in badge conditions)
final event = QuestEvent(
  'weight_recorded',
  metadata: {'goal_weight_achieved': true},
);
```

### UserProgress

Immutable snapshot of a user's current gamification state:

```dart
final progress = await engine.getProgress();

progress.level          // current level
progress.totalXp        // cumulative XP
progress.currentStreak  // current streak in days
progress.longestStreak  // all-time best streak
progress.streakShields  // available shields
progress.earnedBadges   // List<EarnedBadge>

// Progress within the current level (0.0 – 1.0)
final ratio = progress.levelProgress(config.xpPerLevel);
```

### Badges

Define badges as pure data — the engine evaluates them automatically after every event:

```dart
final myBadges = [
  BadgeDefinition(
    id: 'first_action',
    name: 'First Step',
    emoji: '🚀',
    description: 'Completed your first action',
    condition: (ctx) =>
        ctx.eventId == 'task_completed' &&
        (ctx.eventCounts['task_completed'] ?? 0) == 1,
  ),
  BadgeDefinition(
    id: 'week_streak',
    name: '7-Day Streak',
    emoji: '🔥',
    description: 'Logged activity for 7 days straight',
    condition: (ctx) => ctx.streak >= 7,
  ),
  BadgeDefinition(
    id: 'level_10',
    name: 'Level 10',
    emoji: '🌟',
    description: 'Reached level 10',
    condition: (ctx) => ctx.level >= 10,
  ),
];
```

**`BadgeEvaluationContext` fields:**

| Field | Type | Description |
|-------|------|-------------|
| `eventId` | `String` | The event that triggered evaluation |
| `totalXp` | `int` | XP after this event |
| `level` | `int` | Level after this event |
| `streak` | `int` | Streak after this event |
| `eventCounts` | `Map<String, int>` | How many times each event has occurred |
| `metadata` | `Map<String, dynamic>` | Extra data passed with the event |

### Streak Shields

Shields let users survive one missed day without losing their streak.

- A shield is granted every `shieldGrantInterval` days of consecutive activity (default: 7)
- Maximum shields held at once: `maxShields` (default: 3)
- When a user misses exactly one day and has a shield, the streak continues and one shield is consumed

```
Day 1–7:  streak = 7 → shield granted (now 2 shields)
Day 8:    user misses
Day 9:    user logs → shield consumed, streak = 9 (not reset)
Day 14:   streak = 14 → shield granted (back to 2 shields)
```

---

## Presets

| Factory | Target app | Events |
|---------|-----------|--------|
| `QuestConfig.fitness()` | Fitness / weight tracking | `weight_recorded`, `workout_completed`, `meal_recorded` |
| `QuestConfig.sleep()` | Sleep tracking | `sleep_logged`, `sleep_goal_achieved`, `consistent_bedtime` |
| `QuestConfig.mental()` | Mental wellness | `mood_logged`, `cbt_exercise_completed`, `breathing_completed` |
| `QuestConfig.corporate()` | Corporate wellness | `daily_activity`, `team_challenge_completed`, `weekly_goal` |

---

## Storage Adapters

### InMemory (testing / prototyping)

```dart
repository: InMemoryProgressRepository()
```

### Hive (offline-first)

`HiveProgressAdapter.open()` is async — initialise it before building the engine:

```dart
// In app startup (e.g. main() or a FutureProvider)
final adapter = await HiveProgressAdapter.open(boxName: 'my_app_progress');

final engine = GamificationEngine(
  config: QuestConfig.fitness(),
  repository: adapter,
);
```

### Firestore (callback design — no direct cloud_firestore dependency)

The adapter accepts reader/writer callbacks so you control the Firestore reference:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final doc = FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .collection('gamification')
    .doc('progress');

final repository = FirestoreProgressAdapter(
  reader: () async {
    final snap = await doc.get();
    return snap.data();
  },
  writer: (data) => doc.set(data, SetOptions(merge: true)),
  streamer: () => doc.snapshots().map((s) => s.data()), // optional: for watch()
);
```

---

## UI Widgets

All widgets accept a `UserProgress` and render with your app's theme.

```dart
// XP progress bar with animation
QuestXpBar(
  progress: userProgress,
  xpPerLevel: 100,
  color: Colors.amber,  // optional, defaults to theme primary
)

// Level card
QuestLevelCard(
  progress: userProgress,
  config: engine.config,
)

// Streak display
QuestStreakCard(progress: userProgress)

// Badge grid
QuestBadgeGrid(
  progress: userProgress,
  allBadges: QuestConfig.fitness().badges, // or your own List<BadgeDefinition>
)

// Achievement toast (shown after recordEvent)
QuestAchievementToast.showResult(
  context,
  leveledUp: result.leveledUp,
  level: result.progress.level,
  newBadges: result.newBadges,
)
```

---

## Real-time Progress

Use `watch()` to drive UI reactively:

```dart
StreamBuilder<UserProgress?>(
  stream: engine.watch(),
  builder: (context, snapshot) {
    final progress = snapshot.data;
    if (progress == null) return const SizedBox();
    return QuestLevelCard(progress: progress, config: engine.config);
  },
)
```

---

## Testing

Use `InMemoryProgressRepository` and pass `now:` to control time:

```dart
test('shield protects streak on missed day', () async {
  final engine = GamificationEngine(
    config: QuestConfig.fitness(),
    repository: InMemoryProgressRepository(),
  );

  // Build a 7-day streak (earns a shield)
  for (int i = 0; i < 7; i++) {
    await engine.recordEvent(
      QuestEvent.workoutCompleted,
      now: DateTime(2026, 1, i + 1),
    );
  }

  // Skip day 8, record on day 9
  await engine.recordEvent(
    QuestEvent.workoutCompleted,
    now: DateTime(2026, 1, 9),
  );

  final progress = await engine.getProgress();
  expect(progress.currentStreak, 9); // streak survived
  expect(progress.streakShields, 1); // one shield consumed (2 → 1)
});
```

---

## License

MIT
