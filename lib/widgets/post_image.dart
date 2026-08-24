import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/local_image.dart';

/// 帖子/手帐网络图片（Image.network，无 cached_network_image）
class PostImage extends StatelessWidget {
  const PostImage({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.borderRadius = 20,
    this.fit = BoxFit.cover,
    this.fallbackColors = AppColors.gradientOotd,
    this.fallbackIcon = Icons.image_outlined,
  });

  final String imageUrl;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final List<Color> fallbackColors;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _FallbackBox(
        height: height,
        borderRadius: borderRadius,
        colors: fallbackColors,
        icon: fallbackIcon,
      );
    }

    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 3.0);
    final cacheWidth = (MediaQuery.sizeOf(context).width * dpr).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: FlexibleImage(
          imageUrl: imageUrl,
          fit: fit,
          height: height,
          width: double.infinity,
          cacheWidth: cacheWidth,
          errorBuilder: (context, error, stackTrace) => _FallbackBox(
            height: height,
            borderRadius: 0,
            colors: fallbackColors,
            icon: fallbackIcon,
          ),
        ),
      ),
    );
  }
}

class _FallbackBox extends StatelessWidget {
  const _FallbackBox({
    required this.height,
    required this.borderRadius,
    required this.colors,
    required this.icon,
    this.showProgress = false,
    this.progress,
  });

  final double height;
  final double borderRadius;
  final List<Color> colors;
  final IconData icon;
  final bool showProgress;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: showProgress
            ? CircularProgressIndicator(
                value: progress,
                color: AppColors.peach500,
                strokeWidth: 2,
              )
            : Icon(icon, color: Colors.white70, size: 36),
      ),
    );
  }
}
