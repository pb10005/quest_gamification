import 'package:flutter/material.dart';
import 'package:quest_gamification/quest_gamification.dart';
import 'package:widgetbook/widgetbook.dart';

final streakCardUseCases = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) {
      final streak = context.knobs.int.slider(
        label: 'Streak (days)',
        initialValue: 7,
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
        currentStreak: streak,
        streakShields: shields,
      );

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: QuestStreakCard(progress: progress),
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'No streak',
    builder: (context) {
      const progress = UserProgress(currentStreak: 0);
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: QuestStreakCard(progress: progress),
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'Long streak with shields',
    builder: (context) {
      const progress = UserProgress(currentStreak: 30, streakShields: 3);
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: QuestStreakCard(progress: progress),
        ),
      );
    },
  ),
];
