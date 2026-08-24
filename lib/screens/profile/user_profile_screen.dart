import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/post.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/post_cover.dart';
import '../../widgets/page_widgets.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    super.key,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarChar,
    required this.avatarGradientColors,
    this.avatarUrl = '',
    this.posts = const [],
    this.onPostTap,
    this.onBlock,
  });

  final String authorId;
  final String authorName;
  final String authorAvatarChar;
  final List<int> avatarGradientColors;
  final String avatarUrl;
  final List<Post> posts;
  final void Function(Post post)? onPostTap;
  final VoidCallback? onBlock;

  @override
  Widget build(BuildContext context) {
    final userPosts = posts.isNotEmpty
        ? posts
        : <Post>[
            ...MockData.discoverPosts,
            ...MockData.feedPosts,
          ].where((p) => p.authorId == authorId).toList();

    final totalLikes =
        userPosts.fold<int>(0, (sum, post) => sum + post.likeCount);
    final totalComments =
        userPosts.fold<int>(0, (sum, post) => sum + post.commentCount);

    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: KawaiiAppBar(
        title: '用户主页',
        actions: [
          if (onBlock != null)
            IconButton(
              icon: const Icon(Icons.block, color: AppColors.mocha500),
              onPressed: onBlock,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: KawaiiShadow.sm,
            ),
            child: Column(
              children: [
                AvatarCircle(
                  char: authorAvatarChar,
                  gradientColors:
                      avatarGradientColors.map((c) => Color(c)).toList(),
                  imageUrl: avatarUrl,
                  size: 80,
                  fontSize: 28,
                ),
                const SizedBox(height: 12),
                Text(
                  '@$authorName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mocha800,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _miniStat('${userPosts.length}', '作品'),
                    _miniStat('$totalLikes', '获赞'),
                    _miniStat('$totalComments', '评论'),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.peach500,
                      side: const BorderSide(color: AppColors.peach500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      '+ 关注',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ta 的作品',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.mocha800,
            ),
          ),
          const SizedBox(height: 12),
          if (userPosts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('暂无作品', style: TextStyle(color: AppColors.mocha400)),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                final post = userPosts[index];
                return GestureDetector(
                  onTap: () => onPostTap?.call(post),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: KawaiiShadow.sm,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: AspectRatio(
                      aspectRatio: 0.75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: post.imageUrl.isNotEmpty
                            ? PostCover(
                                post: post,
                                borderRadius: 0,
                              )
                            : PostCover(
                                post: post,
                                borderRadius: 0,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: AppColors.mocha800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.mocha400),
          ),
        ],
      ),
    );
  }
}
