import 'dart:async';
import '../models/user_progress.dart';
import 'progress_repository.dart';

/// Firestore ドキュメントの読み取り関数型
typedef FirestoreDocumentReader = Future<Map<String, dynamic>?> Function();

/// Firestore ドキュメントへの書き込み関数型
typedef FirestoreDocumentWriter = Future<void> Function(
    Map<String, dynamic> data);

/// Firestore ドキュメントのリアルタイム監視ストリーム型
typedef FirestoreDocumentStream = Stream<Map<String, dynamic>?> Function();

/// Firestore を使った進捗永続化アダプタ
///
/// `cloud_firestore` を直接依存しないコールバック設計のため、
/// どのバージョンの Firestore とも連携可能。
///
/// ## セットアップ例（FitQuest）
///
/// ```dart
/// import 'package:cloud_firestore/cloud_firestore.dart';
///
/// final doc = FirebaseFirestore.instance
///     .collection('users')
///     .doc(uid)
///     .collection('gamification')
///     .doc('progress');
///
/// final adapter = FirestoreProgressAdapter(
///   reader: () async {
///     final snap = await doc.get();
///     return snap.data();
///   },
///   writer: (data) => doc.set(data, SetOptions(merge: true)),
///   streamer: () => doc.snapshots().map((s) => s.data()),
/// );
/// ```
class FirestoreProgressAdapter implements ProgressRepository {
  final FirestoreDocumentReader reader;
  final FirestoreDocumentWriter writer;
  final FirestoreDocumentStream? streamer;

  const FirestoreProgressAdapter({
    required this.reader,
    required this.writer,
    this.streamer,
  });

  @override
  Future<UserProgress?> load() async {
    final data = await reader();
    if (data == null) return null;
    return UserProgress.fromMap(data);
  }

  @override
  Future<void> save(UserProgress progress) => writer(progress.toMap());

  @override
  Stream<UserProgress?> watch() {
    if (streamer == null) return const Stream.empty();
    return streamer!().map(
      (data) => data != null ? UserProgress.fromMap(data) : null,
    );
  }
}
