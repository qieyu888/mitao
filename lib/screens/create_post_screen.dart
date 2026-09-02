import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/mock_data.dart';
import '../models/post.dart';
import '../models/user_profile.dart';
import '../services/image_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/post_image.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    super.key,
    required this.profile,
  });

  final UserProfile profile;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  final _picker = ImagePicker();
  int _selectedThemeIndex = 0;
  String? _localImagePath;
  bool _isSavingImage = false;

  static int _colorToInt(Color color) {
    final a = (color.a * 255.0).round() & 0xff;
    final r = (color.r * 255.0).round() & 0xff;
    final g = (color.g * 255.0).round() & 0xff;
    final b = (color.b * 255.0).round() & 0xff;
    return (a << 24) | (r << 16) | (g << 8) | b;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  String get _previewImageUrl {
    if (_localImagePath != null) return _localImagePath!;
    return MockData.postThemes[_selectedThemeIndex].imageUrl;
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (picked == null) return;

    setState(() => _isSavingImage = true);
    try {
      final saved = await ImageStorageService.savePostImage(File(picked.path));
      if (mounted) {
        setState(() {
          _localImagePath = saved;
          _isSavingImage = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSavingImage = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('图片读取失败，请重试'),
            backgroundColor: AppColors.peach500,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      }
    }
  }

  Post? _buildPost() {
    final content = _contentController.text.trim();
    if (content.isEmpty) return null;

    final theme = MockData.postThemes[_selectedThemeIndex];
    final id = 'post_${DateTime.now().millisecondsSinceEpoch}';

    return Post(
      id: id,
      authorId: widget.profile.userId,
      authorName: widget.profile.nickname,
      authorAvatarChar: widget.profile.avatarChar,
      avatarGradientColors: [0xFFFFC4D1, 0xFFFF6B8B],
      content: content,
      timeLabel: '刚刚',
      imageGradientColors: theme.colors.map(_colorToInt).toList(),
      imageIcon: theme.icon.codePoint,
      imageLabel: _localImagePath != null ? '相册' : theme.label,
      imageHeight: 240,
      likeCount: 0,
      commentCount: 0,
      category: '日常',
      title: content.length > 12 ? '${content.substring(0, 12)}...' : content,
      isMine: true,
      imageUrl: _previewImageUrl,
      avatarUrl: widget.profile.avatarUrl,
    );
  }

  void _publish() {
    final post = _buildPost();
    if (post == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('写点什么再发布吧'),
          backgroundColor: AppColors.peach500,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      return;
    }
    Navigator.of(context).pop(post);
  }

  @override
  Widget build(BuildContext context) {
    final theme = MockData.postThemes[_selectedThemeIndex];

    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: AppBar(
        backgroundColor: AppColors.cream50,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.mocha700),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '发布动态',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.mocha800,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSavingImage ? null : _publish,
            child: const Text(
              '发布',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.peach500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarCircle(
                  char: widget.profile.avatarChar,
                  gradientColors: AppColors.avatarProfile,
                  imageUrl: widget.profile.avatarUrl,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.profile.nickname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.mocha800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              maxLines: 5,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.mocha700,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                hintText: '分享你的甜美瞬间...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.mocha400),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: PostImage(
                    imageUrl: _previewImageUrl,
                    height: 220,
                    borderRadius: 0,
                    fallbackColors: theme.colors,
                    fallbackIcon: theme.icon,
                  ),
                ),
                if (_isSavingImage)
                  const CircularProgressIndicator(color: AppColors.peach500),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isSavingImage ? null : _pickFromGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(_localImagePath != null ? '更换相册图片' : '从相册选择图片'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.peach500,
                  side: const BorderSide(color: AppColors.peach500),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            if (_localImagePath != null) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _localImagePath = null),
                  child: const Text(
                    '清除相册图片，使用下方风格',
                    style: TextStyle(color: AppColors.mocha400, fontSize: 12),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              _localImagePath != null ? '备用卡片风格' : '选择卡片风格',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.mocha800,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MockData.postThemes.length,
                separatorBuilder: (_, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final option = MockData.postThemes[index];
                  final isSelected =
                      _localImagePath == null && index == _selectedThemeIndex;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedThemeIndex = index;
                      _localImagePath = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: option.colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: isSelected
                            ? Border.all(color: AppColors.peach500, width: 3)
                            : null,
                        boxShadow: isSelected ? KawaiiShadow.sm : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          option.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: option.colors),
                            ),
                            child: Icon(
                              option.icon,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 编辑个人资料弹窗
class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nicknameController;
  late TextEditingController _avatarController;
  late TextEditingController _bioController;
  final _picker = ImagePicker();
  String _avatarUrl = '';
  bool _isSavingAvatar = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.profile.nickname);
    _avatarController = TextEditingController(text: widget.profile.avatarChar);
    _bioController = TextEditingController(text: widget.profile.bio);
    _avatarUrl = widget.profile.avatarUrl;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _avatarController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 400,
    );
    if (picked == null) return;

    setState(() => _isSavingAvatar = true);
    try {
      final saved = await ImageStorageService.saveAvatarImage(File(picked.path));
      if (mounted) {
        setState(() {
          _avatarUrl = saved;
          _isSavingAvatar = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isSavingAvatar = false);
    }
  }

  void _save() {
    final nickname = _nicknameController.text.trim();
    var avatarChar = _avatarController.text.trim();
    if (nickname.isEmpty) return;
    if (avatarChar.isEmpty) avatarChar = nickname.substring(0, 1);

    Navigator.of(context).pop(
      widget.profile.copyWith(
        nickname: nickname,
        avatarChar: avatarChar.substring(0, 1),
        avatarUrl: _avatarUrl,
        bio: _bioController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '编辑资料',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.mocha800,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: _isSavingAvatar ? null : _pickAvatar,
              child: Stack(
                children: [
                  AvatarCircle(
                    char: _avatarController.text.isNotEmpty
                        ? _avatarController.text.substring(0, 1)
                        : widget.profile.avatarChar,
                    gradientColors: AppColors.avatarProfile,
                    imageUrl: _avatarUrl,
                    size: 72,
                    fontSize: 24,
                  ),
                  if (_isSavingAvatar)
                    const Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.peach500,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.peach500,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              '点击头像从相册选择',
              style: TextStyle(fontSize: 12, color: AppColors.mocha400),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: '昵称',
              labelStyle: TextStyle(color: AppColors.mocha500),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bioController,
            maxLength: 40,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: '个性签名',
              labelStyle: TextStyle(color: AppColors.mocha500),
              hintText: '写一句关于自己的话',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _avatarController,
            maxLength: 1,
            decoration: const InputDecoration(
              labelText: '头像文字（无图片时显示）',
              labelStyle: TextStyle(color: AppColors.mocha500),
              counterText: '',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.peach500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: const Text(
                '保存',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
