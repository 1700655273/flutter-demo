import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

void main() async {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // 初始化 Sentry（远程日志 & 错误追踪）
  // 如果 Sentry DSN 未配置（仍为占位符），则跳过初始化
  final isSentryConfigured =
      !AppConstants.sentryDsn.contains('examplePublicKey');

  if (isSentryConfigured) {
    await SentryFlutter.init(
      (options) {
        options.dsn = AppConstants.sentryDsn;
        options.tracesSampleRate = 1.0; // 100% 追踪采样率（生产环境可降低）
        options.profilesSampleRate = 1.0;
      },
      appRunner: () => _runApp(sharedPreferences),
    );
  } else {
    _runApp(sharedPreferences);
  }
}

void _runApp(SharedPreferences sharedPreferences) {
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

/// 应用根组件
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      // ─── 基础配置 ───
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      // ─── 主题 ───
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // ─── 路由 ───
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,

      // ─── Sentry 导航追踪 ───
      navigatorObservers: [
        SentryNavigatorObserver(),
      ],
    );
  }
}
