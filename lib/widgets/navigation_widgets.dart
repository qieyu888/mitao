import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/channel.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// 热门频道入口
class ChannelTile extends StatelessWidget {
  const ChannelTile({
    super.key,
    required this.channel,
    this.onTap,
    this.isSelected = false,
  });

  final Channel channel;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: KawaiiShadow.sm,
                border: isSelected
                    ? Border.all(color: AppColors.peach500, width: 3)
                    : null,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (channel.coverUrl.isNotEmpty)
                    Image.network(
                      channel.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: channel.gradientColors,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: channel.gradientColors,
                        ),
                      ),
                    ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                  Center(
                    child: Icon(
                      channel.icon,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            channel.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.peach500 : AppColors.mocha700,
            ),
          ),
        ],
      ),
    );
  }
}

/// 毛玻璃底部导航栏
class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onFabPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onFabPressed;

  static const _tabs = [
    _NavItem(icon: Icons.explore, label: '发现'),
    _NavItem(icon: Icons.favorite, label: '动态'),
    _NavItem(icon: Icons.star, label: '收藏'),
    _NavItem(icon: Icons.person, label: '我'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cream50.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cream100.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(context).padding.bottom + 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTab(0),
              _buildTab(1),
              _buildFab(),
              _buildTab(2),
              _buildTab(3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final tab = _tabs[index];
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.peach500 : AppColors.mocha400;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tab.icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: onFabPressed,
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.peach500,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: KawaiiShadow.md,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
