import '../models/post.dart';
import 'image_urls.dart';

/// 发现页推荐数据：每个频道约 20 条
class DiscoverMockData {
  DiscoverMockData._();

  static const int _iconCamera = 0xe3af;
  static const int _iconMug = 0xf092;
  static const int _iconPaw = 0xe91d;
  static const int _iconDesktop = 0xe30b;
  static const int _iconLeaf = 0xe6b7;
  static const int _iconBook = 0xe865;
  static const int _iconFace = 0xe59c;

  static const _peach = [0xFFFF9EB5, 0xFFFF6B8B];
  static const _purple = [0xFFCE93D8, 0xFFBA68C8];
  static const _teal = [0xFF80CBC4, 0xFF4DB6AC];
  static const _blue = [0xFF90CAF9, 0xFF64B5F6];
  static const _lavender = [0xFFB39DDB, 0xFF9575CD];
  static const _orange = [0xFFFFAB91, 0xFFFF8A65];
  static const _green = [0xFFA5D6A7, 0xFF66BB6A];

  static const _authors = <(String, String, String, List<int>, String)>[
    ('user_ottd', '穿搭女孩', '穿', _peach, 'ootd'),
    ('user_fashion', '时尚日记', '日', _purple, 'fashion'),
    ('user_coffee', '咖啡控', '咖', _purple, 'coffee'),
    ('user_cat', '喵星人', '喵', _teal, 'cat'),
    ('user_shop', '购物狂', '购', _orange, 'shop'),
    ('user_film', '胶片少女', '胶', _blue, 'film'),
    ('user_desk', '桌面控', '桌', _lavender, 'desk'),
    ('user_trip', '郊游达人', '郊', _green, 'trip'),
    ('user_heal', '治愈系女孩', '治', _teal, 'heal'),
    ('user_pig', '甜心小猪', '猪', _peach, 'pig'),
    ('user_nail', '美甲达人', '甲', _purple, 'nail'),
    ('user_gym', '健身教练', '健', _teal, 'gym'),
    ('user_read', '读书女孩', '书', _lavender, 'read'),
    ('user_sea', '海边女孩', '海', _teal, 'sea'),
    ('user_dog', '柴犬妈妈', '柴', _orange, 'dog'),
    ('user_plant', '绿植爱好者', '植', _green, 'plant'),
  ];

  static const _times = [
    '刚刚',
    '20分钟前',
    '1小时前',
    '2小时前',
    '3小时前',
    '5小时前',
    '8小时前',
    '昨天',
    '2天前',
    '3天前',
  ];

  static const _heights = [
    180.0,
    195.0,
    210.0,
    220.0,
    235.0,
    250.0,
    265.0,
    280.0,
  ];

  static const _channels = <_ChannelPack>[
    _ChannelPack(
      category: '穿搭',
      icon: _iconCamera,
      gradient: [0xFFFFDEE9, 0xFFB5FFFC],
      items: [
        ('秋日温柔穿搭', '今日穿搭分享，温柔又显气质'),
        ('奶油色针织套装', '针织衫配半裙，秋风里刚刚好'),
        ('街拍灵感合集', '周末街拍，记录城市里的自己'),
        ('早秋大衣Look', '一件大衣撑起整套造型'),
        ('牛仔外套日记', 'vintage 牛仔外套，越穿越有味道'),
        ('汉服古镇写真', '穿汉服去古镇，像走进画里'),
        ('通勤简约风', '上班也能穿得清爽利落'),
        ('周末运动鞋搭', '运动鞋也能很时髦'),
        ('包包种草清单', '本季值得入手的几款包包'),
        ('围巾叠穿技巧', '一条围巾让造型立刻升温'),
        ('白衬衫百搭法', '白衬衫永远不会出错'),
        ('裙装季节限定', '半裙季节到了，裙子安排上'),
        ('鞋履选择指南', '一双好鞋决定整套气质'),
        ('配饰点睛术', '耳环项链小细节最加分'),
        ('复古穿搭灵感', '从旧物市场淘来的灵感'),
        ('针织开衫日常', '软软的开衫，想每天都穿'),
        ('镜前OOTD', '出门前随手拍一组今日穿搭'),
        ('冬日叠穿公式', '内搭外穿层次感拉满'),
        ('粉色系穿搭', '温柔粉色控集合'),
        ('约会穿搭参考', '今晚约会就按这套来'),
      ],
    ),
    _ChannelPack(
      category: '美食',
      icon: _iconMug,
      gradient: [0xFFFFF0EC, 0xFFFFE4DB],
      items: [
        ('治愈系咖啡馆', '巷子里的小众咖啡馆，拉花满分'),
        ('周末Brunch', '班尼迪克蛋永远的神'),
        ('冬日火锅局', '降温就要吃火锅，牛油锅底YYDS'),
        ('戚风蛋糕初尝试', '第一次做戚风，居然成功了'),
        ('法式千层蛋糕', '这家甜品店的千层绝了'),
        ('拉面深夜食堂', '深夜一碗拉面，治愈疲惫'),
        ('寿司拼盘日记', '周末自己卷寿司也太开心'),
        ('水果下午茶', '新鲜水果配红茶，心情变好'),
        ('烘焙开箱日', '新模具到了，准备开烤'),
        ('健康轻食碗', '忙起来也要好好吃饭'),
        ('饺子团圆夜', '包饺子的手艺又进步了'),
        ('巧克力熔岩', '切开流心的那一刻最幸福'),
        ('手工面包香', '厨房飘满面包香'),
        ('夏日冰沙', '一杯冰沙压住暑气'),
        ('烤肉派对', '和朋友一起烧烤的夜晚'),
        ('马卡龙试吃', '马卡龙颜值先赢一半'),
        ('暖胃汤品', '下雨天就想喝一碗热汤'),
        ('海鲜大餐', '新鲜海鲜摆满桌'),
        ('探店笔记', '又打卡一家宝藏小馆'),
        ('深夜甜品', '加班结束奖励自己一块蛋糕'),
      ],
    ),
    _ChannelPack(
      category: '萌宠',
      icon: _iconPaw,
      gradient: [0xFFFCE1E4, 0xFFE8DFF5],
      items: [
        ('周末撸猫日记', '主子今天心情不错，赏脸让我撸'),
        ('柴犬公园日记', '带柴柴去公园，开心到模糊'),
        ('柯基短腿摇', '短腿小屁股摇起来，治愈一整天'),
        ('小猫午睡时光', '阳光里的小猫睡得好香'),
        ('新领养的兔兔', '软软一团，心里也软了'),
        ('仓鼠粮仓日常', '小仓鼠又在囤粮了'),
        ('窗边晒太阳猫', '主子霸占了最好的位置'),
        ('狗狗散步打卡', '傍晚散步是每天的仪式感'),
        ('幼猫纸箱乐园', '纸箱比玩具好玩一百倍'),
        ('狗狗第一次见海', '海边第一次，兴奋得停不下来'),
        ('波斯猫梳毛日', '梳毛也要优雅进行'),
        ('贵宾犬造型日', '修剪完精神多了'),
        ('猫抓板战争', '又一个抓板光荣退役'),
        ('沙滩奔跑狗', '沙子里快乐撒欢'),
        ('兔子蹦跳时刻', '突然起飞的小兔子'),
        ('沙发猫咪团', '沙发已经被猫占领'),
        ('狗狗微笑杀', '看完心情瞬间变好'),
        ('纸箱小猫咪', '箱子里的小惊喜'),
        ('宠物咖啡馆', '边喝咖啡边吸猫'),
        ('萌宠写真集', '给主子拍一组写真'),
      ],
    ),
    _ChannelPack(
      category: '日常',
      icon: _iconDesktop,
      gradient: [0xFFFFE4DB, 0xFFFFC4D1],
      items: [
        ('极简桌面布置', '新布置的书桌，效率 up up'),
        ('粉色晚霞日记', '今天的日落把心情染成粉色'),
        ('阳台绿植角', '龟背竹又长新叶了'),
        ('雨天读书时光', '雨天最适合窝着看书'),
        ('胶片相机日常', '新入的胶片机，颜值即正义'),
        ('黑胶唱片夜', '黑胶加暖黄灯光，今晚歌单'),
        ('清晨咖啡仪式', '起床第一件事是冲杯咖啡'),
        ('窗边光影', '午后阳光落在桌面上刚刚好'),
        ('花瓶插花日', '把春天留在房间里'),
        ('香薰放松夜', '点上香薰，慢慢收尾一天'),
        ('手写计划本', '把本周计划写清楚更安心'),
        ('城市夜景漫步', '下班后走走也很治愈'),
        ('听雨日记', '靠窗听雨，什么都不想'),
        ('阳台晚风', '晚风吹过绿植，舒服'),
        ('房间角落改造', '多放一盏灯，氛围感立刻上来'),
        ('午后红茶', '一杯红茶配一本闲书'),
        ('天空观云', '今天的云像棉花糖'),
        ('居家慢生活', '周末就该慢一点'),
        ('早起街道', '清晨的街很安静很干净'),
        ('随手拍瞬间', '平凡日子里的小闪光'),
      ],
    ),
    _ChannelPack(
      category: '旅行',
      icon: _iconLeaf,
      gradient: [0xFFDAF2EB, 0xFFB5FFFC],
      items: [
        ('粉色海边日落', '海边的浪花和晚霞都是粉色的'),
        ('山里吸氧日', '满眼绿色，呼吸都变轻了'),
        ('古镇慢游', '小巷石板路和午后阳光'),
        ('第一次露营', '星空下的晚餐太浪漫了'),
        ('湖边散步', '湖面倒影像一面镜子'),
        ('寺庙半日游', '安静的午后特别适合走走'),
        ('欧洲街角', '转角遇到的小咖啡馆'),
        ('森林步道', '树荫下走路特别舒服'),
        ('小岛短途', '坐船去小岛吹海风'),
        ('火车慢旅行', '看窗外风景一路晃过去'),
        ('酒店窗景', '拉开窗帘就是风景'),
        ('瀑布打卡', '水声把城市噪音都冲走了'),
        ('沙漠日落', '金色沙丘和晚霞绝配'),
        ('雪山初见', '第一次看到雪山有点震撼'),
        ('市集漫逛', '路边摊和小店最有意思'),
        ('跨桥夜景', '夜里的桥灯连成线'),
        ('乡村周末', '田野味道让人放松'),
        ('港口傍晚', '渔船归港的傍晚很安静'),
        ('花园散步', '植物园里拍了很多花'),
        ('旅行手记', '把一路见闻都记下来'),
      ],
    ),
    _ChannelPack(
      category: '美妆',
      icon: _iconFace,
      gradient: [0xFFFFDEE9, 0xFFFFC4D1],
      items: [
        ('裸色美甲分享', '新做的美甲，温柔裸色系'),
        ('换季护肤分享', '稳住屏障最重要'),
        ('今日唇色', '这支口红显白又日常'),
        ('香水试香笔记', '木质调越闻越上头'),
        ('化妆刷收纳', '刷具摆整齐心情也好'),
        ('精华空瓶记', '这瓶精华用完会回购'),
        ('妆前准备', '护肤到位，底妆才服帖'),
        ('眼影盘试色', '大地色盘最百搭'),
        ('面霜质地测评', '秋冬就爱这种滋润感'),
        ('美甲灵感板', '下周想做这款渐变'),
        ('红唇挑战日', '大胆一点也很好看'),
        ('梳妆台好物', '最近爱用的几样'),
        ('面膜放松夜', '敷面膜的半小时属于自己'),
        ('腮红气色感', '轻轻扫一点就有精神'),
        ('水乳搭配法', '简单两步也能养出水光'),
        ('眼线画法练习', '今天终于画对称了'),
        ('保湿重点攻略', '干燥天先把保湿做好'),
        ('化妆包出门装', '出差也要带齐基础款'),
        ('底妆持妆测试', '忙了一天还是挺服帖'),
        ('护发日常', '发尾护理不能偷懒'),
      ],
    ),
    _ChannelPack(
      category: '运动',
      icon: _iconLeaf,
      gradient: [0xFFDAF2EB, 0xFFD5E1DF],
      items: [
        ('今日健身打卡', '训练完成，流汗的感觉太爽了'),
        ('晨练拉伸', '新的一天从拉伸开始'),
        ('清晨慢跑', '公园慢跑三公里，空气真好'),
        ('普拉提初体验', '核心力量被唤醒了'),
        ('周末骑行', '沿河骑行吹风特别爽'),
        ('游泳解压日', '游完整个人轻松很多'),
        ('徒步轻装行', '轻装徒步看山看水'),
        ('力量训练日', '哑铃日，稳步加重量'),
        ('瑜伽跟练', '呼吸放慢，动作更稳'),
        ('晨跑打卡', '坚持晨跑的第 30 天'),
        ('居家训练', '下雨就在家练核心'),
        ('篮球局', '和朋友约了一场球'),
        ('网球入门', '第一次上场手感还行'),
        ('滑板黄昏场', '夕阳下的滑板公园'),
        ('攀岩体验课', '手指都在发力'),
        ('舞蹈课日常', '跳完大汗淋漓超解压'),
        ('拳击燃脂', '出拳的节奏感很好玩'),
        ('划船机训练', '有氧加力量一次搞定'),
        ('山路慢跑', '山路风景比跑步机有趣'),
        ('居家拉伸夜', '睡前拉伸，睡得更沉'),
      ],
    ),
    _ChannelPack(
      category: '手帐',
      icon: _iconBook,
      gradient: [0xFFFFF0EC, 0xFFFFC4D1],
      items: [
        ('雨天读书手帐', '把今天读到的句子抄下来'),
        ('排版灵感页', '这一页排版花了两小时'),
        ('贴纸开箱', '新贴纸到了，开箱快乐'),
        ('拼贴日记', '把票根和照片贴进本子'),
        ('钢笔试写', '新笔下水很顺'),
        ('和纸胶带分享', '这卷胶带颜色太温柔'),
        ('周计划手帐', '把下周安排写清楚'),
        ('可爱贴纸墙', '空白页瞬间热闹起来'),
        ('子弹笔记法', '一点一点记录小目标'),
        ('翻开旧日记', '翻到去年今天有点感慨'),
        ('练字半小时', '写字能让人安静下来'),
        ('桌面手帐角', '手帐工具摆整齐了'),
        ('月历装饰', '本月月历页完成'),
        ('旅行手帐页', '把旅途照片做成一页'),
        ('墨水试色', '新墨水色号很好看'),
        ('文具收纳法', '笔和本子终于不乱了'),
        ('手写感想', '写下来比发朋友圈更私密'),
        ('纸艺小制作', '自己做了一张卡片'),
        ('咖啡店手帐', '咖啡馆适合慢慢写'),
        ('贴纸排版练习', '又学会一种新排版'),
      ],
    ),
  ];

  static List<Post> get posts {
    final result = <Post>[];
    var globalIndex = 0;

    for (final channel in _channels) {
      for (var i = 0; i < channel.items.length; i++) {
        final item = channel.items[i];
        final author = _authors[globalIndex % _authors.length];
        final title = item.$1;
        final content = item.$2;
        final height = _heights[(globalIndex + i) % _heights.length];
        final likes = 80 + ((globalIndex * 37 + i * 19) % 4800);
        final comments = 3 + ((globalIndex * 11 + i * 7) % 180);

        result.add(
          Post(
            id: 'disc_${channel.category}_$i',
            authorId: author.$1,
            authorName: author.$2,
            authorAvatarChar: author.$3,
            avatarGradientColors: author.$4,
            content: content,
            timeLabel: _times[globalIndex % _times.length],
            imageGradientColors: channel.gradient,
            imageIcon: channel.icon,
            imageLabel: channel.category,
            imageHeight: height,
            likeCount: likes,
            commentCount: comments,
            category: channel.category,
            title: title,
            imageUrl: ImageUrls.discoverImage(channel.category, i),
            avatarUrl: ImageUrls.avatarSeed(author.$5),
          ),
        );
        globalIndex++;
      }
    }

    return result;
  }
}

class _ChannelPack {
  const _ChannelPack({
    required this.category,
    required this.icon,
    required this.gradient,
    required this.items,
  });

  final String category;
  final int icon;
  final List<int> gradient;
  final List<(String, String)> items;
}
