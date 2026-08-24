import 'package:flutter/material.dart';

import '../../models/comment.dart';
import '../../models/post.dart';
import '../../theme/app_colors.dart';
import '../../widgets/page_widgets.dart';
import '../../widgets/post_cover.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, required this.post});

  final Post post;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? _selectedReason;
  final _detailController = TextEditingController();

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedReason == null) {
      showKawaiiSnackBar(context, '请选择举报原因');
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: const KawaiiAppBar(title: '举报内容'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          KawaiiCard(
            child: Row(
              children: [
                PostThumbnail(post: widget.post, size: 48, borderRadius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${widget.post.authorName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.post.content.isNotEmpty
                            ? widget.post.content
                            : widget.post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.mocha500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '请选择举报原因',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.mocha800,
            ),
          ),
          const SizedBox(height: 12),
          ...ReportReason.all.map((reason) {
            final selected = _selectedReason == reason.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _selectedReason = reason.id),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.peach500.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? AppColors.peach500
                            : AppColors.cream200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selected
                              ? AppColors.peach500
                              : AppColors.mocha400,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          reason.label,
                          style: TextStyle(
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                            color: AppColors.mocha800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          TextField(
            controller: _detailController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '补充说明（选填）',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.peach500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
                '提交举报',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
