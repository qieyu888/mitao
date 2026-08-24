import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'action_sheets.dart';
import 'bubble_like_button.dart';
import 'common_widgets.dart';
import 'post_cover.dart';

/// 萌友圈动态大卡片
class FeedPostCard extends StatelessWidget {
  const FeedPostCard({
    super.key,
    required this.post,
    required this.onLikeToggle,
    required this.onFavoriteToggle,
    this.onTap,
    this.onReport,
    this.onBlock,
    this.onHide,
  });

  final Post post;
  final VoidCallback onLikeToggle;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;
  final VoidCallback? onReport;
  final VoidCallback? onBlock;
  final VoidCallback? onHide;

  Future<void> _showActions(BuildContext context) async {
    final action = await showPostActionSheet(context, post: post);
    if (action == 'report') {
      onReport?.call();
    } else if (action == 'block') {
      onBlock?.call();
    } else if (action == 'hide') {
      onHide?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: KawaiiShadow.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
              AvatarCircle(
                char: post.authorAvatarChar,
                gradientColors: post.avatarGradient,
                imageUrl: post.avatarUrl,
              ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${post.authorName}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        post.timeLabel,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showActions(context),
                  icon: const Icon(Icons.more_horiz, color: AppColors.mocha400),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: PostCover(
                post: post,
                borderRadius: 0,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                BubbleLikeButton(
                  isLiked: post.isLiked,
                  likeCount: post.likeCount,
                  onToggle: onLikeToggle,
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 22,
                      color: AppColors.mocha500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.commentCount.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mocha500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Icon(
                    post.isFavorited ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: post.isFavorited
                        ? AppColors.peach500
                        : AppColors.mocha500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
