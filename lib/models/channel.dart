import 'package:flutter/material.dart';

/// 热门频道
class Channel {
  const Channel({
    required this.id,
    required this.name,
    required this.icon,
    required this.gradientColors,
    this.category = '',
    this.coverUrl = '',
  });

  final String id;
  final String name;
  final IconData icon;
  final List<Color> gradientColors;
  final String category;
  final String coverUrl;
}
