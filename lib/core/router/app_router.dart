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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/counter',
                name: 'counter',
                builder: (context, state) => const CounterPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/users',
                name: 'users',
                builder: (context, state) => const UsersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/animation',
                name: 'animation',
                builder: (context, state) => const AnimationPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
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
            Text('路径: ${state.matchedLocation}'),
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

/// 底部导航 Shell - 使用 StatefulNavigationShell 保持分支状态
class AppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
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
