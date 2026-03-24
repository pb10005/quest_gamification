import '../models/badge_definition.dart';
import '../presets/fitness_preset.dart';

/// レベルアップのXP閾値計算方式
enum LevelFormula {
  /// 全レベル固定XP（例: 常に100XPでレベルアップ）
  fixed,

  /// 線形増加（例: level * baseXp で必要量が増える）
  linear,
}

/// GamificationEngine の設定注入口
///
/// プリセット（[QuestConfig.fitness] など）を使うか、
/// カスタム設定をコンストラクタで渡す。
///
/// ```dart
/// // プリセット使用
/// final config = QuestConfig.fitness();
///
/// // カスタム設定
/// final config = QuestConfig(
///   xpMap: {'my_event': 25},
///   badges: myBadges,
///   xpPerLevel: 200,
/// );
/// ```
class QuestConfig {
  /// イベントIDごとの付与XP量
  final Map<String, int> xpMap;

  /// レベルアップに必要なXP（固定式の場合の基準値）
  final int xpPerLevel;

  /// レベル計算方式
  final LevelFormula levelFormula;

  /// バッジ定義一覧
  final List<BadgeDefinition> badges;

  /// ストリークシールドを付与するストリーク間隔（日数）
  final int shieldGrantInterval;

  /// ストリークシールドの最大保持数
  final int maxShields;

  const QuestConfig({
    required this.xpMap,
    required this.badges,
    this.xpPerLevel = 100,
    this.levelFormula = LevelFormula.fixed,
    this.shieldGrantInterval = 7,
    this.maxShields = 3,
  });

  /// イベントに対するXP量を返す（定義されていない場合は 0）
  int xpFor(String eventId) => xpMap[eventId] ?? 0;

  /// XP合計からレベルを計算する
  int levelFromXp(int totalXp) {
    switch (levelFormula) {
      case LevelFormula.fixed:
        return (totalXp ~/ xpPerLevel) + 1;
      case LevelFormula.linear:
        int level = 1;
        int cumulative = 0;
        while (cumulative + xpPerLevel * level <= totalXp) {
          cumulative += xpPerLevel * level;
          level++;
        }
        return level;
    }
  }

  // ─── プリセットファクトリ ─────────────────────────────────

  /// FitQuest 用プリセット（体重記録・ワークアウト・食事管理）
  factory QuestConfig.fitness() => QuestConfig(
        xpMap: const {
          'weight_recorded': 10,
          'workout_completed': 50,
          'meal_recorded': 15,
        },
        badges: fitnessBadges,
        xpPerLevel: 100,
        shieldGrantInterval: 7,
        maxShields: 3,
      );

  /// SleepQuest 用プリセット（睡眠記録・目標達成）
  factory QuestConfig.sleep() => QuestConfig(
        xpMap: const {
          'sleep_logged': 20,
          'sleep_goal_achieved': 50,
          'consistent_bedtime': 30,
        },
        badges: sleepBadges,
        xpPerLevel: 100,
      );

  /// MindQuest 用プリセット（気分記録・CBT・呼吸法）
  factory QuestConfig.mental() => QuestConfig(
        xpMap: const {
          'mood_logged': 10,
          'cbt_exercise_completed': 40,
          'breathing_completed': 15,
        },
        badges: mentalBadges,
        xpPerLevel: 100,
      );

  /// 法人向けウェルネスアプリ用プリセット
  factory QuestConfig.corporate() => QuestConfig(
        xpMap: const {
          'daily_activity': 10,
          'team_challenge_completed': 100,
          'weekly_goal': 50,
        },
        badges: corporateBadges,
        xpPerLevel: 200,
      );
}
