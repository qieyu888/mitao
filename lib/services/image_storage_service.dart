import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 将相册图片复制到应用文档目录，持久化本地路径
class ImageStorageService {
  ImageStorageService._();

  static Future<String> saveImage(File source, {required String prefix}) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(dir.path, 'user_images'));
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final ext = p.extension(source.path);
    final safeExt = ext.isNotEmpty ? ext : '.jpg';
    final name = '${prefix}_${DateTime.now().millisecondsSinceEpoch}$safeExt';
    final dest = File(p.join(folder.path, name));
    await source.copy(dest.path);
    return dest.path;
  }

  static Future<String> savePostImage(File source) =>
      saveImage(source, prefix: 'post');

  static Future<String> saveAvatarImage(File source) =>
      saveImage(source, prefix: 'avatar');
}
