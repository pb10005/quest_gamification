import 'package:flutter/material.dart';
import 'package:quest_gamification/quest_gamification.dart';
import 'package:widgetbook/widgetbook.dart';

// サンプル用の取得済みバッジ
final _earnedAll = [
  EarnedBadge(
    badgeId: 'first_workout',
    name: '初回ワークアウト',
    emoji: '🏋️',
    description: '初めてワークアウトを記録した',
    earnedAt: DateTime(2026, 3, 1),
  ),
  EarnedBadge(
    badgeId: 'streak_7',
    name: '7日ストリーク',
    emoji: '🔥',
    description: '7日連続で記録を継続した',
    earnedAt: DateTime(2026, 3, 8),
  ),
  EarnedBadge(
    badgeId: 'weight_10',
    name: '体重マスター',
    emoji: '⚖️',
    description: '体重を10回記録した',
    earnedAt: DateTime(2026, 3, 15),
  ),
];

final badgeGridUseCases = [
  WidgetbookUseCase(
    name: 'Default (with locked badges)',
    builder: (context) {
      final crossAxisCount = context.knobs.int.slider(
        label: 'Columns',
        initialValue: 4,
        min: 2,
        max: 6,
      );
      final showLocked = context.knobs.boolean(
        label: 'Show Locked',
        initialValue: true,
      );

      final progress = UserProgress(earnedBadges: _earnedAll);
      final config = QuestConfig.fitness();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: QuestBadgeGrid(
          progress: progress,
          allBadges: config.badges,
          crossAxisCount: crossAxisCount,
          showLocked: showLocked,
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'No badges yet',
    builder: (context) {
      const progress = UserProgress();
      final config = QuestConfig.fitness();
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: QuestBadgeGrid(
          progress: progress,
          allBadges: config.badges,
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'All earned',
    builder: (context) {
      final allBadges = QuestConfig.fitness().badges;
      final allEarned = allBadges
          .map((b) => EarnedBadge(
                badgeId: b.id,
                name: b.name,
                emoji: b.emoji,
                description: b.description,
                earnedAt: DateTime(2026, 3, 20),
              ))
          .toList();
      final progress = UserProgress(earnedBadges: allEarned);

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: QuestBadgeGrid(
          progress: progress,
          allBadges: allBadges,
        ),
      );
    },
  ),
];
