import 'package:quest_gamification/quest_gamification.dart';
import 'package:test/test.dart';

void main() {
  late GamificationEngine engine;

  setUp(() {
    engine = GamificationEngine(
      config: QuestConfig.fitness(),
      repository: InMemoryProgressRepository(),
    );
  });

  group('XpEngine', () {
    test('ワークアウト完了で50XP付与される', () async {
      final result = await engine.recordEvent(QuestEvent.workoutCompleted);
      expect(result.xpGained, 50);
      expect(result.progress.totalXp, 50);
    });

    test('体重記録で10XP付与される', () async {
      final result = await engine.recordEvent(QuestEvent.weightRecorded);
      expect(result.xpGained, 10);
      expect(result.progress.totalXp, 10);
    });

    test('100XP到達でレベル2になる', () async {
      // 2回ワークアウト(50+50=100XP) → レベル2
      await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 1),
      );
      final result = await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 2),
      );
      expect(result.leveledUp, isTrue);
      expect(result.progress.level, 2);
    });

    test('定義外イベントはXP 0', () async {
      final result =
          await engine.recordEvent(const QuestEvent('unknown_event'));
      expect(result.xpGained, 0);
    });
  });

  group('StreakEngine', () {
    test('初回アクティビティでストリーク1', () async {
      final result = await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 1),
      );
      expect(result.progress.currentStreak, 1);
    });

    test('連続2日でストリーク2', () async {
      await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 1),
      );
      final result = await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 2),
      );
      expect(result.progress.currentStreak, 2);
    });

    test('同日重複はストリーク変化なし', () async {
      await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 1),
      );
      final result = await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 1),
      );
      expect(result.progress.currentStreak, 1);
    });

    test('1日スキップ＋シールドでストリーク継続', () async {
      await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 1),
      );
      // 1日飛ばして記録（シールド初期値=1）
      final result = await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 3),
      );
      expect(result.progress.currentStreak, 2);
      expect(result.progress.streakShields, 0); // シールド消費
    });

    test('シールドなしで2日以上スキップするとストリークリセット', () async {
      // シールドを0にするため初期設定でシールド0のエンジンを使う
      final noShieldEngine = GamificationEngine(
        config: QuestConfig(
          xpMap: const {'workout_completed': 50},
          badges: [],
          maxShields: 0,
          shieldGrantInterval: 999,
        ),
        repository: InMemoryProgressRepository(),
      );

      await noShieldEngine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 1),
      );
      final result = await noShieldEngine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 4),
      );
      expect(result.progress.currentStreak, 1);
    });

    test('7日連続でシールドが1個追加される', () async {
      for (int i = 1; i <= 7; i++) {
        await engine.recordEvent(
          QuestEvent.workoutCompleted,
          now: DateTime(2026, 1, i),
        );
      }
      final progress = await engine.getProgress();
      // 初期シールド1 + 7日達成で+1 = 2
      expect(progress.streakShields, 2);
    });
  });

  group('BadgeEngine', () {
    test('初回ワークアウトでバッジ取得', () async {
      final result = await engine.recordEvent(QuestEvent.workoutCompleted);
      expect(result.newBadges.any((b) => b.badgeId == 'first_workout'), isTrue);
    });

    test('7日ストリークでバッジ取得', () async {
      for (int i = 1; i <= 7; i++) {
        await engine.recordEvent(
          QuestEvent.workoutCompleted,
          now: DateTime(2026, 1, i),
        );
      }
      final progress = await engine.getProgress();
      expect(progress.hasBadge('streak_7'), isTrue);
    });

    test('同じバッジは重複付与されない', () async {
      await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 1),
      );
      final result = await engine.recordEvent(
        QuestEvent.workoutCompleted,
        now: DateTime(2026, 1, 2),
      );
      // first_workout は2回目には付与されない
      expect(
        result.newBadges.where((b) => b.badgeId == 'first_workout').length,
        0,
      );
    });

    test('体重10回記録でバッジ取得', () async {
      for (int i = 1; i <= 10; i++) {
        await engine.recordEvent(
          QuestEvent.weightRecorded,
          now: DateTime(2026, 1, i),
        );
      }
      final progress = await engine.getProgress();
      expect(progress.hasBadge('weight_10'), isTrue);
    });

    test('目標体重達成バッジ（metadata経由）', () async {
      final result = await engine.recordEvent(
        QuestEvent.weightRecorded,
        metadata: {'goal_weight_achieved': true},
      );
      expect(result.newBadges.any((b) => b.badgeId == 'goal_weight'), isTrue);
    });
  });

  group('GamificationEngine 統合', () {
    test('reset後は初期状態に戻る', () async {
      await engine.recordEvent(QuestEvent.workoutCompleted);
      await engine.reset();
      final progress = await engine.getProgress();
      expect(progress.totalXp, 0);
      expect(progress.level, 1);
      expect(progress.earnedBadges, isEmpty);
    });

    test('進捗が永続化されている', () async {
      await engine.recordEvent(QuestEvent.workoutCompleted);
      final loaded = await engine.getProgress();
      expect(loaded.totalXp, 50);
    });
  });
}
