/// Quest Gamification SDK
///
/// RPG-style gamification engine for health & wellness Flutter apps.
/// Provides XP, levels, badges, streaks, and shields out of the box.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:quest_gamification/quest_gamification.dart';
///
/// // 1. エンジンをセットアップ
/// final engine = GamificationEngine(
///   config: QuestConfig.fitness(),        // プリセット設定
///   repository: InMemoryProgressRepository(), // or HiveProgressAdapter / FirestoreProgressAdapter
/// );
///
/// // 2. アクションを記録するだけ
/// final result = await engine.recordEvent(QuestEvent.workoutCompleted);
///
/// // 3. 通知を表示
/// QuestAchievementToast.showResult(context,
///   leveledUp: result.leveledUp,
///   level: result.progress.level,
///   newBadges: result.newBadges,
/// );
///
/// // 4. UIに進捗を表示
/// QuestLevelCard(progress: result.progress, config: engine.config)
/// ```
library quest_gamification;

// Config
export 'src/config/quest_config.dart';

// Models
export 'src/models/badge_definition.dart';
export 'src/models/quest_event.dart';
export 'src/models/user_progress.dart';

// Engines
export 'src/engines/gamification_engine.dart';
export 'src/engines/xp_engine.dart';
export 'src/engines/badge_engine.dart';
export 'src/engines/streak_engine.dart';

// Adapters
export 'src/adapters/progress_repository.dart';
export 'src/adapters/firestore_adapter.dart';
export 'src/adapters/hive_adapter.dart';

// Widgets
export 'src/widgets/quest_xp_bar.dart';
export 'src/widgets/quest_level_card.dart';
export 'src/widgets/quest_streak_card.dart';
export 'src/widgets/quest_badge_grid.dart';
export 'src/widgets/quest_achievement_toast.dart';

// Presets
export 'src/presets/fitness_preset.dart';
