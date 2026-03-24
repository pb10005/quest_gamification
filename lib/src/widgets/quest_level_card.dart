import 'package:flutter/material.dart';
import '../models/user_progress.dart';
import '../config/quest_config.dart';
import 'quest_xp_bar.dart';
import 'quest_streak_card.dart';

/// レベル・XP・ストリークをまとめて表示するカード
///
/// FitQuest の LevelCard を汎用化したもの。
/// グラデーション背景に白テキストで表示する。
///
/// ```dart
/// QuestLevelCard(
///   progress: userProgress,
///   config: QuestConfig.fitness(),
/// )
/// ```
class QuestLevelCard extends StatelessWidget {
  final UserProgress progress;
  final QuestConfig config;

  /// グラデーションの開始色（省略時はテーマ primary）
  final Color? gradientStart;

  /// グラデーションの終了色（省略時は primary の暗め）
  final Color? gradientEnd;

  /// レベルに応じたアバター絵文字を返すカスタム関数
  final String Function(int level)? avatarBuilder;

  const QuestLevelCard({
    super.key,
    required this.progress,
    required this.config,
    this.gradientStart,
    this.gradientEnd,
    this.avatarBuilder,
  });

  String _defaultAvatar(int level) {
    if (level >= 20) return '🏆';
    if (level >= 15) return '⚡';
    if (level >= 10) return '🌟';
    if (level >= 5) return '💪';
    return '🌱';
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final start = gradientStart ?? primary;
    final end = gradientEnd ??
        Color.fromARGB(
          255,
          (primary.r * 0.6).round(),
          (primary.g * 0.6).round(),
          (primary.b * 0.6).round(),
        );

    final avatar =
        (avatarBuilder ?? _defaultAvatar)(progress.level);

    return Semantics(
      label:
          'レベル${progress.level}、XP ${progress.xpForCurrentLevel(config.xpPerLevel)} / ${config.xpPerLevel}、ストリーク${progress.currentStreak}日',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [start, end],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: start.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // アバター
            ExcludeSemantics(
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(avatar, style: const TextStyle(fontSize: 36)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Level ${progress.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ExcludeSemantics(
                        child: QuestStreakCard(progress: progress),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  QuestXpBar(
                    progress: progress,
                    xpPerLevel: config.xpPerLevel,
                    color: Colors.white,
                    height: 8,
                    showLabel: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
