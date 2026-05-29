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
}
