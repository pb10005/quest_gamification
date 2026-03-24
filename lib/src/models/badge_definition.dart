/// バッジ付与条件の型
typedef BadgeCondition = bool Function(BadgeEvaluationContext ctx);

/// バッジ評価時に渡されるコンテキスト
class BadgeEvaluationContext {
  /// 今回のイベントID
  final String eventId;

  /// イベント発火後の総XP
  final int totalXp;

  /// イベント発火後のレベル
  final int level;

  /// 更新後のストリーク日数
  final int streak;

  /// 過去に記録されたイベントIDと回数のマップ
  final Map<String, int> eventCounts;

  /// メタデータ（例: `goal_weight_achieved: true`）
  final Map<String, dynamic> metadata;

  const BadgeEvaluationContext({
    required this.eventId,
    required this.totalXp,
    required this.level,
    required this.streak,
    required this.eventCounts,
    this.metadata = const {},
  });
}

/// バッジ定義
class BadgeDefinition {
  final String id;
  final String name;
  final String emoji;
  final String description;

  /// このバッジを付与するかどうかの判定ロジック
  final BadgeCondition condition;

  const BadgeDefinition({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.condition,
  });
}

/// 取得済みバッジの記録
class EarnedBadge {
  final String badgeId;
  final String name;
  final String emoji;
  final String description;
  final DateTime earnedAt;

  const EarnedBadge({
    required this.badgeId,
    required this.name,
    required this.emoji,
    required this.description,
    required this.earnedAt,
  });

  Map<String, dynamic> toMap() => {
        'badgeId': badgeId,
        'name': name,
        'emoji': emoji,
        'description': description,
        'earnedAt': earnedAt.millisecondsSinceEpoch,
      };

  factory EarnedBadge.fromMap(Map<String, dynamic> map) => EarnedBadge(
        badgeId: map['badgeId'] as String,
        name: map['name'] as String,
        emoji: map['emoji'] as String,
        description: map['description'] as String,
        earnedAt: DateTime.fromMillisecondsSinceEpoch(map['earnedAt'] as int),
      );
}
