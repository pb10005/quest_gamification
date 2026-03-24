import 'badge_definition.dart';

/// ユーザーの現在のゲーミフィケーション状態
class UserProgress {
  /// 累計XP
  final int totalXp;

  /// 現在のレベル
  final int level;

  /// 現在のストリーク日数
  final int currentStreak;

  /// 最長ストリーク日数
  final int longestStreak;

  /// 残りストリークシールド数
  final int streakShields;

  /// 最後のアクティビティ日時
  final DateTime? lastActivityDate;

  /// 取得済みバッジ一覧
  final List<EarnedBadge> earnedBadges;

  /// イベントIDごとの記録回数
  final Map<String, int> eventCounts;

  const UserProgress({
    this.totalXp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.streakShields = 1,
    this.lastActivityDate,
    this.earnedBadges = const [],
    this.eventCounts = const {},
  });

  /// 現在のレベル内での進捗XP
  int xpForCurrentLevel(int xpPerLevel) => totalXp - ((level - 1) * xpPerLevel);

  /// 次のレベルまでの必要XP（固定式の場合）
  int xpToNextLevel(int xpPerLevel) => xpPerLevel;

  /// レベル進捗率 [0.0 〜 1.0]
  double levelProgress(int xpPerLevel) =>
      (xpForCurrentLevel(xpPerLevel) / xpToNextLevel(xpPerLevel)).clamp(0.0, 1.0);

  bool hasBadge(String badgeId) => earnedBadges.any((b) => b.badgeId == badgeId);

  UserProgress copyWith({
    int? totalXp,
    int? level,
    int? currentStreak,
    int? longestStreak,
    int? streakShields,
    DateTime? lastActivityDate,
    List<EarnedBadge>? earnedBadges,
    Map<String, int>? eventCounts,
  }) =>
      UserProgress(
        totalXp: totalXp ?? this.totalXp,
        level: level ?? this.level,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        streakShields: streakShields ?? this.streakShields,
        lastActivityDate: lastActivityDate ?? this.lastActivityDate,
        earnedBadges: earnedBadges ?? this.earnedBadges,
        eventCounts: eventCounts ?? this.eventCounts,
      );

  Map<String, dynamic> toMap() => {
        'totalXp': totalXp,
        'level': level,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'streakShields': streakShields,
        'lastActivityDate': lastActivityDate?.millisecondsSinceEpoch,
        'earnedBadges': earnedBadges.map((b) => b.toMap()).toList(),
        'eventCounts': eventCounts,
      };

  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
        totalXp: (map['totalXp'] as int?) ?? 0,
        level: (map['level'] as int?) ?? 1,
        currentStreak: (map['currentStreak'] as int?) ?? 0,
        longestStreak: (map['longestStreak'] as int?) ?? 0,
        streakShields: (map['streakShields'] as int?) ?? 1,
        lastActivityDate: map['lastActivityDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                map['lastActivityDate'] as int)
            : null,
        earnedBadges: (map['earnedBadges'] as List<dynamic>?)
                ?.map((e) => EarnedBadge.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
        eventCounts: Map<String, int>.from(
            (map['eventCounts'] as Map<dynamic, dynamic>?) ?? {}),
      );

  @override
  String toString() =>
      'UserProgress(level: $level, xp: $totalXp, streak: $currentStreak, badges: ${earnedBadges.length})';
}
