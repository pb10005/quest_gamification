import 'package:flutter/material.dart';
import 'package:quest_gamification/quest_gamification.dart';
import 'package:widgetbook/widgetbook.dart';

final achievementToastUseCases = [
  WidgetbookUseCase(
    name: 'Level Up',
    builder: (context) {
      final level = context.knobs.int.slider(
        label: 'Level',
        initialValue: 10,
        min: 2,
        max: 30,
      );

      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              QuestAchievementToast.showLevelUp(context, level: level);
            },
            child: const Text('Show Level Up Toast'),
          ),
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'Badge Earned',
    builder: (context) {
      final badge = EarnedBadge(
        badgeId: 'streak_7',
        name: '7日ストリーク',
        emoji: '🔥',
        description: '7日連続で記録を継続した',
        earnedAt: DateTime.now(),
      );

      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              QuestAchievementToast.showBadge(context, badge: badge);
            },
            child: const Text('Show Badge Toast'),
          ),
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'Level Up + Badge (combined)',
    builder: (context) {
      final badge = EarnedBadge(
        badgeId: 'level_10',
        name: 'レベル10',
        emoji: '🌟',
        description: 'レベル10に到達した',
        earnedAt: DateTime.now(),
      );

      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              QuestAchievementToast.showResult(
                context,
                leveledUp: true,
                level: 10,
                newBadges: [badge],
              );
            },
            child: const Text('Show Level Up + Badge'),
          ),
        ),
      );
    },
  ),
];
