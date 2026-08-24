/// 动态配图：每条动态用语义关键词 + lock 保证稳定，避免随机图
class ImageUrls {
  ImageUrls._();

  static String _u(String photoId, {int w = 800, int h = 600}) =>
      'https://images.unsplash.com/$photoId'
      '?auto=format&fit=crop&w=$w&h=$h&q=80';

  /// 关键词图（lock 与 feed 编号对应，保证每次加载同一张）
  static String _kw(String keywords, {required int lock, int w = 800, int h = 600}) =>
      'https://loremflickr.com/$w/$h/$keywords?lock=$lock';

  static String _avatar(String photoId) => _u(photoId, w: 200, h: 200);

  static String avatarSeed(String name) =>
      'https://picsum.photos/seed/bubble_av_$name/200/200';

  static String seed(String name, {int w = 800, int h = 600}) =>
      'https://picsum.photos/seed/bubble_$name/$w/$h';

  // ── 引导页 / 分类兜底（已验证 Unsplash）──
  static final afternoonTea = _u('photo-1555507036-ab1f4038808a');
  static final ootd = _u('photo-1487222477894-8943e31ef7b2');
  static final cafe = _u('photo-1509042239860-f550ce710b93');
  static final cat = _u('photo-1514888286974-6c03e2ca1dba');
  static final nature = _u('photo-1441974231531-c6227db76b6e');
  static final diaryBook = _u('photo-1544947950-fa07a98d237f');
  static final diaryPen = _kw('journal,notebook,pen', lock: 102);
  static final diaryCamera = _u('photo-1526170375885-4d8ecf77b99f');
  static final food = _u('photo-1504674900247-0877df9cc836');
  static final trip = _u('photo-1506905925346-21bda4d32df4');
  static final shopping = _u('photo-1445205170230-053b83016050');
  static final film = _u('photo-1452587925148-ce544e77e70d');
  static final desk = _kw('desk,workspace,minimal', lock: 8);
  static final flowers = _kw('flower,bouquet', lock: 14);
  static final pets = _kw('shiba,dog', lock: 22);
  static final nails = _kw('manicure,nails', lock: 21);

  /// 每条动态专属语义关键词（与 feed_mock_data 文案一一对应）
  static const Map<String, String> _feedKeywords = {
    'feed_1': 'afternoon,tea,dessert,cake', // 下午茶甜品
    'feed_2': 'autumn,fashion,outfit', // 早秋穿搭
    'feed_3': 'sunset,pink,sky', // 粉色日落
    'feed_4': 'latte,coffee,cafe', // 咖啡馆拿铁
    'feed_5': 'cat,kitten,pet', // 猫咪
    'feed_6': 'sweater,skirt,knitwear', // 针织衫半裙
    'feed_7': 'film,camera,vintage', // 胶片相机
    'feed_8': 'desk,workspace,minimal', // 书桌布置
    'feed_9': 'mountain,hiking,green', // 山里郊游
    'feed_10': 'shopping,bags,fashion', // 购物清单
    'feed_11': 'cake,baking,chiffon', // 戚风蛋糕
    'feed_12': 'reading,book,cozy', // 雨天看书
    'feed_13': 'yoga,stretching,morning', // 瑜伽晨练
    'feed_14': 'flower,bouquet,floral', // 花束插花
    'feed_15': 'film,camera,retro', // 胶片相机
    'feed_16': 'camping,tent,stars', // 露营星空
    'feed_17': 'hanfu,chinese,traditional', // 汉服古镇
    'feed_18': 'skateboard,sunset,park', // 滑板公园
    'feed_19': 'gym,workout,fitness', // 健身训练
    'feed_20': 'brunch,eggs,breakfast', // 班尼迪克蛋
    'feed_21': 'manicure,nails,nude', // 裸色美甲
    'feed_22': 'shiba,dog,park', // 柴犬公园
    'feed_23': 'vinyl,record,turntable', // 黑胶唱片
    'feed_24': 'monstera,plant,indoor', // 龟背竹绿植
    'feed_25': 'beach,sunset,ocean', // 海边日落
    'feed_26': 'vintage,denim,jacket', // 牛仔外套（已验证）
    'feed_27': 'study,library,books', // 自习学习
    'feed_28': 'hotpot,chinese,food', // 火锅
    'feed_29': 'snow,winter,landscape', // 初雪
    'feed_30': 'night,city,running', // 夜跑城市
  };

  /// 萌友圈每条动态专属配图
  static String feedImage(String feedId) {
    final keywords = _feedKeywords[feedId];
    if (keywords == null) return nature;
    final lock = int.tryParse(feedId.replaceFirst('feed_', '')) ?? 1;
    return _kw(keywords, lock: lock);
  }

  // ── 用户头像 ──
  static final avatarFashion = _avatar('photo-1494790108377-be9c29b29330');
  static final avatarCoffee = _avatar('photo-1438761681033-6461ffad8d80');
  static final avatarCat = _avatar('photo-1534528741775-53994a69daeb');
  static final avatarShop = _avatar('photo-1524504388940-b1c1722653e1');
  static final avatarFilm = _avatar('photo-1507003211169-0a1dd7228f2d');
  static final avatarDesk = _avatar('photo-1487412720507-e7ab37603c6f');
  static final avatarPig = _avatar('photo-1517841905240-472988babdf9');
  static final avatarDiary = _avatar('photo-1529626455594-4ff0802cfb7e');
  static final avatarHeal = _avatar('photo-1544005313-94ddf0286df2');
  static final avatarTrip = _avatar('photo-1506794778202-cad84cf45f1d');
  static final avatarMine = _avatar('photo-1487412720507-e7ab37603c6f');

  static String forCategory(String category) {
    switch (category) {
      case '穿搭':
        return ootd;
      case '美食':
        return food;
      case '萌宠':
        return cat;
      case '旅行':
        return trip;
      case '美妆':
        return nails;
      case '日常':
        return nature;
      default:
        return nature;
    }
  }

  static bool isLegacyImageUrl(String url) =>
      url.isEmpty || url.contains('picsum.photos');
}
