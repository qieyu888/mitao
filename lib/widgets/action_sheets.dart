import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_colors.dart';

/// 帖子操作菜单：举报 / 拉黑
Future<String?> showPostActionSheet(
  BuildContext context, {
  required Post post,
  bool showBlock = true,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cream200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '@${post.authorName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.mocha800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    post.timeLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mocha400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: AppColors.peach500),
              title: const Text('举报内容', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context, 'report'),
            ),
            if (showBlock && !post.isMine)
              ListTile(
                leading: const Icon(Icons.block, color: AppColors.mocha500),
                title: const Text('拉黑用户', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('不再看到 ${post.authorName} 的内容'),
                onTap: () => Navigator.pop(context, 'block'),
              ),
            if (!post.isMine)
              ListTile(
                leading: const Icon(Icons.visibility_off_outlined,
                    color: AppColors.mocha500),
                title: const Text('屏蔽动态', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('不再显示这条内容'),
                onTap: () => Navigator.pop(context, 'hide'),
              ),
            ListTile(
              leading: const Icon(Icons.close, color: AppColors.mocha400),
              title: const Text('取消'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

Future<bool> confirmBlockUser(BuildContext context, String userName) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('确认拉黑'),
      content: Text('拉黑后将不再看到「$userName」的内容，确定吗？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消', style: TextStyle(color: AppColors.mocha400)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('确认拉黑', style: TextStyle(color: AppColors.peach500)),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<bool> confirmLogout(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('退出登录'),
      content: const Text('退出后需重新同意协议才能进入，本地数据会保留。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消', style: TextStyle(color: AppColors.mocha400)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('退出', style: TextStyle(color: AppColors.peach500)),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<bool> confirmDeleteAccount(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('注销账号'),
      content: const Text(
        '注销后所有本地数据将被清除且不可恢复，包括手帐、收藏和发布内容。确定注销吗？',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消', style: TextStyle(color: AppColors.mocha400)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('确认注销', style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    ),
  );
  return result ?? false;
}
