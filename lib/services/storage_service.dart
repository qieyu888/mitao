import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/feed_mock_data.dart';
import '../data/mock_data.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/user_profile.dart';
import '../utils/post_enricher.dart';

/// 本地数据持久化（shared_preferences）
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _keyLikedIds = 'liked_post_ids';
  static const _keyFavoriteIds = 'favorite_post_ids';
  static const _keyDiaryPosts = 'diary_posts';
  static const _keyFeedPosts = 'feed_posts';
  static const _keyProfile = 'user_profile';
  static const _keyInitialized = 'data_initialized';
  static const _keyOnboardingDone = 'onboarding_done';
  static const _keyTermsAgreed = 'terms_agreed';
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyBlockedUsers = 'blocked_user_ids';
  static const _keyReportedPosts = 'reported_post_ids';
  static const _keyComments = 'post_comments';
  static const _keyFollowingIds = 'following_user_ids';
  static const _keyFollowerIds = 'follower_user_ids';
  static const _keyHiddenPostIds = 'hidden_post_ids';
  static const _keyDataVersion = 'data_version';
  static const _currentDataVersion = 9;

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> init() async {
    final prefs = await _storage;
    final initialized = prefs.getBool(_keyInitialized) ?? false;
    if (!initialized) {
      await _seedInitialData();
      await prefs.setBool(_keyInitialized, true);
      await prefs.setInt(_keyDataVersion, _currentDataVersion);
    } else {
      await _migrateIfNeeded(prefs);
    }
  }

  Future<void> _migrateIfNeeded(SharedPreferences prefs) async {
    final version = prefs.getInt(_keyDataVersion) ?? 1;
    if (version >= _currentDataVersion) return;

    if (version < 9) {
      final existingFeed = (jsonDecode(prefs.getString(_keyFeedPosts) ?? '[]')
              as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
      final existingById = {for (final p in existingFeed) p.id: p};
      final userPosts =
          existingFeed.where((p) => p.id.startsWith('post_')).toList();
      final mockFeed = PostEnricher.enrichAll(MockData.feedPosts);
      final mergedFeed = <Post>[
        ...userPosts,
        for (final mock in mockFeed) _mergeFeedPost(existingById[mock.id], mock),
      ];
      await saveFeedPosts(mergedFeed);

      final existingDiary =
          (jsonDecode(prefs.getString(_keyDiaryPosts) ?? '[]') as List<dynamic>)
              .map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList();
      final diaryById = {for (final p in existingDiary) p.id: p};
      final userDiary =
          existingDiary.where((p) => p.id.startsWith('post_')).toList();
      final mockDiary = PostEnricher.enrichAll(MockData.diaryPosts);
      final mergedDiary = <Post>[
        ...userDiary,
        for (final mock in mockDiary) diaryById[mock.id] ?? mock,
      ];
      await saveDiaryPosts(mergedDiary);

      final profile = await loadProfile();
      if (profile.bio.trim().isEmpty) {
        profile.bio = '把日常过成喜欢的样子';
        await saveProfile(profile);
      }
    }

    if (version < 8) {
      final existingFeed = (jsonDecode(prefs.getString(_keyFeedPosts) ?? '[]')
              as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
      final existingById = {for (final p in existingFeed) p.id: p};
      final userPosts =
          existingFeed.where((p) => p.id.startsWith('post_')).toList();
      final mockFeed = PostEnricher.enrichAll(MockData.feedPosts);
      final mergedFeed = <Post>[
        ...userPosts,
        for (final mock in mockFeed) _mergeFeedPost(existingById[mock.id], mock),
      ];
      await saveFeedPosts(mergedFeed);
    }

    if (version < 6) {
      final existingFeed = (jsonDecode(prefs.getString(_keyFeedPosts) ?? '[]')
              as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
      final existingById = {for (final p in existingFeed) p.id: p};
      final userPosts =
          existingFeed.where((p) => p.id.startsWith('post_')).toList();
      final mockFeed = PostEnricher.enrichAll(MockData.feedPosts);
      final mergedFeed = <Post>[
        ...userPosts,
        for (final mock in mockFeed) _mergeFeedPost(existingById[mock.id], mock),
      ];
      await saveFeedPosts(mergedFeed);
    }

    if (version < 5) {
      final following = await loadFollowingIds();
      if (following.isEmpty) {
        await saveFollowingIds(
          MockData.followingUsers.map((u) => u.id).toSet(),
        );
      }
      final followers = await loadFollowerIds();
      if (followers.isEmpty) {
        await saveFollowerIds(
          MockData.followerUsers.map((u) => u.id).toSet(),
        );
      }
    }

    if (version < 4) {
      final existingFeed = (jsonDecode(prefs.getString(_keyFeedPosts) ?? '[]')
              as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
      final existingById = {for (final p in existingFeed) p.id: p};
      final userPosts =
          existingFeed.where((p) => p.id.startsWith('post_')).toList();
      final mockFeed = PostEnricher.enrichAll(MockData.feedPosts);
      final mergedFeed = <Post>[
        ...userPosts,
        for (final mock in mockFeed)
          PostEnricher.enrich(existingById[mock.id] ?? mock),
      ];
      await saveFeedPosts(mergedFeed);

      final comments = await loadComments();
      final mergedComments = Map<String, List<Comment>>.from(comments);
      for (final entry in FeedMockData.comments.entries) {
        mergedComments[entry.key] = entry.value;
      }
      for (final entry in MockData.defaultComments.entries) {
        mergedComments.putIfAbsent(entry.key, () => entry.value);
      }
      await saveComments(mergedComments);
    }

    // v2/v3: 补全并刷新真实图片 URL（替换失效的 Unsplash 链接）
    final feed = PostEnricher.enrichAll(
      (jsonDecode(prefs.getString(_keyFeedPosts) ?? '[]') as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    final diary = PostEnricher.enrichAll(
      (jsonDecode(prefs.getString(_keyDiaryPosts) ?? '[]') as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    await saveFeedPosts(feed);
    await saveDiaryPosts(diary);
    await saveProfile(PostEnricher.enrichProfile(await loadProfile()));

    await prefs.setInt(_keyDataVersion, _currentDataVersion);
  }

  /// 合并 mock 动态：保留用户互动数据，刷新配图与文案
  static Post _mergeFeedPost(Post? existing, Post mock) {
    if (existing == null) return mock;
    return Post(
      id: mock.id,
      authorId: mock.authorId,
      authorName: mock.authorName,
      authorAvatarChar: mock.authorAvatarChar,
      avatarGradientColors: mock.avatarGradientColors,
      content: mock.content,
      timeLabel: mock.timeLabel,
      imageGradientColors: mock.imageGradientColors,
      imageIcon: mock.imageIcon,
      imageUrl: mock.imageUrl,
      avatarUrl: mock.avatarUrl,
      imageLabel: mock.imageLabel,
      imageHeight: mock.imageHeight,
      likeCount: existing.likeCount,
      commentCount: existing.commentCount,
      category: mock.category,
      title: mock.title,
      isLiked: existing.isLiked,
      isFavorited: existing.isFavorited,
      isMine: existing.isMine,
    );
  }

  Future<void> _seedInitialData() async {
    final prefs = await _storage;
    await saveFeedPosts(PostEnricher.enrichAll(MockData.feedPosts));
    await saveDiaryPosts(PostEnricher.enrichAll(MockData.diaryPosts));
    await saveProfile(PostEnricher.enrichProfile(UserProfile()));
    await saveComments(MockData.defaultComments);
    final favIds = MockData.favoritePosts.map((p) => p.id).toList();
    await prefs.setStringList(_keyFavoriteIds, favIds);
    await saveFollowingIds(MockData.followingUsers.map((u) => u.id).toSet());
    await saveFollowerIds(MockData.followerUsers.map((u) => u.id).toSet());
  }

  // ── 登录 / 引导 ──

  Future<bool> isOnboardingDone() async {
    final prefs = await _storage;
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  Future<void> setOnboardingDone() async {
    final prefs = await _storage;
    await prefs.setBool(_keyOnboardingDone, true);
  }

  Future<bool> isTermsAgreed() async {
    final prefs = await _storage;
    return prefs.getBool(_keyTermsAgreed) ?? false;
  }

  Future<void> setTermsAgreed() async {
    final prefs = await _storage;
    await prefs.setBool(_keyTermsAgreed, true);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await _storage;
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<void> login() async {
    final prefs = await _storage;
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setBool(_keyTermsAgreed, true);
  }

  Future<void> logout() async {
    final prefs = await _storage;
    await prefs.setBool(_keyLoggedIn, false);
  }

  Future<void> deleteAccount() async {
    final prefs = await _storage;
    await prefs.clear();
    await prefs.setBool(_keyInitialized, true);
    await _seedInitialData();
  }

  // ── 拉黑 / 举报 ──

  Future<Set<String>> loadBlockedUsers() async {
    final prefs = await _storage;
    return prefs.getStringList(_keyBlockedUsers)?.toSet() ?? {};
  }

  Future<void> saveBlockedUsers(Set<String> ids) async {
    final prefs = await _storage;
    await prefs.setStringList(_keyBlockedUsers, ids.toList());
  }

  Future<Set<String>> loadReportedPosts() async {
    final prefs = await _storage;
    return prefs.getStringList(_keyReportedPosts)?.toSet() ?? {};
  }

  Future<void> saveReportedPosts(Set<String> ids) async {
    final prefs = await _storage;
    await prefs.setStringList(_keyReportedPosts, ids.toList());
  }

  Future<Set<String>> loadHiddenPostIds() async {
    final prefs = await _storage;
    return prefs.getStringList(_keyHiddenPostIds)?.toSet() ?? {};
  }

  Future<void> saveHiddenPostIds(Set<String> ids) async {
    final prefs = await _storage;
    await prefs.setStringList(_keyHiddenPostIds, ids.toList());
  }

  Future<Set<String>> loadFollowingIds() async {
    final prefs = await _storage;
    return prefs.getStringList(_keyFollowingIds)?.toSet() ?? {};
  }

  Future<void> saveFollowingIds(Set<String> ids) async {
    final prefs = await _storage;
    await prefs.setStringList(_keyFollowingIds, ids.toList());
  }

  Future<Set<String>> loadFollowerIds() async {
    final prefs = await _storage;
    return prefs.getStringList(_keyFollowerIds)?.toSet() ?? {};
  }

  Future<void> saveFollowerIds(Set<String> ids) async {
    final prefs = await _storage;
    await prefs.setStringList(_keyFollowerIds, ids.toList());
  }

  // ── 评论 ──

  Future<Map<String, List<Comment>>> loadComments() async {
    final prefs = await _storage;
    final raw = prefs.getString(_keyComments);
    if (raw == null) return MockData.defaultComments;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((postId, list) {
      final comments = (list as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList();
      return MapEntry(postId, comments);
    });
  }

  Future<void> saveComments(Map<String, List<Comment>> comments) async {
    final prefs = await _storage;
    final encoded = jsonEncode(
      comments.map(
        (key, value) => MapEntry(key, value.map((c) => c.toJson()).toList()),
      ),
    );
    await prefs.setString(_keyComments, encoded);
  }

  // ── 用户资料 ──

  Future<UserProfile> loadProfile() async {
    final prefs = await _storage;
    final raw = prefs.getString(_keyProfile);
    if (raw == null) return PostEnricher.enrichProfile(UserProfile());
    return PostEnricher.enrichProfile(
      UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>),
    );
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await _storage;
    await prefs.setString(_keyProfile, jsonEncode(profile.toJson()));
  }

  Future<Set<String>> loadLikedIds() async {
    final prefs = await _storage;
    return prefs.getStringList(_keyLikedIds)?.toSet() ?? {};
  }

  Future<void> saveLikedIds(Set<String> ids) async {
    final prefs = await _storage;
    await prefs.setStringList(_keyLikedIds, ids.toList());
  }

  Future<Set<String>> loadFavoriteIds() async {
    final prefs = await _storage;
    return prefs.getStringList(_keyFavoriteIds)?.toSet() ?? {};
  }

  Future<void> saveFavoriteIds(Set<String> ids) async {
    final prefs = await _storage;
    await prefs.setStringList(_keyFavoriteIds, ids.toList());
  }

  Future<List<Post>> loadFeedPosts() async {
    return _loadPosts(_keyFeedPosts, MockData.feedPosts);
  }

  Future<void> saveFeedPosts(List<Post> posts) async {
    await _savePosts(_keyFeedPosts, posts);
  }

  Future<List<Post>> loadDiaryPosts() async {
    return _loadPosts(_keyDiaryPosts, MockData.diaryPosts);
  }

  Future<void> saveDiaryPosts(List<Post> posts) async {
    await _savePosts(_keyDiaryPosts, posts);
  }

  Future<List<Post>> _loadPosts(String key, List<Post> fallback) async {
    final prefs = await _storage;
    final raw = prefs.getString(key);
    if (raw == null) return PostEnricher.enrichAll(List<Post>.from(fallback));
    final list = jsonDecode(raw) as List<dynamic>;
    return PostEnricher.enrichAll(
      list.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Future<void> _savePosts(String key, List<Post> posts) async {
    final prefs = await _storage;
    final encoded = jsonEncode(posts.map((p) => p.toJson()).toList());
    await prefs.setString(key, encoded);
  }
}
