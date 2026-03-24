import 'package:flutter/material.dart';
import '../models/badge_definition.dart';

/// レベルアップ・バッジ取得時の達成通知トースト
///
/// `GamificationEngine.recordEvent()` の結果を受け取り、
/// `GamificationResult.leveledUp` や `GamificationResult.newBadges` に応じて
/// スナックバー形式の通知を表示する。
///
/// ```dart
/// final result = await engine.recordEvent(QuestEvent.workoutCompleted);
/// if (result.leveledUp) {
///   QuestAchievementToast.showLevelUp(context, level: result.progress.level);
/// }
/// for (final badge in result.newBadges) {
///   QuestAchievementToast.showBadge(context, badge: badge);
/// }
/// ```
class QuestAchievementToast {
  QuestAchievementToast._();

  /// レベルアップ通知を表示する
  static void showLevelUp(
    BuildContext context, {
    required int level,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = backgroundColor ??
        Theme.of(context).colorScheme.primary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            const Text('🌟', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'LEVEL UP!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Level $level に到達しました！',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// バッジ取得通知を表示する
  static void showBadge(
    BuildContext context, {
    required EarnedBadge badge,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = backgroundColor ??
        HSLColor.fromColor(Theme.of(context).colorScheme.primary)
            .withSaturation(0.7)
            .withLightness(0.35)
            .toColor();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            Text(badge.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'バッジ取得！',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    badge.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// レベルアップとバッジをまとめて表示するヘルパー
  ///
  /// `GamificationResult` の内容に応じて自動で通知を並べて表示する。
  static void showResult(
    BuildContext context, {
    required bool leveledUp,
    required int level,
    required List<EarnedBadge> newBadges,
  }) {
    if (leveledUp) {
      showLevelUp(context, level: level);
    }
    for (final badge in newBadges) {
      showBadge(context, badge: badge);
    }
  }
}
