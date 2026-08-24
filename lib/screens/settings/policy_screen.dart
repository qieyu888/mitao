import 'package:flutter/material.dart';

import '../../data/legal_copy.dart';
import '../../theme/app_colors.dart';
import '../../widgets/page_widgets.dart';

enum PolicyKind { privacy, terms }

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({
    super.key,
    required this.kind,
  });

  final PolicyKind kind;

  String get _title => kind == PolicyKind.privacy ? '隐私政策' : '用户协议';

  String get _body => kind == PolicyKind.privacy ? LegalCopy.privacy : LegalCopy.terms;

  @override
  Widget build(BuildContext context) {
    final blocks = _splitBlocks(_body);

    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: KawaiiAppBar(title: _title),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.peach500.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: AppColors.peach500),
                const SizedBox(width: 8),
                Text(
                  '更新日期：${LegalCopy.updatedAt}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.peach500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          KawaiiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < blocks.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  _PolicyBlock(text: blocks[i]),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '如有疑问，可前往「关于我们」查看反馈方式。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.mocha400),
          ),
        ],
      ),
    );
  }

  /// 按空行切成段落，方便阅读
  static List<String> _splitBlocks(String raw) {
    return raw
        .trim()
        .split(RegExp(r'\n\s*\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .where((e) => !e.startsWith('更新日期') && !e.startsWith('生效日期'))
        .toList();
  }
}

class _PolicyBlock extends StatelessWidget {
  const _PolicyBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    final first = lines.first.trim();
    final looksLikeHeading = RegExp(r'^\d+\.').hasMatch(first);

    if (!looksLikeHeading || lines.length == 1) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.75,
          color: AppColors.mocha700,
        ),
      );
    }

    final rest = lines.skip(1).join('\n').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          first,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.mocha800,
            height: 1.4,
          ),
        ),
        if (rest.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            rest,
            style: const TextStyle(
              fontSize: 14,
              height: 1.75,
              color: AppColors.mocha700,
            ),
          ),
        ],
      ],
    );
  }
}
