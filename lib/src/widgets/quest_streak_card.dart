import 'package:flutter/material.dart';
import '../models/user_progress.dart';

/// ストリーク日数＋シールド数を表示するカード
///
/// ```dart
/// QuestStreakCard(progress: userProgress)
/// ```
class QuestStreakCard extends StatelessWidget {
  final UserProgress progress;

  /// ストリークカラー（省略時はオレンジ）
  final Color streakColor;

  /// シールドカラー（省略時はブルーグレー）
  final Color shieldColor;

  const QuestStreakCard({
    super.key,
    required this.progress,
    this.streakColor = const Color(0xFFFF6B35),
    this.shieldColor = const Color(0xFF64748B),
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (progress.currentStreak == 0) return const SizedBox.shrink();

    return Semantics(
      label:
          '${progress.currentStreak}日連続ストリーク${progress.streakShields > 0 ? '、シールド${progress.streakShields}個' : ''}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ストリーク
          _Chip(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${progress.currentStreak}日',
                  style: TextStyle(
                    color: streakColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            backgroundColor: streakColor.withValues(alpha: 0.12),
          ),
          // シールド
          if (progress.streakShields > 0) ...[
            const SizedBox(width: 6),
            _Chip(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🛡️', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 3),
                  Text(
                    '${progress.streakShields}',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              backgroundColor: cs.onSurface.withValues(alpha: 0.08),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const _Chip({required this.child, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
