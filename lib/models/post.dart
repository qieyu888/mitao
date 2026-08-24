import 'package:flutter/material.dart';

/// 帖子 / 推荐卡片 / 手帐条目
class Post {
  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarChar,
    required this.avatarGradientColors,
    required this.content,
    required this.timeLabel,
    required this.imageGradientColors,
    required this.imageIcon,
    this.imageUrl = '',
    this.avatarUrl = '',
    this.imageLabel = '',
    this.imageHeight = 200,
    this.likeCount = 0,
    this.commentCount = 0,
    this.category = '',
    this.title = '',
    this.isLiked = false,
    this.isFavorited = false,
    this.isMine = false,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatarChar;
  final List<int> avatarGradientColors;
  final String content;
  final String timeLabel;
  final List<int> imageGradientColors;
  final int imageIcon;
  final String imageUrl;
  final String avatarUrl;
  final String imageLabel;
  final double imageHeight;
  int likeCount;
  int commentCount;
  final String category;
  String title;
  bool isLiked;
  bool isFavorited;
  final bool isMine;

  IconData get icon => IconData(imageIcon, fontFamily: 'MaterialIcons');

  List<Color> get avatarGradient =>
      avatarGradientColors.map((c) => Color(c)).toList();

  List<Color> get imageGradient =>
      imageGradientColors.map((c) => Color(c)).toList();

  Post copyWith({
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isFavorited,
    String? title,
    String? imageUrl,
  }) {
    return Post(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorAvatarChar: authorAvatarChar,
      avatarGradientColors: avatarGradientColors,
      content: content,
      timeLabel: timeLabel,
      imageGradientColors: imageGradientColors,
      imageIcon: imageIcon,
      imageUrl: imageUrl ?? this.imageUrl,
      avatarUrl: avatarUrl,
      imageLabel: imageLabel,
      imageHeight: imageHeight,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      category: category,
      title: title ?? this.title,
      isLiked: isLiked ?? this.isLiked,
      isFavorited: isFavorited ?? this.isFavorited,
      isMine: isMine,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarChar': authorAvatarChar,
      'avatarGradientColors': avatarGradientColors,
      'content': content,
      'timeLabel': timeLabel,
      'imageGradientColors': imageGradientColors,
      'imageIcon': imageIcon,
      'imageUrl': imageUrl,
      'avatarUrl': avatarUrl,
      'imageLabel': imageLabel,
      'imageHeight': imageHeight,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'category': category,
      'title': title,
      'isLiked': isLiked,
      'isFavorited': isFavorited,
      'isMine': isMine,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      authorId: json['authorId'] as String? ?? json['authorName'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      authorAvatarChar: json['authorAvatarChar'] as String? ?? '?',
      avatarGradientColors: (json['avatarGradientColors'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [0xFFFF9EB5, 0xFFFF6B8B],
      content: json['content'] as String? ?? '',
      timeLabel: json['timeLabel'] as String? ?? '',
      imageGradientColors: (json['imageGradientColors'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [0xFFFFDEE9, 0xFFB5FFFC],
      imageIcon: json['imageIcon'] as int? ?? 0xe3af,
      imageUrl: json['imageUrl'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      imageLabel: json['imageLabel'] as String? ?? '',
      imageHeight: (json['imageHeight'] as num?)?.toDouble() ?? 200,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      isLiked: json['isLiked'] as bool? ?? false,
      isFavorited: json['isFavorited'] as bool? ?? false,
      isMine: json['isMine'] as bool? ?? false,
    );
  }
}
