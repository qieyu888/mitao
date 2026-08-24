import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_info.dart';
import '../../theme/app_colors.dart';
import '../../widgets/page_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: const KawaiiAppBar(title: '关于我们'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
        children: [
          const _BrandHeader(),
          const SizedBox(height: 22),
          KawaiiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('我们在做什么'),
                const SizedBox(height: 10),
                Text(
                  '蜜桃想做一个轻松一点的生活社区：穿搭、下午茶、旅行、手帐……把日常里那些小确幸留下来。'
                  '这里不追求完美人设，更在意真实和舒服。',
                  style: _bodyStyle,
                ),
                const SizedBox(height: 18),
                _sectionTitle('这一版能做什么'),
                const SizedBox(height: 10),
                const _Bullet('逛发现频道，按兴趣刷内容'),
                const _Bullet('在萌友圈发动态、点赞和评论'),
                const _Bullet('收藏喜欢的内容，写自己的手帐'),
                const _Bullet('举报、拉黑、屏蔽，管好自己的时间线'),
                const SizedBox(height: 18),
                _sectionTitle('数据说明'),
                const SizedBox(height: 10),
                Text(
                  '当前版本以本地存储为主，资料和内容默认留在你的手机里。'
                  '注销账号会清空本机相关数据，操作前请先确认。',
                  style: _bodyStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          KawaiiCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _InfoRow(
                  label: '应用名称',
                  value: AppInfo.fullName,
                ),
                const Divider(height: 1, color: AppColors.cream200),
                const _InfoRow(
                  label: '当前版本',
                  value: AppInfo.version,
                ),
                const Divider(height: 1, color: AppColors.cream200),
                _InfoRow(
                  label: '意见反馈',
                  value: AppInfo.feedbackMail,
                  onTap: () => _copy(context, AppInfo.feedbackMail),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            AppInfo.slogan,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mocha400.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  static TextStyle get _bodyStyle => const TextStyle(
        fontSize: 14,
        height: 1.65,
        color: AppColors.mocha700,
      );

  static Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.mocha800,
      ),
    );
  }

  static Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    showKawaiiSnackBar(context, '已复制到剪贴板');
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.peach300, AppColors.peach500],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.peach500.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            '蜜',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          AppInfo.shortName,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.mocha800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppInfo.fullName,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.mocha400.withValues(alpha: 0.95),
          ),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 5, color: AppColors.peach500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.mocha700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.mocha500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: onTap != null ? AppColors.peach500 : AppColors.mocha800,
              ),
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            const Icon(Icons.copy, size: 14, color: AppColors.peach500),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: row,
    );
  }
}
