import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/post.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/discover_card.dart';
import '../widgets/navigation_widgets.dart';
import '../widgets/waterfall_widgets.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    required this.posts,
    required this.onFavoriteToggle,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onPostTap,
    required this.onOpenChannels,
    required this.onSearch,
  });

  final List<Post> posts;
  final void Function(Post post) onFavoriteToggle;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final void Function(Post post) onPostTap;
  final VoidCallback onOpenChannels;
  final void Function(String query) onSearch;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Post> get _filteredPosts {
    var result = widget.posts;
    if (widget.selectedCategory != null && widget.selectedCategory!.isNotEmpty) {
      result = result
          .where((p) => p.category == widget.selectedCategory)
          .toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      result = result.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.content.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.imageLabel.toLowerCase().contains(q);
      }).toList();
    }
    return result;
  }

  void _clearCategory() => widget.onCategoryChanged(null);

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPosts;
    final hasFilter = widget.selectedCategory != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        GestureDetector(
          onTap: () => widget.onSearch(_query),
          child: AbsorbPointer(
            child: KawaiiSearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('热门频道', style: Theme.of(context).textTheme.titleLarge),
            GestureDetector(
              onTap: widget.onOpenChannels,
              child: const Row(
                children: [
                  Text(
                    '更多频道',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.peach500,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 18, color: AppColors.peach500),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MockData.channels.length + 1,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                final isAll = !hasFilter;
                return SizedBox(
                  width: 80,
                  child: _AllChannelChip(
                    selected: isAll,
                    onTap: _clearCategory,
                  ),
                );
              }
              final channel = MockData.channels[index - 1];
              final isSelected = widget.selectedCategory == channel.category;
              return SizedBox(
                width: 80,
                child: ChannelTile(
                  channel: channel,
                  isSelected: isSelected,
                  onTap: () {
                    widget.onCategoryChanged(
                      isSelected ? null : channel.category,
                    );
                  },
                ),
              );
            },
          ),
        ),
        if (hasFilter) ...[
          const SizedBox(height: 16),
          _ActiveFilterBar(
            category: widget.selectedCategory!,
            count: filtered.length,
            onClear: _clearCategory,
          ),
        ],
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hasFilter ? '${widget.selectedCategory} · 推荐' : '为你推荐',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (hasFilter)
              GestureDetector(
                onTap: _clearCategory,
                child: const Text(
                  '查看全部',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.peach500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Column(
              children: [
                const Text(
                  '该频道暂无内容',
                  style: TextStyle(color: AppColors.mocha400),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _clearCategory,
                  icon: const Icon(Icons.refresh, color: AppColors.peach500),
                  label: const Text(
                    '返回查看全部',
                    style: TextStyle(
                      color: AppColors.peach500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
    );
  }
}

/// 「全部」频道入口
class _AllChannelChip extends StatelessWidget {
  const _AllChannelChip({
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

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
              decoration: BoxDecoration(
                color: selected ? AppColors.peach500 : Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: KawaiiShadow.sm,
                border: selected
                    ? Border.all(color: AppColors.peach500, width: 3)
                    : Border.all(color: AppColors.cream200),
              ),
              child: Icon(
                Icons.apps,
                size: 28,
                color: selected ? Colors.white : AppColors.peach500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '全部',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? AppColors.peach500 : AppColors.mocha700,
            ),
          ),
        ],
      ),
    );
  }
}

/// 当前筛选提示条
class _ActiveFilterBar extends StatelessWidget {
  const _ActiveFilterBar({
    required this.category,
    required this.count,
    required this.onClear,
  });

  final String category;
  final int count;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.peach500.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.peach300),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_alt, size: 18, color: AppColors.peach500),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '正在浏览「$category」· $count 篇',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.mocha700,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '查看全部',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.peach500,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.close, size: 14, color: AppColors.peach500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
