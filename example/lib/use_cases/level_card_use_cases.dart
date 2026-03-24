import 'package:flutter/material.dart';
import 'package:quest_gamification/quest_gamification.dart';
import 'package:widgetbook/widgetbook.dart';

final levelCardUseCases = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) {
      final level = context.knobs.int.slider(
        label: 'Level',
        initialValue: 5,
        min: 1,
        max: 30,
      );
      final totalXp = context.knobs.int.slider(
        label: 'Total XP',
        initialValue: 465,
        min: 0,
        max: 3000,
      );
      final streak = context.knobs.int.slider(
        label: 'Streak (days)',
        initialValue: 12,
        min: 0,
        max: 100,
      );
      final shields = context.knobs.int.slider(
        label: 'Shields',
        initialValue: 1,
        min: 0,
        max: 3,
      );

      final progress = UserProgress(
        totalXp: totalXp,
        level: level,
        currentStreak: streak,
        streakShields: shields,
      );

      return Padding(
        padding: const EdgeInsets.all(24),
        child: QuestLevelCard(
          progress: progress,
          config: QuestConfig.fitness(),
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'Beginner (Lv.1)',
    builder: (context) {
      const progress = UserProgress(totalXp: 25, level: 1, currentStreak: 0);
      return Padding(
        padding: const EdgeInsets.all(24),
        child: QuestLevelCard(progress: progress, config: QuestConfig.fitness()),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'Veteran (Lv.15)',
    builder: (context) {
      const progress = UserProgress(
        totalXp: 1580,
        level: 15,
        currentStreak: 30,
        streakShields: 3,
      );
      return Padding(
        padding: const EdgeInsets.all(24),
        child: QuestLevelCard(progress: progress, config: QuestConfig.fitness()),
      );
    },
  ),
];
