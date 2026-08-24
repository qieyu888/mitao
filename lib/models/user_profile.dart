/// 个人主页资料（本地存储，无账户系统）
class UserProfile {
  UserProfile({
    this.nickname = '草莓布丁 🍓',
    this.userId = 'strawberry_001',
    this.avatarChar = '莓',
    this.avatarUrl = '',
    this.followingCount = 0,
    this.followersCount = 0,
    this.likesCount = 0,
  });

  String nickname;
  String userId;
  String avatarChar;
  String avatarUrl;
  int followingCount;
  int followersCount;
  int likesCount;

  UserProfile copyWith({
    String? nickname,
    String? userId,
    String? avatarChar,
    String? avatarUrl,
    int? followingCount,
    int? followersCount,
    int? likesCount,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      userId: userId ?? this.userId,
      avatarChar: avatarChar ?? this.avatarChar,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followingCount: followingCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'userId': userId,
      'avatarChar': avatarChar,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] as String? ?? '草莓布丁 🍓',
      userId: json['userId'] as String? ?? 'strawberry_001',
      avatarChar: json['avatarChar'] as String? ?? '莓',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }
}
