import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';

/// 设置页面 - 展示主题切换、本地存储
class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // ─── 主题设置 ───
          _SectionHeader(title: '外观'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    ThemeModeOption.fromThemeMode(themeMode).icon,
                    color: colorScheme.primary,
                  ),
                  title: const Text('主题模式'),
                  subtitle: Text(
                    ThemeModeOption.fromThemeMode(themeMode).label,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemePicker(context, ref, themeMode),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ─── 技术栈说明 ───
          _SectionHeader(title: '技术栈'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                _TechItem(
                  icon: Icons.account_tree,
                  title: '架构模式',
                  subtitle: 'Clean Architecture',
                  color: colorScheme.primary,
                ),
                const Divider(indent: 56),
                _TechItem(
                  icon: Icons.water_drop,
                  title: '状态管理',
                  subtitle: 'Riverpod (StateNotifier + Provider)',
                  color: colorScheme.tertiary,
                ),
                const Divider(indent: 56),
                _TechItem(
                  icon: Icons.route,
                  title: '路由管理',
                  subtitle: 'GoRouter (声明式路由)',
                  color: colorScheme.secondary,
                ),
                const Divider(indent: 56),
                _TechItem(
                  icon: Icons.cloud,
                  title: '网络请求',
                  subtitle: 'Dio (拦截器 + 错误处理)',
                  color: colorScheme.error,
                ),
                const Divider(indent: 56),
                _TechItem(
                  icon: Icons.storage,
                  title: '本地存储',
                  subtitle: 'SharedPreferences',
                  color: colorScheme.primaryContainer,
                ),
                const Divider(indent: 56),
                _TechItem(
                  icon: Icons.palette,
                  title: 'UI 框架',
                  subtitle: 'Material 3 (动态色彩)',
                  color: colorScheme.tertiaryContainer,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ─── 项目结构 ───
          _SectionHeader(title: '项目结构'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'lib/\n'
                  '├── core/           # 核心层\n'
                  '│   ├── theme/      # 主题配置\n'
                  '│   ├── network/    # 网络封装\n'
                  '│   ├── router/     # 路由配置\n'
                  '│   ├── constants/  # 常量定义\n'
                  '│   └── utils/      # 工具类\n'
                  '├── features/       # 功能模块\n'
                  '│   ├── home/       # 首页\n'
                  '│   ├── counter/    # 计数器\n'
                  '│   ├── users/      # 用户管理\n'
                  '│   │   ├── data/   # 数据层\n'
                  '│   │   ├── domain/ # 领域层\n'
                  '│   │   └── presentation/ # 展示层\n'
                  '│   ├── animation/  # 动画\n'
                  '│   └── settings/   # 设置\n'
                  '└── shared/         # 共享组件',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.6,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ─── 关于 ───
          _SectionHeader(title: '关于'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: colorScheme.primary),
                  title: const Text('版本'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(indent: 56),
                ListTile(
                  leading: Icon(Icons.code, color: colorScheme.primary),
                  title: const Text('框架'),
                  subtitle: const Text('Flutter 3.0.0 + Dart 2.17.0'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode current) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '选择主题模式',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...ThemeModeOption.values.map((option) {
                return ListTile(
                  leading: Icon(option.icon),
                  title: Text(option.label),
                  trailing: current == option.toThemeMode()
                      ? Icon(Icons.check,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    ref.read(themeProvider.notifier).setTheme(option);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

/// 分组标题
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// 技术项
class _TechItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _TechItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
