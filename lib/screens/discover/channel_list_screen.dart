import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/post.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/discover_card.dart';
import '../../widgets/navigation_widgets.dart';
import '../../widgets/page_widgets.dart';
import '../../widgets/post_cover.dart';
import '../../widgets/waterfall_widgets.dart';

class ChannelListScreen extends StatelessWidget {
  const ChannelListScreen({
    super.key,
    required this.posts,
    required this.onPostTap,
    required this.onFavoriteToggle,
    this.initialCategory,
  });

  final List<Post> posts;
  final void Function(Post post) onPostTap;
  final void Function(Post post) onFavoriteToggle;
  final String? initialCategory;

  @override
  Widget build(BuildContext context) {
    return _ChannelListBody(
      posts: posts,
      onPostTap: onPostTap,
      onFavoriteToggle: onFavoriteToggle,
      initialCategory: initialCategory,
    );
  }
}

class _ChannelListBody extends StatefulWidget {
  const _ChannelListBody({
    required this.posts,
    required this.onPostTap,
    required this.onFavoriteToggle,
    this.initialCategory,
  });

  final List<Post> posts;
  final void Function(Post post) onPostTap;
  final void Function(Post post) onFavoriteToggle;
  final String? initialCategory;

  @override
  State<_ChannelListBody> createState() => _ChannelListBodyState();
}

class _ChannelListBodyState extends State<_ChannelListBody> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  List<Post> get _filtered {
    if (_selectedCategory == null) return widget.posts;
    return widget.posts
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: const KawaiiAppBar(title: '热门频道'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.channels.length + 1,
              separatorBuilder: (_, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isAll = _selectedCategory == null;
                  return SizedBox(
                    width: 80,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = null),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isAll ? AppColors.peach500 : Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: KawaiiShadow.sm,
                                border: isAll
                                    ? Border.all(color: AppColors.peach500, width: 3)
                                    : Border.all(color: AppColors.cream200),
                              ),
                              child: Icon(
                                Icons.apps,
                                color: isAll ? Colors.white : AppColors.peach500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '全部',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isAll ? AppColors.peach500 : AppColors.mocha700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final channel = MockData.channels[index - 1];
                final isSelected = _selectedCategory == channel.category;
                return SizedBox(
                  width: 80,
                  child: ChannelTile(
                    channel: channel,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedCategory =
                            isSelected ? null : channel.category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          if (_selectedCategory != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '筛选：$_selectedCategory',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.mocha700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedCategory = null),
                  child: const Text(
                    '查看全部',
                    style: TextStyle(
                      color: AppColors.peach500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCategory ?? '全部内容',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${filtered.length} 篇',
                style: const TextStyle(
                  color: AppColors.mocha400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  '该频道暂无内容',
                  style: TextStyle(color: AppColors.mocha400),
                ),
              ),
            )
          else
            WaterfallGrid(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final post = filtered[index];
                return GestureDetector(
                  onTap: () => widget.onPostTap(post),
                  child: DiscoverCard(
                    post: post,
                    onFavorite: () => widget.onFavoriteToggle(post),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.posts,
    required this.onPostTap,
    required this.initialQuery,
  });

  final List<Post> posts;
  final void Function(Post post) onPostTap;
  final String initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Post> get _results {
    if (_query.isEmpty) return widget.posts;
    final q = _query.toLowerCase();
    return widget.posts.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.content.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.authorName.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.cream50,
      appBar: KawaiiAppBar(
        title: '搜索',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          KawaiiSearchBar(
            controller: _controller,
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 24),
          if (_query.isNotEmpty)
            Text(
              '找到 ${results.length} 条结果',
              style: const TextStyle(
                color: AppColors.mocha400,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 16),
          ...results.map(
            (post) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: KawaiiCard(
                onTap: () => widget.onPostTap(post),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    PostThumbnail(post: post, size: 56, borderRadius: 14),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title.isNotEmpty ? post.title : post.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mocha800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${post.authorName} · ${post.category}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.mocha400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.mocha400),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
