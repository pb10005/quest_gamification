import '../models/user_progress.dart';

/// ユーザー進捗の永続化インターフェース
///
/// Firestore / Hive / SQLite など任意の実装を注入できる。
/// テスト用には [InMemoryProgressRepository] を使用する。
abstract class ProgressRepository {
  /// ユーザーの進捗を取得する
  Future<UserProgress?> load();

  /// ユーザーの進捗を保存する
  Future<void> save(UserProgress progress);

  /// 進捗の変更をリアルタイムで監視する（実装任意）
  Stream<UserProgress?> watch() => const Stream.empty();
}

/// テスト・デモ用のインメモリ実装
class InMemoryProgressRepository implements ProgressRepository {
  UserProgress? _stored;

  @override
  Future<UserProgress?> load() async => _stored;

  @override
  Future<void> save(UserProgress progress) async {
    _stored = progress;
  }

  @override
  Stream<UserProgress?> watch() async* {
    yield _stored;
  }
}
