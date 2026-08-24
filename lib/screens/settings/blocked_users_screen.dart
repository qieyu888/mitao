import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/user_directory.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/page_widgets.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  Set<String> _blockedIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ids = await StorageService.instance.loadBlockedUsers();
    setState(() {
      _blockedIds = ids;
      _loading = false;
    });
  }

  Future<void> _unblock(String userId) async {
    _blockedIds.remove(userId);
    await StorageService.instance.saveBlockedUsers(_blockedIds);
    setState(() {});
    if (mounted) showKawaiiSnackBar(context, '已解除拉黑');
  }

  Future<FollowUser?> _findUser(String id) async {
    final feed = await StorageService.instance.loadFeedPosts();
    final diary = await StorageService.instance.loadDiaryPosts();
    return UserDirectory.lookup(id, posts: [...feed, ...diary]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: const KawaiiAppBar(title: '黑名单'),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.peach500),
            )
          : _blockedIds.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, size: 48, color: AppColors.mocha400),
                      SizedBox(height: 12),
                      Text(
                        '黑名单为空',
                        style: TextStyle(color: AppColors.mocha400),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _blockedIds.length,
                  itemBuilder: (context, index) {
                    final id = _blockedIds.elementAt(index);
                    return FutureBuilder<FollowUser?>(
                      future: _findUser(id),
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: KawaiiCard(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                AvatarCircle(
                                  char: user?.avatarChar ?? '?',
                                  gradientColors: user != null
                                      ? user.avatarGradientColors
                                          .map((c) => Color(c))
                                          .toList()
                                      : AppColors.avatarProfile,
                                  imageUrl: user?.avatarUrl ?? '',
                                  size: 44,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    user?.name ?? id,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mocha800,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _unblock(id),
                                  child: const Text(
                                    '解除',
                                    style: TextStyle(color: AppColors.peach500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
