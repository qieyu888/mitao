import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../app_info.dart';
import '../../theme/app_colors.dart';
import '../../widgets/action_sheets.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/page_widgets.dart';
import '../create_post_screen.dart';
import 'about_screen.dart';
import 'blocked_users_screen.dart';
import 'policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.profile,
    required this.blockedCount,
    required this.onProfileUpdated,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final UserProfile profile;
  final int blockedCount;
  final ValueChanged<UserProfile> onProfileUpdated;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  Future<void> _editProfile(BuildContext context) async {
    final result = await showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileSheet(profile: profile),
    );
    if (result != null) onProfileUpdated(result);
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await confirmLogout(context);
    if (confirmed) onLogout();
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final confirmed = await confirmDeleteAccount(context);
    if (confirmed) onDeleteAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: const KawaiiAppBar(title: '设置'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          KawaiiCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AvatarCircle(
                  char: profile.avatarChar,
                  gradientColors: AppColors.avatarProfile,
                  imageUrl: profile.avatarUrl,
                  size: 56,
                  fontSize: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.nickname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.mocha800,
                        ),
                      ),
                      Text(
                        'ID: ${profile.userId}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mocha400,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _editProfile(context),
                  child: const Text(
                    '编辑',
                    style: TextStyle(
                      color: AppColors.peach500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          KawaiiCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SettingsTile(
              icon: Icons.block,
              title: '黑名单管理',
              subtitle: blockedCount > 0 ? '$blockedCount 位用户' : '暂无拉黑',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BlockedUsersScreen(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          KawaiiCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: '隐私政策',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PolicyScreen(kind: PolicyKind.privacy),
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.cream200),
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: '用户协议',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PolicyScreen(kind: PolicyKind.terms),
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.cream200),
                SettingsTile(
                  icon: Icons.info_outline,
                  title: '关于我们',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          KawaiiCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                SettingsTile(
                  icon: Icons.logout,
                  title: '退出登录',
                  iconColor: AppColors.mocha500,
                  onTap: () => _handleLogout(context),
                ),
                const Divider(height: 1, color: AppColors.cream200),
                SettingsTile(
                  icon: Icons.delete_forever_outlined,
                  title: '注销账号',
                  subtitle: '清除所有本地数据',
                  iconColor: Colors.redAccent,
                  titleColor: Colors.redAccent,
                  onTap: () => _handleDeleteAccount(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '${AppInfo.shortName} v${AppInfo.version}',
              style: const TextStyle(color: AppColors.mocha400, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
