import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bubble_like_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/post_cover.dart';
import '../../widgets/page_widgets.dart';

class DiaryDetailScreen extends StatelessWidget {
  const DiaryDetailScreen({
    super.key,
    required this.post,
    required this.onDelete,
  });

  final Post post;
  final VoidCallback onDelete;

  Future<void> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('删除手帐'),
        content: const Text('确定要删除这篇手帐吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (result == true) {
      onDelete();
      if (context.mounted) {
        showKawaiiSnackBar(context, '手帐已删除');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: KawaiiAppBar(
        title: post.title.isNotEmpty ? post.title : '手帐详情',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: PostCover(
              post: post,
              height: 300,
              borderRadius: 0,
            ),
          ),
          const SizedBox(height: 20),
          KawaiiCard(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          post.timeLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mocha400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.mocha700,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                BubbleLikeButton(
                  isLiked: post.isLiked,
                  likeCount: post.likeCount,
                  onToggle: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
