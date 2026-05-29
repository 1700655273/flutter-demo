import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 横幅数据模型
class BannerItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });
}

/// 首页横幅 Provider
final homeBannerProvider = Provider<List<BannerItem>>((ref) {
  return const [
    BannerItem(
      title: 'Flutter 3.0',
      subtitle: '使用最新 Flutter 框架构建跨平台应用',
      icon: Icons.flutter_dash,
      colors: [Color(0xFF6750A4), Color(0xFF9A82DB)],
    ),
    BannerItem(
      title: 'Clean Architecture',
      subtitle: '分层架构，职责分离，易于测试和维护',
      icon: Icons.account_tree,
      colors: [Color(0xFF7D5260), Color(0xFFB5838D)],
    ),
    BannerItem(
      title: 'Material 3',
      subtitle: '全新的动态色彩设计系统',
      icon: Icons.palette,
      colors: [Color(0xFF006493), Color(0xFF4DA8DA)],
    ),
  ];
});
