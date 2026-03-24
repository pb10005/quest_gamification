import '../config/quest_config.dart';
import '../models/quest_event.dart';
import '../models/user_progress.dart';
import '../models/badge_definition.dart';
import '../adapters/progress_repository.dart';
import 'xp_engine.dart';
import 'badge_engine.dart';
import 'streak_engine.dart';

/// イベント処理後の結果
class GamificationResult {
  /// 更新後のユーザー進捗
  final UserProgress progress;

  /// 今回付与されたXP量
  final int xpGained;

  /// レベルアップしたか
  final bool leveledUp;

  /// 今回新たに取得されたバッジ一覧
  final List<EarnedBadge> newBadges;

  const GamificationResult({
    required this.progress,
    required this.xpGained,
    required this.leveledUp,
    required this.newBadges,
  });

  bool get hasNewBadges => newBadges.isNotEmpty;

  @override
  String toString() =>
      'GamificationResult(xp: +$xpGained, levelUp: $leveledUp, badges: ${newBadges.map((b) => b.name).toList()})';
}

/// ゲーミフィケーション統合エントリーポイント
///
/// XP・レベル・ストリーク・バッジの全処理をまとめて提供する。
///
/// ```dart
/// // セットアップ
/// final engine = GamificationEngine(
///   config: QuestConfig.fitness(),
///   repository: InMemoryProgressRepository(),
/// );
///
/// // イベントを記録（XP付与・バッジ評価・ストリーク更新が自動実行）
/// final result = await engine.recordEvent(QuestEvent.workoutCompleted);
/// if (result.leveledUp) showLevelUpAnimation();
/// if (result.hasNewBadges) showBadgeToast(result.newBadges);
///
/// // 現在の進捗を取得
/// final progress = await engine.getProgress();
/// ```
class GamificationEngine {
  final QuestConfig config;
  final ProgressRepository repository;

  late final XpEngine _xp;
  late final BadgeEngine _badge;
  late final StreakEngine _streak;

  GamificationEngine({
    required this.config,
    required this.repository,
  }) {
    _xp = XpEngine(config);
    _badge = BadgeEngine(config);
    _streak = StreakEngine(config);
  }

  /// アクションイベントを記録し、XP付与・ストリーク更新・バッジ評価を実行する
  ///
  /// [event] — 発生したアクション
  /// [metadata] — バッジ条件評価に使う追加情報（例: `{'goal_weight_achieved': true}`）
  /// [now] — テスト用の現在時刻（省略時は `DateTime.now()`）
  Future<GamificationResult> recordEvent(
    QuestEvent event, {
    Map<String, dynamic> metadata = const {},
    DateTime? now,
  }) async {
    final before = await _loadOrDefault();

    // 1. イベントカウントを更新
    final updatedCounts = Map<String, int>.from(before.eventCounts);
    updatedCounts[event.eventId] =
        (updatedCounts[event.eventId] ?? 0) + 1;
    var progress = before.copyWith(eventCounts: updatedCounts);

    // 2. XP付与・レベルアップ判定
    final xpGained = config.xpFor(event.eventId);
    final afterXp = _xp.addXpForEvent(progress, event.eventId);
    final didLevelUp = _xp.didLevelUp(progress, afterXp);
    progress = afterXp;

    // 3. ストリーク更新
    progress = _streak.recordActivity(progress, now: now);

    // 4. バッジ評価
    final afterBadge = _badge.evaluate(
      progress,
      event.eventId,
      metadata: metadata,
      now: now,
    );
    final newBadges = _badge.getNewlyEarnedBadges(progress, afterBadge);
    progress = afterBadge;

    // 5. 保存
    await repository.save(progress);

    return GamificationResult(
      progress: progress,
      xpGained: xpGained,
      leveledUp: didLevelUp,
      newBadges: newBadges,
    );
  }

  /// 現在のユーザー進捗を取得する（存在しない場合は初期値を返す）
  Future<UserProgress> getProgress() => _loadOrDefault();

  /// 進捗をリセットする（デバッグ・テスト用）
  Future<void> reset() => repository.save(const UserProgress());

  /// 進捗の変更をリアルタイムで監視する
  Stream<UserProgress?> watch() => repository.watch();

  Future<UserProgress> _loadOrDefault() async =>
      (await repository.load()) ?? const UserProgress();
}
