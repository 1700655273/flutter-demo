/// 应用常量
class AppConstants {
  AppConstants._();

  static const String appName = 'Flutter Demo';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // 本地存储 Key
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';

  // Sentry - 远程日志 & 错误追踪
  // 替换为你自己的 Sentry DSN（在 https://sentry.io 创建项目后获取）
  static const String sentryDsn = 'https://examplePublicKey@o0.ingest.sentry.io/0';
}
