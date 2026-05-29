import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sentry_dio/sentry_dio.dart';
import '../constants/app_constants.dart';
import 'okhttp_profiler_interceptor.dart';

/// Dio 网络客户端封装
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ─── 拦截器链 ───
    _dio.interceptors.addAll([
      // 1. OkHttp Profiler 桥接（仅 Android，让请求出现在 AS Profiler 中）
      if (Platform.isAndroid) OkHttpProfilerInterceptor(),

      // 2. Sentry 追踪（自动上报网络请求到 Sentry 后台）
      _sentryInterceptor(),

      // 3. 错误处理
      _ErrorInterceptor(),

      // 4. 控制台美化日志（仅 Debug 模式）
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);
  }

  /// 创建 Sentry Dio 拦截器
  Interceptor _sentryInterceptor() {
    return SentryTracingInterceptor(
      // Sentry 初始化后自动关联
    );
  }

  /// GET 请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST 请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT 请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE 请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

/// 错误处理拦截器
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: '连接超时，请检查网络',
          type: err.type,
        ));
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        String message;
        if (statusCode == 400) {
          message = '请求参数错误';
        } else if (statusCode == 401) {
          message = '未授权，请登录';
        } else if (statusCode == 403) {
          message = '拒绝访问';
        } else if (statusCode == 404) {
          message = '资源不存在';
        } else if (statusCode == 500) {
          message = '服务器内部错误';
        } else {
          message = '请求失败 ($statusCode)';
        }
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: message,
          type: err.type,
          response: err.response,
        ));
        break;
      case DioExceptionType.cancel:
        handler.next(err);
        break;
      default:
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: '网络异常，请检查网络连接',
          type: err.type,
        ));
        break;
    }
  }
}

/// Dio Client Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});
