import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/page_widgets.dart';

typedef FollowToggleCallback = void Function(String userId, bool follow);

class FollowListScreen extends StatefulWidget {
  const FollowListScreen({
    super.key,
    required this.title,
    required this.users,
    required this.isFollowingList,
    this.followingIds = const {},
    this.onFollowToggle,
  });

  final String title;
  final List<FollowUser> users;
  final bool isFollowingList;
  final Set<String> followingIds;
  final FollowToggleCallback? onFollowToggle;

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  late List<FollowUser> _users;
  late Set<String> _followingIds;

  @override
  void initState() {
    super.initState();
    _users = List<FollowUser>.from(widget.users);
    _followingIds = Set<String>.from(widget.followingIds);
    if (widget.isFollowingList) {
      _followingIds = _users.map((u) => u.id).toSet();
    }
  }

  bool _isFollowing(FollowUser user) =>
      widget.isFollowingList || _followingIds.contains(user.id);

  void _toggleFollow(FollowUser user) {
    final currentlyFollowing = _isFollowing(user);
    final nextFollow = !currentlyFollowing;
    widget.onFollowToggle?.call(user.id, nextFollow);

    setState(() {
      if (nextFollow) {
        _followingIds.add(user.id);
      } else {
        _followingIds.remove(user.id);
        if (widget.isFollowingList) {
          _users.removeWhere((u) => u.id == user.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: KawaiiAppBar(title: widget.title),
      body: _users.isEmpty
          ? Center(
              child: Text(
                widget.isFollowingList ? '还没有关注任何人' : '暂无粉丝',
                style: const TextStyle(color: AppColors.mocha400),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final isFollowing = _isFollowing(user);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: KawaiiCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        AvatarCircle(
                          char: user.avatarChar,
                          gradientColors: user.avatarGradientColors
                              .map((c) => Color(c))
                              .toList(),
                          imageUrl: user.avatarUrl,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mocha800,
                                ),
                              ),
                              if (user.bio.isNotEmpty)
                                Text(
                                  user.bio,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.mocha400,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: widget.onFollowToggle == null
                              ? null
                              : () => _toggleFollow(user),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isFollowing
                                ? AppColors.mocha400
                                : AppColors.peach500,
                            side: BorderSide(
                              color: isFollowing
                                  ? AppColors.mocha400
                                  : AppColors.peach500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                          ),
                          child: Text(
                            isFollowing ? '已关注' : '+ 关注',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
