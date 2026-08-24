import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/local_image.dart';
import '../theme/app_theme.dart';

/// 渐变色块 + 矢量图标占位
class GradientPlaceholder extends StatelessWidget {
  const GradientPlaceholder({
    super.key,
    required this.colors,
    required this.icon,
    this.label = '',
    this.height = 200,
    this.borderRadius = 20,
    this.iconSize = 40,
    this.iconColor,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  final List<Color> colors;
  final IconData icon;
  final String label;
  final double height;
  final double borderRadius;
  final double iconSize;
  final Color? iconColor;
  final Alignment begin;
  final Alignment end;

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ??
        (colors.first.computeLuminance() > 0.6
            ? AppColors.mocha400
            : Colors.white);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: resolvedIconColor.withValues(alpha: 0.7),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: resolvedIconColor.withValues(alpha: 0.75),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 圆形头像（支持真实图片）
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.char,
    required this.gradientColors,
    this.imageUrl = '',
    this.size = 44,
    this.fontSize = 14,
    this.borderWidth = 2,
  });

  final String char;
  final List<Color> gradientColors;
  final String imageUrl;
  final double size;
  final double fontSize;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: imageUrl.isEmpty
            ? LinearGradient(
                colors: gradientColors,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
            : null,
        color: imageUrl.isNotEmpty ? AppColors.cream200 : null,
        border: Border.all(color: AppColors.cream100, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isNotEmpty
          ? FlexibleImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: size,
              height: size,
              cacheWidth: (size * 2).round(),
              errorBuilder: (context, error, stackTrace) => _charFallback(),
            )
          : _charFallback(),
    );
  }

  Widget _charFallback() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Text(
        char,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

/// 顶部标题栏
class AppTitleBar extends StatelessWidget {
  const AppTitleBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      color: AppColors.cream50,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -4,
              left: -16,
              child: Icon(
                Icons.star,
                size: 12,
                color: AppColors.yellowAccent.withValues(alpha: 0.8),
              ),
            ),
            Positioned(
              top: 8,
              right: -12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.peach300,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 胶囊搜索框
class KawaiiSearchBar extends StatelessWidget {
  const KawaiiSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = '搜索穿搭、美食、日常...',
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: KawaiiShadow.sm,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.mocha400, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mocha700,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.mocha400,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  controller.clear();
                  onChanged?.call('');
                },
                child: const Icon(Icons.close, size: 18, color: AppColors.mocha400),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 点赞数格式化
String formatCount(int count) {
  if (count >= 10000) {
    return '${(count / 10000).toStringAsFixed(1)}w';
  }
  if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}k';
  }
  return count.toString();
}
