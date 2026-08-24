import 'package:flutter/material.dart';

import '../../models/comment.dart';
import '../../models/post.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/action_sheets.dart';
import '../../widgets/bubble_like_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/post_cover.dart';
import '../../widgets/page_widgets.dart';
import '../profile/user_profile_screen.dart';
import 'report_screen.dart';

typedef PostUpdater = Post Function(Post post);
typedef PostDetailCallback = void Function(Post post);

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    super.key,
    required this.post,
    required this.comments,
    required this.onLikeToggle,
    required this.onFavoriteToggle,
    required this.onReport,
    required this.onBlock,
    this.onHide,
    required this.onAddComment,
    required this.resolveComments,
  });

  final Post post;
  final List<Comment> comments;
  final PostUpdater onLikeToggle;
  final PostUpdater onFavoriteToggle;
  final PostDetailCallback onReport;
  final PostDetailCallback onBlock;
  final PostDetailCallback? onHide;
  final Post Function(Post post, String content) onAddComment;
  final List<Comment> Function(String postId) resolveComments;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Post _post;
  late List<Comment> _comments;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.comments);
    _post = widget.post;
    if (_comments.length != _post.commentCount) {
      _post = _post.copyWith(commentCount: _comments.length);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _showActions() async {
    final action = await showPostActionSheet(context, post: _post);
    if (!mounted || action == null) return;

    if (action == 'report') {
      final reported = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => ReportScreen(post: _post),
        ),
      );
      if (reported == true) {
        widget.onReport(_post);
        if (mounted) {
          showKawaiiSnackBar(context, '举报已提交，感谢反馈');
          Navigator.pop(context);
        }
      }
    } else if (action == 'block') {
      final confirmed = await confirmBlockUser(context, _post.authorName);
      if (confirmed) {
        widget.onBlock(_post);
        if (mounted) {
          showKawaiiSnackBar(context, '已拉黑 ${_post.authorName}');
          Navigator.pop(context);
        }
      }
    } else if (action == 'hide') {
      widget.onHide?.call(_post);
      if (mounted) {
        showKawaiiSnackBar(context, '已屏蔽该动态');
        Navigator.pop(context);
      }
    }
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    final updated = widget.onAddComment(_post, text);
    setState(() {
      _post = updated;
      _comments = widget.resolveComments(_post.id);
    });
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: KawaiiAppBar(
        title: _post.title.isNotEmpty ? _post.title : '详情',
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.mocha500),
            onPressed: _showActions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                GestureDetector(
                  onTap: () {
                    if (_post.isMine) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserProfileScreen(
                          authorId: _post.authorId,
                          authorName: _post.authorName,
                          authorAvatarChar: _post.authorAvatarChar,
                          avatarGradientColors: _post.avatarGradientColors,
                          avatarUrl: _post.avatarUrl,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      AvatarCircle(
                        char: _post.authorAvatarChar,
                        gradientColors: _post.avatarGradient,
                        imageUrl: _post.avatarUrl,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${_post.authorName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.mocha800,
                              ),
                            ),
                            Text(
                              _post.timeLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.mocha400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_post.category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.peach500.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _post.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.peach500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_post.content.isNotEmpty)
                  Text(
                    _post.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.mocha700,
                      height: 1.6,
                    ),
                  ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: PostCover(
                    post: _post,
                    height: 280,
                    borderRadius: 0,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    BubbleLikeButton(
                      isLiked: _post.isLiked,
                      likeCount: _post.likeCount,
                      onToggle: () {
                        setState(() => _post = widget.onLikeToggle(_post));
                      },
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () {
                        setState(() => _post = widget.onFavoriteToggle(_post));
                      },
                      child: Row(
                        children: [
                          Icon(
                            _post.isFavorited
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: _post.isFavorited
                                ? AppColors.peach500
                                : AppColors.mocha500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _post.isFavorited ? '已收藏' : '收藏',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _post.isFavorited
                                  ? AppColors.peach500
                                  : AppColors.mocha500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  '评论 (${_comments.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (_comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '还没有评论，来说点什么吧～',
                        style: TextStyle(color: AppColors.mocha400),
                      ),
                    ),
                  )
                else
                  ..._comments.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarCircle(
                            char: c.authorAvatarChar,
                            gradientColors: c.avatarGradientColors
                                .map((e) => Color(e))
                                .toList(),
                            imageUrl: c.avatarUrl,
                            size: 36,
                            fontSize: 12,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: KawaiiShadow.sm,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        c.authorName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.mocha800,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        c.timeLabel,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.mocha400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.content,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.mocha700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.peach500.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '写评论...',
                      filled: true,
                      fillColor: AppColors.cream100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _submitComment,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.peach500,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
