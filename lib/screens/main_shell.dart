import 'package:flutter/material.dart';

import '../app_info.dart';
import '../data/mock_data.dart';
import '../data/user_directory.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../widgets/navigation_widgets.dart';
import 'create_post_screen.dart';
import 'discover/channel_list_screen.dart';
import 'discover_screen.dart';
import 'favorites_screen.dart';
import 'feed_screen.dart';
import '../utils/post_enricher.dart';
import '../widgets/action_sheets.dart';
import 'post/post_detail_screen.dart';
import 'post/report_screen.dart';
import 'profile/diary_detail_screen.dart';
import 'profile/follow_list_screen.dart';
import 'profile_screen.dart';
import 'settings/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _isLoading = true;

  UserProfile _profile = UserProfile();
  List<Post> _discoverPosts = [];
  List<Post> _feedPosts = [];
  List<Post> _diaryPosts = [];
  Set<String> _likedIds = {};
  Set<String> _favoriteIds = {};
  Set<String> _blockedUsers = {};
  Set<String> _reportedPosts = {};
  Set<String> _hiddenPostIds = {};
  Set<String> _followingIds = {};
  Set<String> _followerIds = {};
  Map<String, List<Comment>> _comments = {};
  String? _selectedCategory;

  static const _titles = [
    AppInfo.shortName,
    '萌友圈',
    '我的收藏',
    '我的手帐',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = StorageService.instance;
    final profile = await storage.loadProfile();
    final feedPosts = await storage.loadFeedPosts();
    final diaryPosts = await storage.loadDiaryPosts();
    final likedIds = await storage.loadLikedIds();
    final favoriteIds = await storage.loadFavoriteIds();
    final blockedUsers = await storage.loadBlockedUsers();
    final reportedPosts = await storage.loadReportedPosts();
    final hiddenPostIds = await storage.loadHiddenPostIds();
    final followingIds = await storage.loadFollowingIds();
    final followerIds = await storage.loadFollowerIds();
    final comments = await storage.loadComments();

    setState(() {
      _profile = profile;
      _hiddenPostIds = hiddenPostIds;
      _followingIds = followingIds;
      _followerIds = followerIds;
      _discoverPosts = _filterAndApply(
        PostEnricher.enrichAll(MockData.discoverPosts),
        likedIds,
        favoriteIds,
        blockedUsers,
        reportedPosts,
        hiddenPostIds,
      );
      _feedPosts = _filterAndApply(
        feedPosts,
        likedIds,
        favoriteIds,
        blockedUsers,
        reportedPosts,
        hiddenPostIds,
      );
      _diaryPosts = _filterAndApply(
        diaryPosts,
        likedIds,
        favoriteIds,
        blockedUsers,
        reportedPosts,
        hiddenPostIds,
      );
      _likedIds = likedIds;
      _favoriteIds = favoriteIds;
      _blockedUsers = blockedUsers;
      _reportedPosts = reportedPosts;
      _comments = comments;
      _isLoading = false;
    });
  }

  List<Post> _filterAndApply(
    List<Post> posts,
    Set<String> likedIds,
    Set<String> favoriteIds,
    Set<String> blockedUsers,
    Set<String> reportedPosts,
    Set<String> hiddenPostIds,
  ) {
    return posts
        .where((p) =>
            !blockedUsers.contains(p.authorId) &&
            !reportedPosts.contains(p.id) &&
            !hiddenPostIds.contains(p.id))
        .map((post) => post.copyWith(
              isLiked: likedIds.contains(post.id),
              isFavorited: favoriteIds.contains(post.id),
            ))
        .toList();
  }

  List<Post> get _allPostsForLookup => [
        ..._discoverPosts,
        ..._feedPosts,
        ..._diaryPosts,
        ...MockData.discoverPosts,
        ...MockData.feedPosts,
      ];

  UserProfile get _profileWithStats {
    var likes = 0;
    for (final post in [..._feedPosts, ..._diaryPosts]) {
      if (post.authorId == _profile.userId || post.isMine) {
        likes += post.likeCount;
      }
    }
    return _profile.copyWith(
      followingCount: _followingIds.length,
      followersCount: _followerIds.length,
      likesCount: likes,
    );
  }

  Post? _findPostById(String id) {
    for (final p in [..._discoverPosts, ..._feedPosts, ..._diaryPosts]) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<Post> get _allVisiblePosts =>
      [..._discoverPosts, ..._feedPosts, ..._diaryPosts];

  List<Post> get _favoritePosts {
    final map = <String, Post>{};
    for (final post in _allVisiblePosts) {
      if (_favoriteIds.contains(post.id)) {
        map[post.id] = post.copyWith(isFavorited: true);
      }
    }
    return map.values.toList();
  }

  Future<void> _persistLikes() async {
    await StorageService.instance.saveLikedIds(_likedIds);
  }

  Future<void> _persistFavorites() async {
    await StorageService.instance.saveFavoriteIds(_favoriteIds);
  }

  Future<void> _persistFeed() async {
    await StorageService.instance.saveFeedPosts(_feedPosts);
  }

  Future<void> _persistDiary() async {
    await StorageService.instance.saveDiaryPosts(_diaryPosts);
  }

  Future<void> _persistComments() async {
    await StorageService.instance.saveComments(_comments);
  }

  void _refreshLists() {
    _discoverPosts = _filterAndApply(
      PostEnricher.enrichAll(MockData.discoverPosts),
      _likedIds,
      _favoriteIds,
      _blockedUsers,
      _reportedPosts,
      _hiddenPostIds,
    );
    _feedPosts = _filterAndApply(
      _feedPosts,
      _likedIds,
      _favoriteIds,
      _blockedUsers,
      _reportedPosts,
      _hiddenPostIds,
    );
    _diaryPosts = _filterAndApply(
      _diaryPosts,
      _likedIds,
      _favoriteIds,
      _blockedUsers,
      _reportedPosts,
      _hiddenPostIds,
    );
  }

  void _applyPostUpdate(Post updated) {
    void updateList(List<Post> list) {
      for (var i = 0; i < list.length; i++) {
        if (list[i].id == updated.id) {
          list[i] = list[i].copyWith(
            isLiked: updated.isLiked,
            likeCount: updated.likeCount,
            isFavorited: updated.isFavorited,
            commentCount: updated.commentCount,
          );
        }
      }
    }

    updateList(_discoverPosts);
    updateList(_feedPosts);
    updateList(_diaryPosts);
  }

  Post _toggleLike(Post post) {
    final wasLiked = _likedIds.contains(post.id);
    final updated = post.copyWith(
      isLiked: !wasLiked,
      likeCount: post.likeCount + (wasLiked ? -1 : 1),
    );
    setState(() {
      if (wasLiked) {
        _likedIds.remove(post.id);
      } else {
        _likedIds.add(post.id);
      }
      _applyPostUpdate(updated);
    });
    _persistLikes();
    _persistFeed();
    return updated;
  }

  Post _toggleFavorite(Post post) {
    final wasFav = _favoriteIds.contains(post.id);
    final updated = post.copyWith(isFavorited: !wasFav);
    setState(() {
      if (wasFav) {
        _favoriteIds.remove(post.id);
      } else {
        _favoriteIds.add(post.id);
      }
      _applyPostUpdate(updated);
    });
    _persistFavorites();
    return updated;
  }

  Future<void> _handleHide(Post post) async {
    setState(() {
      _hiddenPostIds.add(post.id);
      _refreshLists();
    });
    await StorageService.instance.saveHiddenPostIds(_hiddenPostIds);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('已屏蔽该动态'),
          backgroundColor: AppColors.peach500,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
  }

  void _toggleFollowUser(String userId, {required bool follow}) {
    setState(() {
      if (follow) {
        _followingIds.add(userId);
      } else {
        _followingIds.remove(userId);
      }
    });
    StorageService.instance.saveFollowingIds(_followingIds);
  }

  Future<void> _handleReport(Post post) async {
    final reported = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ReportScreen(post: post)),
    );
    if (reported == true) {
      _reportPost(post);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('举报已提交，感谢反馈'),
            backgroundColor: AppColors.peach500,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleBlock(Post post) async {
    final confirmed = await confirmBlockUser(context, post.authorName);
    if (confirmed) {
      _blockUser(post);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已拉黑 ${post.authorName}'),
            backgroundColor: AppColors.peach500,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    }
  }
  void _reportPost(Post post) {
    setState(() {
      _reportedPosts.add(post.id);
      _refreshLists();
    });
    StorageService.instance.saveReportedPosts(_reportedPosts);
  }

  void _blockUser(Post post) {
    setState(() {
      _blockedUsers.add(post.authorId);
      _refreshLists();
    });
    StorageService.instance.saveBlockedUsers(_blockedUsers);
  }

  Post _addComment(Post post, String content) {
    final comment = Comment(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      authorName: _profile.nickname,
      authorAvatarChar: _profile.avatarChar,
      content: content,
      timeLabel: '刚刚',
      avatarGradientColors: [0xFFFFC4D1, 0xFFFF6B8B],
      avatarUrl: _profile.avatarUrl,
    );
    final updatedComments = <Comment>[
      comment,
      ...(_comments[post.id] ?? const <Comment>[]),
    ];
    final updated = post.copyWith(commentCount: updatedComments.length);
    setState(() {
      _comments[post.id] = updatedComments;
      _applyPostUpdate(updated);
    });
    _persistComments();
    _persistFeed();
    return updated;
  }

  List<Comment> _commentsForPost(String postId) =>
      List<Comment>.from(_comments[postId] ?? []);

  void _openPostDetail(Post post) {
    final current = _findPostById(post.id) ?? post;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(
          post: current,
          comments: _commentsForPost(current.id),
          onLikeToggle: _toggleLike,
          onFavoriteToggle: _toggleFavorite,
          onReport: _reportPost,
          onBlock: _blockUser,
          onHide: _handleHide,
          onAddComment: _addComment,
          resolveComments: _commentsForPost,
        ),
      ),
    );
  }

  Future<void> _openCreatePost() async {
    final result = await Navigator.of(context).push<Post>(
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(profile: _profile),
        fullscreenDialog: true,
      ),
    );
    if (result == null) return;

    setState(() {
      _feedPosts = [result, ..._feedPosts];
      _diaryPosts = [result, ..._diaryPosts];
    });
    await _persistFeed();
    await _persistDiary();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('发布成功！'),
          backgroundColor: AppColors.peach500,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          profile: _profileWithStats,
          blockedCount: _blockedUsers.length,
          onProfileUpdated: (p) async {
            setState(() => _profile = p);
            await StorageService.instance.saveProfile(p);
          },
          onLogout: widget.onLogout,
          onDeleteAccount: widget.onDeleteAccount,
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    final result = await showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileSheet(profile: _profile),
    );
    if (result == null) return;
    setState(() => _profile = result);
    await StorageService.instance.saveProfile(result);
  }

  void _deleteDiary(Post post) {
    setState(() {
      _diaryPosts.removeWhere((p) => p.id == post.id);
      _feedPosts.removeWhere((p) => p.id == post.id);
    });
    _persistDiary();
    _persistFeed();
  }

  void _onTabSelected(int index) {
    if (index == _currentIndex) {
      // 再次点击「发现」Tab 时清除频道筛选
      if (index == 0 && _selectedCategory != null) {
        setState(() => _selectedCategory = null);
      }
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.cream50,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.peach500),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream50,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppTitleBar(title: _titles[_currentIndex]),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(_currentIndex),
                  child: _buildPage(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
        onFabPressed: _openCreatePost,
      ),
    );
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return DiscoverScreen(
          posts: _discoverPosts,
          onFavoriteToggle: _toggleFavorite,
          selectedCategory: _selectedCategory,
          onCategoryChanged: (category) {
            setState(() => _selectedCategory = category);
          },
          onPostTap: _openPostDetail,
          onOpenChannels: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChannelListScreen(
                  posts: _discoverPosts,
                  onPostTap: _openPostDetail,
                  onFavoriteToggle: _toggleFavorite,
                  initialCategory: _selectedCategory,
                ),
              ),
            );
          },
          onSearch: (query) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchScreen(
                  posts: _discoverPosts,
                  onPostTap: _openPostDetail,
                  initialQuery: query,
                ),
              ),
            );
          },
        );
      case 1:
        return FeedScreen(
          posts: _feedPosts,
          onLikeToggle: _toggleLike,
          onFavoriteToggle: _toggleFavorite,
          onCreatePost: _openCreatePost,
          onPostTap: _openPostDetail,
          onReport: _handleReport,
          onBlock: _handleBlock,
          onHide: _handleHide,
        );
      case 2:
        return FavoritesScreen(
          posts: _favoritePosts,
          onRemoveFavorite: _toggleFavorite,
          onPostTap: _openPostDetail,
        );
      case 3:
        return ProfileScreen(
          profile: _profileWithStats,
          diaryPosts: _diaryPosts,
          favoriteCount: _favoriteIds.length,
          onEditProfile: _editProfile,
          onCreatePost: _openCreatePost,
          onOpenSettings: _openSettings,
          onOpenFollowing: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FollowListScreen(
                  title: '我的关注',
                  users: UserDirectory.resolveUsers(
                    _followingIds,
                    posts: _allPostsForLookup,
                    isFollowing: true,
                  ),
                  isFollowingList: true,
                  onFollowToggle: (userId, follow) =>
                      _toggleFollowUser(userId, follow: follow),
                ),
              ),
            ).then((_) => setState(() {}));
          },
          onOpenFollowers: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FollowListScreen(
                  title: '我的粉丝',
                  users: UserDirectory.resolveUsers(
                    _followerIds,
                    posts: _allPostsForLookup,
                  ),
                  isFollowingList: false,
                  followingIds: _followingIds,
                  onFollowToggle: (userId, follow) =>
                      _toggleFollowUser(userId, follow: follow),
                ),
              ),
            ).then((_) => setState(() {}));
          },
          onDiaryTap: (post) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiaryDetailScreen(
                  post: post,
                  onDelete: () => _deleteDiary(post),
                ),
              ),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
