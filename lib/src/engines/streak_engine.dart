import '../config/quest_config.dart';
import '../models/user_progress.dart';

/// ストリーク＋シールド管理エンジン
///
/// FitQuestのストリーク設計を移植:
/// - 前日アクティビティがある → ストリーク継続
/// - 同日の重複記録 → 無視
/// - 1日スキップ＋シールドあり → シールド消費してストリーク継続
/// - それ以外 → ストリークリセット
/// - [shieldGrantInterval] 日ごとにシールドを1個付与（最大 [maxShields] 個）
class StreakEngine {
  final QuestConfig config;

  const StreakEngine(this.config);

  /// アクティビティを記録し、更新された [UserProgress] を返す
  ///
  /// [now] は主にテスト用（省略時は `DateTime.now()`）
  UserProgress recordActivity(UserProgress progress, {DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());
    final last = progress.lastActivityDate != null
        ? _dateOnly(progress.lastActivityDate!)
        : null;

    int newStreak = progress.currentStreak;
    int newShields = progress.streakShields;

    if (last == null) {
      // 初回アクティビティ
      newStreak = 1;
    } else {
      final diff = today.difference(last).inDays;

      if (diff == 0) {
        // 同日の重複 → 何もしない
        return progress;
      } else if (diff == 1) {
        // 連続 → ストリーク継続
        newStreak = progress.currentStreak + 1;
        // shieldGrantInterval ごとにシールドを1個付与
        if (newStreak % config.shieldGrantInterval == 0) {
          newShields = (newShields + 1).clamp(0, config.maxShields);
        }
      } else if (diff == 2 && newShields > 0) {
        // 1日スキップ＋シールドあり → シールド消費してストリーク継続
        newStreak = progress.currentStreak + 1;
        newShields -= 1;
      } else {
        // ストリーク途絶
        newStreak = 1;
      }
    }

    final longestStreak =
        newStreak > progress.longestStreak ? newStreak : progress.longestStreak;

    return progress.copyWith(
      currentStreak: newStreak,
      longestStreak: longestStreak,
      streakShields: newShields,
      lastActivityDate: today,
    );
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
