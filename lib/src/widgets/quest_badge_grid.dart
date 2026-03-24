import 'package:flutter/material.dart';
import '../models/user_progress.dart';
import '../models/badge_definition.dart';

/// バッジコレクションをグリッド表示するウィジェット
///
/// 取得済みバッジは明るく表示、未取得はグレーアウト。
///
/// ```dart
/// QuestBadgeGrid(
///   progress: userProgress,
///   allBadges: config.badges,
/// )
/// ```
class QuestBadgeGrid extends StatelessWidget {
  final UserProgress progress;
  final List<BadgeDefinition> allBadges;

  /// グリッドの列数
  final int crossAxisCount;

  /// バッジチップのサイズ
  final double itemSize;

  /// 未取得バッジを表示するか
  final bool showLocked;

  const QuestBadgeGrid({
    super.key,
    required this.progress,
    required this.allBadges,
    this.crossAxisCount = 4,
    this.itemSize = 80,
    this.showLocked = true,
  });

  @override
  Widget build(BuildContext context) {
    final earned = progress.earnedBadges;
    final earnedIds = earned.map((b) => b.badgeId).toSet();

    final items = showLocked
        ? allBadges
        : allBadges.where((b) => earnedIds.contains(b.id)).toList();

    if (items.isEmpty) {
      return Center(
        child: Text(
          'バッジはまだありません',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final def = items[i];
        final isEarned = earnedIds.contains(def.id);
        final earnedBadge = isEarned
            ? earned.firstWhere((b) => b.badgeId == def.id)
            : null;
        return _BadgeItem(
          definition: def,
          isEarned: isEarned,
          earnedBadge: earnedBadge,
          size: itemSize,
        );
      },
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final BadgeDefinition definition;
  final bool isEarned;
  final EarnedBadge? earnedBadge;
  final double size;

  const _BadgeItem({
    required this.definition,
    required this.isEarned,
    required this.earnedBadge,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      label: isEarned
          ? '${definition.name}バッジ 取得済み'
          : '${definition.name}バッジ 未取得',
      child: Tooltip(
        message: isEarned
            ? '${definition.description}\n取得: ${_formatDate(earnedBadge!.earnedAt)}'
            : definition.description,
        child: AnimatedOpacity(
          opacity: isEarned ? 1.0 : 0.35,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              color: isEarned
                  ? cs.primaryContainer
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: isEarned
                  ? Border.all(
                      color: cs.primary.withValues(alpha: 0.4),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isEarned ? definition.emoji : '🔒',
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    definition.name,
                    style: TextStyle(
                      fontSize: 9,
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
}
