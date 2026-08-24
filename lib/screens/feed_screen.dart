import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_colors.dart';
import '../widgets/feed_post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({
    super.key,
    required this.posts,
    required this.onLikeToggle,
    required this.onFavoriteToggle,
    required this.onCreatePost,
    required this.onPostTap,
    required this.onReport,
    required this.onBlock,
    required this.onHide,
  });

  final List<Post> posts;
  final void Function(Post post) onLikeToggle;
  final void Function(Post post) onFavoriteToggle;
  final VoidCallback onCreatePost;
  final void Function(Post post) onPostTap;
  final void Function(Post post) onReport;
  final void Function(Post post) onBlock;
  final void Function(Post post) onHide;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('萌友圈', style: Theme.of(context).textTheme.titleLarge),
            GestureDetector(
              onTap: onCreatePost,
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.peach500,
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (posts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                '还没有动态，快去发布吧',
                style: TextStyle(color: AppColors.mocha400),
              ),
            ),
          )
        else
          ...posts.map(
            (post) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FeedPostCard(
                post: post,
                onLikeToggle: () => onLikeToggle(post),
                onFavoriteToggle: () => onFavoriteToggle(post),
                onTap: () => onPostTap(post),
                onReport: () => onReport(post),
                onBlock: () => onBlock(post),
                onHide: () => onHide(post),
              ),
            ),
          ),
      ],
    );
  }
}
