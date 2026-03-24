/// アクションイベント型
///
/// アプリ側から `GamificationEngine.recordEvent()` に渡す。
/// [eventId] は `QuestConfig.xpMap` のキーと一致させる。
class QuestEvent {
  final String eventId;
  final DateTime? occurredAt;
  final Map<String, dynamic> metadata;

  const QuestEvent(
    this.eventId, {
    this.occurredAt,
    this.metadata = const {},
  });

  DateTime get timestamp => occurredAt ?? DateTime.now();

  // 標準イベント定数（FitQuest / fitness preset 用）
  static const QuestEvent weightRecorded = QuestEvent('weight_recorded');
  static const QuestEvent workoutCompleted = QuestEvent('workout_completed');
  static const QuestEvent mealRecorded = QuestEvent('meal_recorded');

  @override
  String toString() => 'QuestEvent($eventId)';
}
