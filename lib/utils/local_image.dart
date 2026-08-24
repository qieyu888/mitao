import 'dart:io';

import 'package:flutter/material.dart';

bool isLocalImagePath(String url) =>
    url.startsWith('/') || url.startsWith('file://');

String localImageFilePath(String url) =>
    url.startsWith('file://') ? url.substring(7) : url;

/// 网络图 / 本地文件图统一展示
class FlexibleImage extends StatelessWidget {
  const FlexibleImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.errorBuilder,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    if (isLocalImagePath(imageUrl)) {
      return Image.file(
        File(localImageFilePath(imageUrl)),
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        errorBuilder: errorBuilder,
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      gaplessPlayback: true,
      errorBuilder: errorBuilder,
    );
  }
}
