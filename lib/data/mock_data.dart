import 'package:flutter/material.dart';

import 'feed_mock_data.dart';
import 'image_urls.dart';
import '../models/channel.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../theme/app_colors.dart';

class MockData {
  MockData._();

  static const int _iconCamera = 0xe3af;
  static const int _iconMug = 0xf092;
  static const int _iconPaw = 0xe91d;
  static const int _iconBag = 0xe59c;
  static const int _iconFilm = 0xe3a5;
  static const int _iconDesktop = 0xe30b;
  static const int _iconLeaf = 0xe6b7;
  static const int _iconBook = 0xe865;
  static const int _iconPen = 0xe745;
  static const int _iconCameraAlt = 0xe3b0;

  static List<Channel> get channels => [
        Channel(
          id: 'fashion',
          name: '穿搭达人',
          icon: Icons.checkroom,
          gradientColors: AppColors.channelFashion,
          category: '穿搭',
          coverUrl: ImageUrls.ootd,
        ),
        Channel(
          id: 'pet',
          name: '萌宠日常',
          icon: Icons.pets,
          gradientColors: AppColors.channelPet,
          category: '萌宠',
          coverUrl: ImageUrls.cat,
        ),
        Channel(
          id: 'food',
          name: '美食分享',
          icon: Icons.cake,
          gradientColors: AppColors.channelFood,
          category: '美食',
          coverUrl: ImageUrls.food,
        ),
        Channel(
          id: 'daily',
          name: '日常记录',
          icon: Icons.auto_awesome,
          gradientColors: const [Color(0xFFE8DFF5), Color(0xFFB5FFFC)],
          category: '日常',
          coverUrl: ImageUrls.flowers,
        ),
        Channel(
          id: 'travel',
          name: '旅行探店',
          icon: Icons.flight_takeoff,
          gradientColors: const [Color(0xFFDAF2EB), Color(0xFFFFE4DB)],
          category: '旅行',
          coverUrl: ImageUrls.trip,
        ),
        Channel(
          id: 'beauty',
          name: '美妆护肤',
          icon: Icons.face_retouching_natural,
          gradientColors: const [Color(0xFFFFDEE9), Color(0xFFFFC4D1)],
          category: '美妆',
          coverUrl: ImageUrls.flowers,
        ),
      ];

  static List<Post> get discoverPosts => [
        Post(
          id: 'disc_1',
          authorId: 'user_ottd',
          authorName: '穿搭女孩',
          authorAvatarChar: '穿',
          avatarGradientColors: [0xFFFF9EB5, 0xFFFF6B8B],
          content: '今日穿搭分享，温柔又显气质～',
          timeLabel: '1小时前',
          imageGradientColors: [0xFFFFDEE9, 0xFFB5FFFC],
          imageIcon: _iconCamera,
          imageLabel: '穿搭',
          imageHeight: 220,
          likeCount: 234,
          commentCount: 18,
          category: '穿搭',
          title: '秋日温柔穿搭',
          imageUrl: ImageUrls.ootd,
          avatarUrl: ImageUrls.avatarFashion,
        ),
        Post(
          id: 'disc_2',
          authorId: 'user_coffee',
          authorName: '咖啡控',
          authorAvatarChar: '咖',
          avatarGradientColors: [0xFFCE93D8, 0xFFBA68C8],
          content: '藏在巷子里的小众咖啡馆，拉花超治愈！',
          timeLabel: '3小时前',
          imageGradientColors: [0xFFFFE4DB, 0xFFFFF0EC],
          imageIcon: _iconMug,
          imageLabel: '咖啡',
          imageHeight: 180,
          likeCount: 5200,
          commentCount: 89,
          category: '美食',
          title: '治愈系咖啡馆',
          imageUrl: ImageUrls.cafe,
          avatarUrl: ImageUrls.avatarCoffee,
        ),
        Post(
          id: 'disc_3',
          authorId: 'user_cat',
          authorName: '喵星人',
          authorAvatarChar: '喵',
          avatarGradientColors: [0xFF80CBC4, 0xFF4DB6AC],
          content: '主子今天心情不错，赏脸让我撸了十分钟',
          timeLabel: '5小时前',
          imageGradientColors: [0xFFFCE1E4, 0xFFE8DFF5],
          imageIcon: _iconPaw,
          imageLabel: '萌宠',
          imageHeight: 250,
          likeCount: 89,
          commentCount: 6,
          category: '萌宠',
          title: '周末撸猫日记',
          imageUrl: ImageUrls.cat,
          avatarUrl: ImageUrls.avatarCat,
        ),
        Post(
          id: 'disc_4',
          authorId: 'user_shop',
          authorName: '购物狂',
          authorAvatarChar: '购',
          avatarGradientColors: [0xFFFFAB91, 0xFFFF8A65],
          content: '秋季必入清单，每一件都是心头好',
          timeLabel: '昨天',
          imageGradientColors: [0xFFFF9EB5, 0xFFFFC4D1],
          imageIcon: _iconBag,
          imageLabel: '购物',
          imageHeight: 190,
          likeCount: 1100,
          commentCount: 42,
          category: '穿搭',
          title: '秋季购物清单',
          imageUrl: ImageUrls.shopping,
          avatarUrl: ImageUrls.avatarShop,
        ),
        Post(
          id: 'disc_5',
          authorId: 'user_film',
          authorName: '胶片少女',
          authorAvatarChar: '胶',
          avatarGradientColors: [0xFF90CAF9, 0xFF64B5F6],
          content: '用复古胶片记录生活，颗粒感太美了',
          timeLabel: '2天前',
          imageGradientColors: [0xFFFFDEE9, 0xFFB5FFFC],
          imageIcon: _iconFilm,
          imageLabel: '胶片',
          imageHeight: 210,
          likeCount: 567,
          commentCount: 23,
          category: '日常',
          title: '绝美复古胶片风',
          imageUrl: ImageUrls.film,
          avatarUrl: ImageUrls.avatarFilm,
        ),
        Post(
          id: 'disc_6',
          authorId: 'user_desk',
          authorName: '桌面控',
          authorAvatarChar: '桌',
          avatarGradientColors: [0xFFB39DDB, 0xFF9575CD],
          content: '极简桌面布置，工作效率 up up',
          timeLabel: '3天前',
          imageGradientColors: [0xFFFFE4DB, 0xFFFFC4D1],
          imageIcon: _iconDesktop,
          imageLabel: '桌面',
          imageHeight: 240,
          likeCount: 890,
          commentCount: 31,
          category: '日常',
          title: '极简桌面布置',
          imageUrl: ImageUrls.desk,
          avatarUrl: ImageUrls.avatarDesk,
        ),
      ];

  static List<Post> get feedPosts => FeedMockData.posts;

  static List<Post> get favoritePosts => [
        Post(
          id: 'fav_1',
          authorId: 'user_film',
          authorName: '胶片少女',
          authorAvatarChar: '胶',
          avatarGradientColors: [0xFF90CAF9, 0xFF64B5F6],
          content: '用复古胶片记录生活',
          timeLabel: '2天前',
          imageGradientColors: [0xFFFFDEE9, 0xFFB5FFFC],
          imageIcon: _iconFilm,
          imageHeight: 200,
          likeCount: 567,
          title: '绝美复古胶片风',
          isFavorited: true,
          imageUrl: ImageUrls.film,
          avatarUrl: ImageUrls.avatarFilm,
        ),
        Post(
          id: 'fav_2',
          authorId: 'user_desk',
          authorName: '桌面控',
          authorAvatarChar: '桌',
          avatarGradientColors: [0xFFB39DDB, 0xFF9575CD],
          content: '极简桌面布置',
          timeLabel: '3天前',
          imageGradientColors: [0xFFFFE4DB, 0xFFFFC4D1],
          imageIcon: _iconDesktop,
          imageHeight: 240,
          likeCount: 890,
          title: '极简桌面布置',
          isFavorited: true,
          imageUrl: ImageUrls.desk,
          avatarUrl: ImageUrls.avatarDesk,
        ),
        Post(
          id: 'fav_3',
          authorId: 'user_trip',
          authorName: '郊游达人',
          authorAvatarChar: '郊',
          avatarGradientColors: [0xFFA5D6A7, 0xFF66BB6A],
          content: '周末郊游分享',
          timeLabel: '1周前',
          imageGradientColors: [0xFFDAF2EB, 0xFFD5E1DF],
          imageIcon: _iconLeaf,
          imageHeight: 180,
          likeCount: 432,
          title: '周末郊游分享',
          isFavorited: true,
          imageUrl: ImageUrls.trip,
          avatarUrl: ImageUrls.avatarTrip,
        ),
      ];

  static List<Post> get diaryPosts => [
        Post(
          id: 'diary_1',
          authorId: 'strawberry_001',
          authorName: '草莓布丁 🍓',
          authorAvatarChar: '莓',
          avatarGradientColors: [0xFFFFC4D1, 0xFFFF6B8B],
          content: '第一篇手帐，记录生活的开始',
          timeLabel: '3天前',
          imageGradientColors: [0xFFFFF0EC, 0xFFFFC4D1],
          imageIcon: _iconBook,
          imageHeight: 160,
          isMine: true,
          title: '第一篇手帐',
          imageUrl: ImageUrls.diaryBook,
          avatarUrl: ImageUrls.avatarMine,
        ),
        Post(
          id: 'diary_2',
          authorId: 'strawberry_001',
          authorName: '草莓布丁 🍓',
          authorAvatarChar: '莓',
          avatarGradientColors: [0xFFFFC4D1, 0xFFFF6B8B],
          content: '记录美好，每一天都值得被记住',
          timeLabel: '1周前',
          imageGradientColors: [0xFFE8DFF5, 0xFFFCE1E4],
          imageIcon: _iconPen,
          imageHeight: 210,
          isMine: true,
          title: '记录美好',
          imageUrl: ImageUrls.diaryPen,
          avatarUrl: ImageUrls.avatarMine,
        ),
        Post(
          id: 'diary_3',
          authorId: 'strawberry_001',
          authorName: '草莓布丁 🍓',
          authorAvatarChar: '莓',
          avatarGradientColors: [0xFFFFC4D1, 0xFFFF6B8B],
          content: '日常随拍，平凡日子里的闪光瞬间',
          timeLabel: '2周前',
          imageGradientColors: [0xFFDAF2EB, 0xFFFFE4DB],
          imageIcon: _iconCameraAlt,
          imageHeight: 180,
          isMine: true,
          title: '日常随拍',
          imageUrl: ImageUrls.diaryCamera,
          avatarUrl: ImageUrls.avatarMine,
        ),
      ];

  static Map<String, List<Comment>> get defaultComments => {
        ...FeedMockData.comments,
        'disc_1': [
          Comment(
            id: 'c4',
            authorName: '时尚日记',
            authorAvatarChar: '日',
            content: '太温柔了这套！',
            timeLabel: '30分钟前',
            avatarUrl: ImageUrls.avatarDiary,
          ),
        ],
      };

  static List<FollowUser> get followingUsers => [
        FollowUser(
          id: 'user_fashion',
          name: '时尚日记',
          avatarChar: '日',
          bio: '早秋穿搭 | 日常分享',
          avatarGradientColors: [0xFFCE93D8, 0xFFBA68C8],
          avatarUrl: ImageUrls.avatarDiary,
          isFollowing: true,
        ),
        FollowUser(
          id: 'user_pig',
          name: '甜心小猪',
          avatarChar: '猪',
          bio: '美食探店中...',
          avatarUrl: ImageUrls.avatarPig,
          isFollowing: true,
        ),
        FollowUser(
          id: 'user_film',
          name: '胶片少女',
          avatarChar: '胶',
          bio: '复古胶片爱好者',
          avatarGradientColors: [0xFF90CAF9, 0xFF64B5F6],
          avatarUrl: ImageUrls.avatarFilm,
          isFollowing: true,
        ),
      ];

  static List<FollowUser> get followerUsers => [
        FollowUser(
          id: 'user_coffee',
          name: '咖啡控',
          avatarChar: '咖',
          bio: '每天一杯拿铁',
          avatarGradientColors: [0xFFCE93D8, 0xFFBA68C8],
          avatarUrl: ImageUrls.avatarCoffee,
        ),
        FollowUser(
          id: 'user_cat',
          name: '喵星人',
          avatarChar: '喵',
          bio: '铲屎官日常',
          avatarGradientColors: [0xFF80CBC4, 0xFF4DB6AC],
          avatarUrl: ImageUrls.avatarCat,
        ),
        FollowUser(
          id: 'user_heal',
          name: '治愈系女孩',
          avatarChar: '治',
          bio: '贩卖日落和温柔',
          avatarGradientColors: [0xFF80CBC4, 0xFF4DB6AC],
          avatarUrl: ImageUrls.avatarHeal,
        ),
      ];

  static List<PostThemeOption> get postThemes => [
        PostThemeOption(
          label: '穿搭',
          icon: Icons.camera_alt,
          colors: AppColors.gradientOotd,
          imageUrl: ImageUrls.ootd,
        ),
        PostThemeOption(
          label: '咖啡',
          icon: Icons.local_cafe,
          colors: AppColors.gradientCafe,
          imageUrl: ImageUrls.cafe,
        ),
        PostThemeOption(
          label: '萌宠',
          icon: Icons.pets,
          colors: AppColors.gradientPets,
          imageUrl: ImageUrls.pets,
        ),
        PostThemeOption(
          label: '自然',
          icon: Icons.eco,
          colors: AppColors.gradientLeaf,
          imageUrl: ImageUrls.nature,
        ),
        PostThemeOption(
          label: '手帐',
          icon: Icons.auto_stories,
          colors: AppColors.gradientDiary1,
          imageUrl: ImageUrls.diaryBook,
        ),
      ];

  static List<Color> themeAccent(int index) {
    const themes = [
      AppColors.peach500,
      Color(0xFFCE93D8),
      Color(0xFF80CBC4),
      Color(0xFFFFAB91),
    ];
    return [themes[index % themes.length], themes[index % themes.length]];
  }
}

class PostThemeOption {
  const PostThemeOption({
    required this.label,
    required this.icon,
    required this.colors,
    required this.imageUrl,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final String imageUrl;
}

class FollowUser {
  const FollowUser({
    required this.id,
    required this.name,
    required this.avatarChar,
    this.bio = '',
    this.avatarGradientColors = const [0xFFFF9EB5, 0xFFFF6B8B],
    this.avatarUrl = '',
    this.isFollowing = false,
  });

  final String id;
  final String name;
  final String avatarChar;
  final String bio;
  final List<int> avatarGradientColors;
  final String avatarUrl;
  final bool isFollowing;
}
