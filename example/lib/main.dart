import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'use_cases/xp_bar_use_cases.dart';
import 'use_cases/level_card_use_cases.dart';
import 'use_cases/streak_card_use_cases.dart';
import 'use_cases/badge_grid_use_cases.dart';
import 'use_cases/achievement_toast_use_cases.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'quest_gamification',
          children: [
            WidgetbookComponent(
              name: 'QuestXpBar',
              useCases: xpBarUseCases,
            ),
            WidgetbookComponent(
              name: 'QuestLevelCard',
              useCases: levelCardUseCases,
            ),
            WidgetbookComponent(
              name: 'QuestStreakCard',
              useCases: streakCardUseCases,
            ),
            WidgetbookComponent(
              name: 'QuestBadgeGrid',
              useCases: badgeGridUseCases,
            ),
            WidgetbookComponent(
              name: 'QuestAchievementToast',
              useCases: achievementToastUseCases,
            ),
          ],
        ),
      ],
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
                useMaterial3: true,
              ),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6C63FF),
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
            ),
          ],
        ),
        TextScaleAddon(min: 1.0, max: 2.0),
      ],
    );
  }
}
