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
    required this.favoriteCount,
    required this.onEditProfile,
    required this.onCreatePost,
    required this.onOpenSettings,
    required this.onOpenFollowing,
    required this.onOpenFollowers,
    required this.onDiaryTap,
  });

  final UserProfile profile;
  final List<Post> diaryPosts;
  final int favoriteCount;
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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            boxShadow: KawaiiShadow.sm,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onOpenSettings,
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.mocha500,
                  ),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.peach300, AppColors.peach500],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.peach500.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: AvatarCircle(
                      char: profile.avatarChar,
                      gradientColors: AppColors.avatarProfile,
                      imageUrl: profile.avatarUrl,
                      size: 88,
                      fontSize: 30,
                      borderWidth: 3,
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
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
                        child: const Icon(
                          Icons.edit,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                profile.nickname,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mocha800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID · ${profile.userId}',
                style: const TextStyle(fontSize: 12, color: AppColors.mocha400),
              ),
              if (profile.bio.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    profile.bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.mocha500,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ActionChip(
                      icon: Icons.edit_outlined,
                      label: '编辑资料',
                      onTap: onEditProfile,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionChip(
                      icon: Icons.add_circle_outline,
                      label: '写手帐',
                      filled: true,
                      onTap: onCreatePost,
                    ),
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
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '我的手帐',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mocha800,
                      ),
                    ),
                  ),
                  Text(
                    '${diaryPosts.length} 篇',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.mocha400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _MiniStatCard(
                    icon: Icons.auto_stories_outlined,
                    label: '手帐',
                    value: '${diaryPosts.length}',
                  ),
                  const SizedBox(width: 10),
                  _MiniStatCard(
                    icon: Icons.favorite_border,
                    label: '获赞',
                    value: _formatStat(profile.likesCount),
                  ),
                  const SizedBox(width: 10),
                  _MiniStatCard(
                    icon: Icons.bookmark_border,
                    label: '收藏',
                    value: '$favoriteCount',
                  ),
                ],
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
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 28),
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

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: filled ? AppColors.peach500 : AppColors.cream100,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: filled ? Colors.white : AppColors.mocha700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: filled ? Colors.white : AppColors.mocha700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: KawaiiShadow.sm,
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.peach500),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.mocha800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.mocha400),
            ),
          ],
        ),
      ),
    );
  }
}
