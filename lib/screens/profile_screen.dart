import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/waterfall_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.diaryPosts,
    required this.onEditProfile,
    required this.onCreatePost,
    required this.onOpenSettings,
    required this.onOpenFollowing,
    required this.onOpenFollowers,
    required this.onDiaryTap,
  });

  final UserProfile profile;
  final List<Post> diaryPosts;
  final VoidCallback onEditProfile;
  final VoidCallback onCreatePost;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenFollowing;
  final VoidCallback onOpenFollowers;
  final void Function(Post post) onDiaryTap;

  String _formatStat(int value) {
    if (value >= 10000) {
      return '${(value / 10000).toStringAsFixed(1)}w';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
            boxShadow: KawaiiShadow.sm,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onOpenSettings,
                    icon: const Icon(Icons.settings_outlined,
                        color: AppColors.mocha500),
                  ),
                ],
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AvatarCircle(
                    char: profile.avatarChar,
                    gradientColors: AppColors.avatarProfile,
                    imageUrl: profile.avatarUrl,
                    size: 96,
                    fontSize: 32,
                    borderWidth: 4,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: onEditProfile,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.peach500,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit,
                            size: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                profile.nickname,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mocha800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${profile.userId}',
                style: const TextStyle(fontSize: 13, color: AppColors.mocha400),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onOpenFollowing,
                    child: _StatItem(
                      value: _formatStat(profile.followingCount),
                      label: '关注',
                    ),
                  ),
                  _divider(),
                  GestureDetector(
                    onTap: onOpenFollowers,
                    child: _StatItem(
                      value: _formatStat(profile.followersCount),
                      label: '粉丝',
                    ),
                  ),
                  _divider(),
                  _StatItem(
                    value: _formatStat(profile.likesCount),
                    label: '获赞',
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '我的手帐',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mocha800,
                ),
              ),
              const SizedBox(height: 16),
              WaterfallGrid(
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                itemCount: diaryPosts.length + 1,
                itemBuilder: (context, index) {
                  if (index == diaryPosts.length) {
                    return NewDiaryCard(onTap: onCreatePost);
                  }
                  return DiaryCard(
                    post: diaryPosts[index],
                    onTap: () => onDiaryTap(diaryPosts[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      color: AppColors.cream200,
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.mocha800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.mocha500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
