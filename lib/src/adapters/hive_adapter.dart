import 'dart:async';
import 'package:hive/hive.dart';
import '../models/user_progress.dart';
import 'progress_repository.dart';

/// Hive を使った進捗永続化アダプタ
///
/// ## セットアップ例
///
/// ```dart
/// // アプリ起動時に Hive を初期化してからアダプタを生成する
/// await Hive.initFlutter(); // hive_flutter を使う場合
/// // or: Hive.init(directory.path); // 純 Dart の場合
///
/// final adapter = await HiveProgressAdapter.open(boxName: 'quest_progress');
///
/// final engine = GamificationEngine(
///   config: QuestConfig.fitness(),
///   repository: adapter,
/// );
/// ```
class HiveProgressAdapter implements ProgressRepository {
  static const _progressKey = 'user_progress';

  final Box<Map> _box;

  HiveProgressAdapter._(this._box);

  /// Hive Box を開いてアダプタを生成する
  static Future<HiveProgressAdapter> open({
    String boxName = 'quest_gamification',
  }) async {
    final box = await Hive.openBox<Map>(boxName);
    return HiveProgressAdapter._(box);
  }

  @override
  Future<UserProgress?> load() async {
    final raw = _box.get(_progressKey);
    if (raw == null) return null;
    return UserProgress.fromMap(Map<String, dynamic>.from(raw));
  }

  @override
  Future<void> save(UserProgress progress) async {
    await _box.put(_progressKey, progress.toMap());
  }

  @override
  Stream<UserProgress?> watch() async* {
    // 初回値を即時流す
    yield await load();

    // Hive の Box.watch() でキー変更を監視
    await for (final _ in _box.watch(key: _progressKey)) {
      yield await load();
    }
  }

  /// Box を閉じる（アプリ終了時に呼ぶ）
  Future<void> close() => _box.close();
}
