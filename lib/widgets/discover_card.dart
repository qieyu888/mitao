import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'post_cover.dart';
import 'common_widgets.dart';

/// 发现页推荐卡片
class DiscoverCard extends StatelessWidget {
  const DiscoverCard({
    super.key,
    required this.post,
    this.onTap,
    this.onFavorite,
  });

  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

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
                  child: PostCover(
                    post: post,
                    borderRadius: 0,
                  ),
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
              bottom: post.title.isNotEmpty ? 36 : 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: KawaiiShadow.sm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, size: 12, color: AppColors.peach500),
                    const SizedBox(width: 4),
                    Text(
                      formatCount(post.likeCount),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mocha800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (onFavorite != null)
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                      boxShadow: KawaiiShadow.sm,
                    ),
                    child: Icon(
                      post.isFavorited ? Icons.bookmark : Icons.bookmark_border,
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
