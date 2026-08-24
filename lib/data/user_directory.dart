import '../models/post.dart';
import 'mock_data.dart';

/// 从帖子与 mock 数据解析用户信息
class UserDirectory {
  UserDirectory._();

  static FollowUser? lookup(String userId, {List<Post> posts = const []}) {
    for (final user in [
      ...MockData.followingUsers,
      ...MockData.followerUsers,
    ]) {
      if (user.id == userId) return user;
    }

    for (final post in posts) {
      if (post.authorId == userId) {
        return FollowUser(
          id: post.authorId,
          name: post.authorName,
          avatarChar: post.authorAvatarChar,
          avatarGradientColors: post.avatarGradientColors,
          avatarUrl: post.avatarUrl,
        );
      }
    }

  for (final post in [
      ...MockData.discoverPosts,
      ...MockData.feedPosts,
    ]) {
      if (post.authorId == userId) {
        return FollowUser(
          id: post.authorId,
          name: post.authorName,
          avatarChar: post.authorAvatarChar,
          avatarGradientColors: post.avatarGradientColors,
          avatarUrl: post.avatarUrl,
        );
      }
    }

    return null;
  }

  static List<FollowUser> resolveUsers(
    Set<String> ids, {
    required List<Post> posts,
    bool isFollowing = false,
  }) {
    final users = <FollowUser>[];
    for (final id in ids) {
      final user = lookup(id, posts: posts);
      if (user == null) continue;
      users.add(
        FollowUser(
          id: user.id,
          name: user.name,
          avatarChar: user.avatarChar,
          bio: user.bio,
          avatarGradientColors: user.avatarGradientColors,
          avatarUrl: user.avatarUrl,
          isFollowing: isFollowing,
        ),
      );
    }
    users.sort((a, b) => a.name.compareTo(b.name));
    return users;
  }
}
