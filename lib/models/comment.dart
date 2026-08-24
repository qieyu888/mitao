/// 评论
class Comment {
  Comment({
    required this.id,
    required this.authorName,
    required this.authorAvatarChar,
    required this.content,
    required this.timeLabel,
    this.avatarGradientColors = const [0xFFFF9EB5, 0xFFFF6B8B],
    this.avatarUrl = '',
  });

  final String id;
  final String authorName;
  final String authorAvatarChar;
  final String content;
  final String timeLabel;
  final List<int> avatarGradientColors;
  final String avatarUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorAvatarChar': authorAvatarChar,
      'content': content,
      'timeLabel': timeLabel,
      'avatarGradientColors': avatarGradientColors,
      'avatarUrl': avatarUrl,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      authorName: json['authorName'] as String? ?? '',
      authorAvatarChar: json['authorAvatarChar'] as String? ?? '?',
      content: json['content'] as String? ?? '',
      timeLabel: json['timeLabel'] as String? ?? '',
      avatarGradientColors: (json['avatarGradientColors'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [0xFFFF9EB5, 0xFFFF6B8B],
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }
}

/// 举报原因
class ReportReason {
  const ReportReason({required this.id, required this.label});

  final String id;
  final String label;

  static const List<ReportReason> all = [
    ReportReason(id: 'spam', label: '垃圾广告'),
    ReportReason(id: 'porn', label: '色情低俗'),
    ReportReason(id: 'violence', label: '暴力恐怖'),
    ReportReason(id: 'fraud', label: '欺诈信息'),
    ReportReason(id: 'harass', label: '骚扰辱骂'),
    ReportReason(id: 'other', label: '其他原因'),
  ];
}
