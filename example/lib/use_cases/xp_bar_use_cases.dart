import 'package:flutter/material.dart';
import 'package:quest_gamification/quest_gamification.dart';
import 'package:widgetbook/widgetbook.dart';

final xpBarUseCases = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) {
      final totalXp = context.knobs.int.slider(
        label: 'Total XP',
        initialValue: 65,
        min: 0,
        max: 300,
      );
      final xpPerLevel = context.knobs.int.slider(
        label: 'XP per Level',
        initialValue: 100,
        min: 50,
        max: 500,
        divisions: 9,
      );
      final height = context.knobs.double.slider(
        label: 'Height',
        initialValue: 8,
        min: 4,
        max: 20,
      );
      final showLabel = context.knobs.boolean(
        label: 'Show Label',
        initialValue: true,
      );

      final level = totalXp ~/ xpPerLevel + 1;
      final progress = UserProgress(totalXp: totalXp, level: level);

      return Padding(
        padding: const EdgeInsets.all(24),
        child: QuestXpBar(
          progress: progress,
          xpPerLevel: xpPerLevel,
          height: height,
          showLabel: showLabel,
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'Just leveled up',
    builder: (context) {
      const progress = UserProgress(totalXp: 100, level: 2);
      return const Padding(
        padding: EdgeInsets.all(24),
        child: QuestXpBar(progress: progress, xpPerLevel: 100),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'High level',
    builder: (context) {
      const progress = UserProgress(totalXp: 1550, level: 16);
      return const Padding(
        padding: EdgeInsets.all(24),
        child: QuestXpBar(progress: progress, xpPerLevel: 100),
      );
    },
  ),
];
