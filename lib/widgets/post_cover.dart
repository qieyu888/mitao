import 'package:flutter/material.dart';

import '../models/post.dart';
import '../utils/local_image.dart';
import 'post_image.dart';

/// 帖子图片（优先网络图，兼容旧数据渐变兜底）
class PostCover extends StatelessWidget {
  const PostCover({
    super.key,
    required this.post,
    this.height,
    this.borderRadius = 20,
    this.fit = BoxFit.cover,
  });

  final Post post;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return PostImage(
      imageUrl: post.imageUrl,
      height: height ?? post.imageHeight,
      borderRadius: borderRadius,
      fit: fit,
      fallbackColors: post.imageGradient,
      fallbackIcon: post.icon,
    );
  }
}

/// 小缩略图（搜索/举报等）
class PostThumbnail extends StatelessWidget {
  const PostThumbnail({
    super.key,
    required this.post,
    this.size = 56,
    this.borderRadius = 14,
  });

  final Post post;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (post.imageUrl.isEmpty) {
      return _gradientThumb();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: FlexibleImage(
          imageUrl: post.imageUrl,
          fit: BoxFit.cover,
          width: size,
          height: size,
          cacheWidth: (size * 2).round(),
          errorBuilder: (context, error, stackTrace) => _gradientThumb(),
        ),
      ),
    );
  }

  Widget _gradientThumb() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: post.imageGradient),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(post.icon, color: Colors.white70, size: size * 0.4),
    );
  }
}
