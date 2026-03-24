import '../models/badge_definition.dart';

/// FitQuest 用バッジ定義プリセット
final List<BadgeDefinition> fitnessBadges = [
  BadgeDefinition(
    id: 'first_workout',
    name: '初回ワークアウト',
    emoji: '🏋️',
    description: '初めてワークアウトを記録した',
    condition: (ctx) =>
        ctx.eventId == 'workout_completed' &&
        (ctx.eventCounts['workout_completed'] ?? 0) == 1,
  ),
  BadgeDefinition(
    id: 'streak_7',
    name: '7日ストリーク',
    emoji: '🔥',
    description: '7日連続で記録を継続した',
    condition: (ctx) => ctx.streak >= 7,
  ),
  BadgeDefinition(
    id: 'streak_30',
    name: '30日ストリーク',
    emoji: '💪',
    description: '30日連続で記録を継続した',
    condition: (ctx) => ctx.streak >= 30,
  ),
  BadgeDefinition(
    id: 'weight_10',
    name: '体重マスター',
    emoji: '⚖️',
    description: '体重を10回記録した',
    condition: (ctx) => (ctx.eventCounts['weight_recorded'] ?? 0) >= 10,
  ),
  BadgeDefinition(
    id: 'goal_weight',
    name: '目標達成！',
    emoji: '🎯',
    description: '目標体重を達成した',
    condition: (ctx) => ctx.metadata['goal_weight_achieved'] == true,
  ),
  BadgeDefinition(
    id: 'level_10',
    name: 'レベル10',
    emoji: '🌟',
    description: 'レベル10に到達した',
    condition: (ctx) => ctx.level >= 10,
  ),
];

/// SleepQuest 用バッジ定義プリセット
final List<BadgeDefinition> sleepBadges = [
  BadgeDefinition(
    id: 'first_sleep_log',
    name: '初回睡眠記録',
    emoji: '🌙',
    description: '初めて睡眠を記録した',
    condition: (ctx) =>
        ctx.eventId == 'sleep_logged' &&
        (ctx.eventCounts['sleep_logged'] ?? 0) == 1,
  ),
  BadgeDefinition(
    id: 'sleep_streak_7',
    name: '7日睡眠ストリーク',
    emoji: '🔥',
    description: '7日連続で睡眠を記録した',
    condition: (ctx) => ctx.streak >= 7,
  ),
  BadgeDefinition(
    id: 'sleep_streak_30',
    name: '30日睡眠ストリーク',
    emoji: '💪',
    description: '30日連続で睡眠を記録した',
    condition: (ctx) => ctx.streak >= 30,
  ),
  BadgeDefinition(
    id: 'perfect_week',
    name: 'パーフェクトウィーク',
    emoji: '🏆',
    description: '1週間すべての睡眠目標を達成した',
    condition: (ctx) => ctx.metadata['perfect_week'] == true,
  ),
];

/// MindQuest 用バッジ定義プリセット
final List<BadgeDefinition> mentalBadges = [
  BadgeDefinition(
    id: 'first_mood_log',
    name: '初回気分記録',
    emoji: '😊',
    description: '初めて気分を記録した',
    condition: (ctx) =>
        ctx.eventId == 'mood_logged' &&
        (ctx.eventCounts['mood_logged'] ?? 0) == 1,
  ),
  BadgeDefinition(
    id: 'week_streak',
    name: '1週間継続',
    emoji: '🔥',
    description: '7日連続で記録を継続した',
    condition: (ctx) => ctx.streak >= 7,
  ),
  BadgeDefinition(
    id: 'cbt_master',
    name: 'CBTマスター',
    emoji: '🧠',
    description: 'CBTエクササイズを10回完了した',
    condition: (ctx) => (ctx.eventCounts['cbt_exercise_completed'] ?? 0) >= 10,
  ),
  BadgeDefinition(
    id: 'calm_mind',
    name: '穏やかな心',
    emoji: '🕊️',
    description: '呼吸エクササイズを20回完了した',
    condition: (ctx) => (ctx.eventCounts['breathing_completed'] ?? 0) >= 20,
  ),
];

/// 法人向けバッジ定義プリセット
final List<BadgeDefinition> corporateBadges = [
  BadgeDefinition(
    id: 'team_player',
    name: 'チームプレイヤー',
    emoji: '🤝',
    description: 'チームチャレンジに初参加した',
    condition: (ctx) =>
        ctx.eventId == 'team_challenge_completed' &&
        (ctx.eventCounts['team_challenge_completed'] ?? 0) == 1,
  ),
  BadgeDefinition(
    id: 'consistency_king',
    name: '継続の王',
    emoji: '👑',
    description: '30日連続で活動を記録した',
    condition: (ctx) => ctx.streak >= 30,
  ),
  BadgeDefinition(
    id: 'wellness_champion',
    name: 'ウェルネスチャンピオン',
    emoji: '🏆',
    description: 'レベル10に到達した',
    condition: (ctx) => ctx.level >= 10,
  ),
];
