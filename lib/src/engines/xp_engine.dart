import '../config/quest_config.dart';
import '../models/user_progress.dart';

/// XP計算・レベルアップ判定エンジン
class XpEngine {
  final QuestConfig config;

  const XpEngine(this.config);

  /// XPを付与し、更新された [UserProgress] を返す
  UserProgress addXp(UserProgress progress, int amount) {
    if (amount <= 0) return progress;

    final newXp = progress.totalXp + amount;
    final newLevel = config.levelFromXp(newXp);

    return progress.copyWith(
      totalXp: newXp,
      level: newLevel,
    );
  }

  /// イベントIDに対応するXPを付与する
  UserProgress addXpForEvent(UserProgress progress, String eventId) {
    final xp = config.xpFor(eventId);
    return addXp(progress, xp);
  }

  /// レベルアップが発生したか確認する
  bool didLevelUp(UserProgress before, UserProgress after) =>
      after.level > before.level;
}
