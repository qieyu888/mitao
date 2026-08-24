import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'post_cover.dart';

/// 双列瀑布流布局
class WaterfallGrid extends StatelessWidget {
  const WaterfallGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.padding = EdgeInsets.zero,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final leftItems = <int>[];
    final rightItems = <int>[];
    for (var i = 0; i < itemCount; i++) {
      if (i.isEven) {
        leftItems.add(i);
      } else {
        rightItems.add(i);
      }
    }

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                for (var i = 0; i < leftItems.length; i++) ...[
                  itemBuilder(context, leftItems[i]),
                  if (i < leftItems.length - 1) SizedBox(height: mainAxisSpacing),
                ],
              ],
            ),
          ),
          SizedBox(width: crossAxisSpacing),
          Expanded(
            child: Column(
              children: [
                for (var i = 0; i < rightItems.length; i++) ...[
                  itemBuilder(context, rightItems[i]),
                  if (i < rightItems.length - 1) SizedBox(height: mainAxisSpacing),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 收藏页卡片
class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.post,
    this.onTap,
    this.onRemove,
  });

  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: KawaiiShadow.sm,
        ),
        padding: const EdgeInsets.all(6),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: PostCover(post: post, borderRadius: 0),
                ),
                if (post.title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                    child: Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mocha800,
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                    boxShadow: KawaiiShadow.sm,
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    size: 16,
                    color: AppColors.peach500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 手帐网格卡片
class DiaryCard extends StatelessWidget {
  const DiaryCard({
    super.key,
    required this.post,
    this.onTap,
  });

  final Post post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: KawaiiShadow.sm,
        ),
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: PostCover(
            post: post,
            borderRadius: 0,
          ),
        ),
      ),
    );
  }
}

/// 新建手帐引导卡片
class NewDiaryCard extends StatelessWidget {
  const NewDiaryCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 160),
        decoration: BoxDecoration(
          color: AppColors.cream100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: KawaiiShadow.sm,
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 36,
            color: AppColors.peach300,
          ),
        ),
      ),
    );
  }
}
