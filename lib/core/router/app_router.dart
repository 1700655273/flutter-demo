import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/counter/presentation/pages/counter_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/animation/presentation/pages/animation_page.dart';

/// 全局导航 Key
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// 当前路由位置 Provider（用于底部导航同步）
final currentLocationProvider = StateProvider<String>((ref) => '/');

/// 路由配置 - GoRouter
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          // 更新当前路由位置
          ref.read(currentLocationProvider.notifier).state = state.location;
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/counter',
            name: 'counter',
            builder: (context, state) => const CounterPage(),
          ),
          GoRoute(
            path: '/users',
            name: 'users',
            builder: (context, state) => const UsersPage(),
          ),
          GoRoute(
            path: '/animation',
            name: 'animation',
            builder: (context, state) => const AnimationPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '页面不存在',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('路径: ${state.location}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// 底部导航 Shell - 保持底部导航栏状态
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({Key? key, required this.child}) : super(key: key);

  int _getCurrentIndex(String location) {
    if (location.startsWith('/counter')) return 1;
    if (location.startsWith('/users')) return 2;
    if (location.startsWith('/animation')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(currentLocationProvider);
    final currentIndex = _getCurrentIndex(location);
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/counter');
              break;
            case 2:
              context.go('/users');
              break;
            case 3:
              context.go('/animation');
              break;
            case 4:
              context.go('/settings');
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            selectedIcon:
                Icon(Icons.home, color: theme.colorScheme.primary),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline,
                color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.add_circle,
                color: theme.colorScheme.primary),
            label: '计数器',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline,
                color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.people,
                color: theme.colorScheme.primary),
            label: '用户',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.animation,
                color: theme.colorScheme.primary),
            label: '动画',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined,
                color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.settings,
                color: theme.colorScheme.primary),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
