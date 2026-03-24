import '../models/badge_definition.dart';
import '../models/user_progress.dart';
import '../config/quest_config.dart';

/// バッジ付与ルールエンジン
///
/// イベント発火後に全バッジ定義の条件を評価し、
/// 未取得かつ条件を満たすバッジを付与する。
class BadgeEngine {
  final QuestConfig config;

  const BadgeEngine(this.config);

  /// バッジ評価を実行し、新たに取得したバッジを付与した [UserProgress] を返す
  ///
  /// 新規取得バッジがない場合は同じインスタンスを返す。
  UserProgress evaluate(
    UserProgress progress,
    String eventId, {
    Map<String, dynamic> metadata = const {},
    DateTime? now,
  }) {
    final ctx = BadgeEvaluationContext(
      eventId: eventId,
      totalXp: progress.totalXp,
      level: progress.level,
      streak: progress.currentStreak,
      eventCounts: progress.eventCounts,
      metadata: metadata,
    );

    final newBadges = <EarnedBadge>[];

    for (final def in config.badges) {
      if (progress.hasBadge(def.id)) continue; // 取得済みはスキップ
      if (def.condition(ctx)) {
        newBadges.add(EarnedBadge(
          badgeId: def.id,
          name: def.name,
          emoji: def.emoji,
          description: def.description,
          earnedAt: now ?? DateTime.now(),
        ));
      }
    }

    if (newBadges.isEmpty) return progress;

    return progress.copyWith(
      earnedBadges: [...progress.earnedBadges, ...newBadges],
    );
  }

  /// 今回新たに取得されたバッジのみを返す（通知表示等に使用）
  List<EarnedBadge> getNewlyEarnedBadges(
    UserProgress before,
    UserProgress after,
  ) {
    final beforeIds = before.earnedBadges.map((b) => b.badgeId).toSet();
    return after.earnedBadges
        .where((b) => !beforeIds.contains(b.badgeId))
        .toList();
  }
}
