import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_colors.dart';
import '../widgets/waterfall_widgets.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.posts,
    required this.onRemoveFavorite,
    required this.onPostTap,
  });

  final List<Post> posts;
  final void Function(Post post) onRemoveFavorite;
  final void Function(Post post) onPostTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('我的收藏库', style: Theme.of(context).textTheme.titleLarge),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.peach500.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                '共 ${posts.length} 篇',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mocha400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (posts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                '收藏夹还是空的，去发现页逛逛吧',
                style: TextStyle(color: AppColors.mocha400),
              ),
            ),
          )
        else
          WaterfallGrid(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return GestureDetector(
                onTap: () => onPostTap(post),
                child: FavoriteCard(
                  post: post,
                  onRemove: () => onRemoveFavorite(post),
                ),
              );
            },
          ),
      ],
    );
  }
}
