import '../data/image_urls.dart';
import '../data/mock_data.dart';
import '../utils/local_image.dart';
import '../models/post.dart';
import '../models/user_profile.dart';

/// 为本地缓存帖子补全/刷新图片 URL
class PostEnricher {
  PostEnricher._();

  static Map<String, Post> get _mockById {
    final all = [
      ...MockData.discoverPosts,
      ...MockData.feedPosts,
      ...MockData.favoritePosts,
      ...MockData.diaryPosts,
    ];
    return {for (final p in all) p.id: p};
  }

  static Post enrich(Post post) {
    final mock = _mockById[post.id];

    // mock 帖子始终使用最新精选配图；用户相册图保留
    final imageUrl = isLocalImagePath(post.imageUrl)
        ? post.imageUrl
        : (mock != null
            ? mock.imageUrl
            : (ImageUrls.isLegacyImageUrl(post.imageUrl)
                ? ImageUrls.forCategory(post.category)
                : post.imageUrl));

    final avatarUrl = isLocalImagePath(post.avatarUrl)
        ? post.avatarUrl
        : (mock != null
            ? mock.avatarUrl
            : (post.avatarUrl.isEmpty
                ? ImageUrls.avatarMine
                : post.avatarUrl));

    if (imageUrl == post.imageUrl && avatarUrl == post.avatarUrl) {
      return post;
    }

    return Post(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      authorAvatarChar: post.authorAvatarChar,
      avatarGradientColors: post.avatarGradientColors,
      content: post.content,
      timeLabel: post.timeLabel,
      imageGradientColors: post.imageGradientColors,
      imageIcon: post.imageIcon,
      imageUrl: imageUrl,
      avatarUrl: avatarUrl,
      imageLabel: post.imageLabel,
      imageHeight: post.imageHeight,
      likeCount: post.likeCount,
      commentCount: post.commentCount,
      category: post.category,
      title: post.title,
      isLiked: post.isLiked,
      isFavorited: post.isFavorited,
      isMine: post.isMine,
    );
  }

  static List<Post> enrichAll(List<Post> posts) =>
      posts.map(enrich).toList();

  static UserProfile enrichProfile(UserProfile profile) {
    if (profile.avatarUrl.isNotEmpty &&
        !ImageUrls.isLegacyImageUrl(profile.avatarUrl)) {
      return profile;
    }
    profile.avatarUrl = ImageUrls.avatarMine;
    return profile;
  }
}
