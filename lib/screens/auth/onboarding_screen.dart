import 'package:flutter/material.dart';

import '../../app_info.dart';
import '../../data/image_urls.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../utils/local_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static final _pages = [
    _OnboardPage(
      imageUrl: ImageUrls.afternoonTea,
      accentImageUrl: ImageUrls.flowers,
      gradient: AppColors.gradientOotd,
      badge: AppInfo.shortName,
      title: '欢迎来到\n${AppInfo.shortName}',
      subtitle: '在这里，把穿搭、美食、旅行与日常\n都酿成属于自己的甜美记忆',
      tags: ['# 治愈系', '# 少女心', '# 生活感'],
    ),
    _OnboardPage(
      imageUrl: ImageUrls.ootd,
      accentImageUrl: ImageUrls.cafe,
      gradient: AppColors.gradientCafe,
      badge: '发现',
      title: '逛发现，遇见心动灵感',
      subtitle: '穿搭达人、咖啡馆、萌宠日常…\n按频道浏览，轻松找到同好',
      tags: ['穿搭', '美食', '萌宠', '旅行'],
    ),
    _OnboardPage(
      imageUrl: ImageUrls.afternoonTea,
      accentImageUrl: ImageUrls.cat,
      gradient: AppColors.gradientAfternoonTea,
      badge: '萌友圈',
      title: '像吐泡泡一样\n轻松分享日常',
      subtitle: '发布图文动态，点赞评论互动\n和姐妹们一起记录生活里的小确幸',
      tags: ['发动态', '点赞互动', '评论聊天'],
    ),
    _OnboardPage(
      imageUrl: ImageUrls.diaryBook,
      accentImageUrl: ImageUrls.trip,
      gradient: AppColors.gradientDiary1,
      badge: '我的手帐',
      title: '收藏灵感，留住小美好',
      subtitle: '喜欢的内容一键收藏，手帐瀑布流精致陈列\n每一页都值得被温柔保存',
      tags: ['收藏夹', '手帐本', '专属回忆'],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream50,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  if (_currentPage == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.peach500.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        AppInfo.shortName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.peach500,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: widget.onComplete,
                      child: const Text(
                        '跳过',
                        style: TextStyle(
                          color: AppColors.mocha400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  return _OnboardSlide(page: _pages[index]);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppColors.peach500
                        : AppColors.peach300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.peach500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1
                        ? '下一步'
                        : '进入${AppInfo.shortName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardSlide extends StatelessWidget {
  const _OnboardSlide({required this.page});

  final _OnboardPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            flex: 5,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 12,
                  right: 20,
                  child: _GlowBlob(
                    size: 120,
                    colors: page.gradient,
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 8,
                  child: _GlowBlob(
                    size: 88,
                    colors: page.gradient.reversed.toList(),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: KawaiiShadow.md,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      child: _OnboardImage(url: page.imageUrl),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 36,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: KawaiiShadow.sm,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _OnboardImage(url: page.accentImageUrl),
                  ),
                ),
                Positioned(
                  left: 4,
                  top: 28,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: KawaiiShadow.sm,
                    ),
                    child: Text(
                      page.badge,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.peach500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mocha800,
                    height: 1.35,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  page.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.mocha500,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: page.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.peach500.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.peach300.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mocha700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardImage extends StatelessWidget {
  const _OnboardImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return FlexibleImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientOotd,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          '蜜',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colors.first.withValues(alpha: 0.45),
            colors.last.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage {
  const _OnboardPage({
    required this.imageUrl,
    required this.accentImageUrl,
    required this.gradient,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.tags,
  });

  final String imageUrl;
  final String accentImageUrl;
  final List<Color> gradient;
  final String badge;
  final String title;
  final String subtitle;
  final List<String> tags;
}
