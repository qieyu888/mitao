import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 气泡膨胀回弹点赞按钮
class BubbleLikeButton extends StatefulWidget {
  const BubbleLikeButton({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.onToggle,
    this.iconSize = 22,
    this.showCount = true,
  });

  final bool isLiked;
  final int likeCount;
  final VoidCallback onToggle;
  final double iconSize;
  final bool showCount;

  @override
  State<BubbleLikeButton> createState() => _BubbleLikeButtonState();
}

class _BubbleLikeButtonState extends State<BubbleLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isLiked) {
      _controller.forward(from: 0);
    }
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isLiked ? AppColors.peach500 : AppColors.mocha500;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              widget.isLiked ? Icons.favorite : Icons.favorite_border,
              size: widget.iconSize,
              color: color,
            ),
          ),
          if (widget.showCount) ...[
            const SizedBox(width: 6),
            Text(
              widget.likeCount.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
