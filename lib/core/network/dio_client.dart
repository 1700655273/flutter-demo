import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

/// Dio 网络客户端封装
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout.inMilliseconds,
        receiveTimeout: AppConstants.receiveTimeout.inMilliseconds,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.addAll([
      _LogInterceptor(),
      _ErrorInterceptor(),
    ]);
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

/// 日志拦截器
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌── HTTP REQUEST ── ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('├── HTTP RESPONSE ── ${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint('└── HTTP ERROR ── ${err.type} ${err.message}');
    handler.next(err);
  }
}

/// 错误处理拦截器
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        handler.next(DioError(
          requestOptions: err.requestOptions,
          error: '连接超时，请检查网络',
          type: err.type,
        ));
        break;
      case DioErrorType.response:
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
        handler.next(DioError(
          requestOptions: err.requestOptions,
          error: message,
          type: err.type,
          response: err.response,
        ));
        break;
      case DioErrorType.cancel:
        handler.next(err);
        break;
      default:
        handler.next(DioError(
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
