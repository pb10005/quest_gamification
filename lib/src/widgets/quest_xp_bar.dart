import 'package:flutter/material.dart';
import '../models/user_progress.dart';

/// XP進捗バー
///
/// 現在レベル内のXP進捗をアニメーション付きで表示する。
///
/// ```dart
/// QuestXpBar(
///   progress: userProgress,
///   xpPerLevel: 100,
/// )
/// ```
class QuestXpBar extends StatefulWidget {
  final UserProgress progress;

  /// 1レベルあたりの必要XP（QuestConfig.xpPerLevel と合わせる）
  final int xpPerLevel;

  /// バーのアクセントカラー（省略時はテーマの primary を使用）
  final Color? color;

  /// バーの高さ
  final double height;

  /// ラベル表示するか
  final bool showLabel;

  const QuestXpBar({
    super.key,
    required this.progress,
    required this.xpPerLevel,
    this.color,
    this.height = 8,
    this.showLabel = true,
  });

  @override
  State<QuestXpBar> createState() => _QuestXpBarState();
}

class _QuestXpBarState extends State<QuestXpBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousRatio = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _previousRatio = widget.progress.levelProgress(widget.xpPerLevel);
    _animation = Tween(begin: 0.0, end: _previousRatio).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(QuestXpBar old) {
    super.didUpdateWidget(old);
    final newRatio = widget.progress.levelProgress(widget.xpPerLevel);
    if (newRatio != _previousRatio) {
      _animation = Tween(begin: _previousRatio, end: newRatio).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _previousRatio = newRatio;
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final xpInLevel = widget.progress.xpForCurrentLevel(widget.xpPerLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$xpInLevel / ${widget.xpPerLevel} XP',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${widget.progress.totalXp} XP total',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(widget.height),
              child: SizedBox(
                height: widget.height,
                child: LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
