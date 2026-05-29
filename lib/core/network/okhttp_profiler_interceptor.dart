import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

/// OkHttp Profiler 桥接拦截器
///
/// 将 Dio 的网络请求数据按 OkHttp Profiler 的 Logcat 协议格式写入，
/// 通过 MethodChannel 调用 Android 原生 Log.v()，
/// 使网络请求出现在 Android Studio 的 OkHttp Profiler 中。
///
/// 仅在 Android 平台生效。
class OkHttpProfilerInterceptor extends Interceptor {
  static const MethodChannel _channel = MethodChannel('okhttp_profiler');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!Platform.isAndroid) {
      handler.next(options);
      return;
    }

    final id = _getRequestId(options);
    _logToProfiler(
      tag: 'OKPRFL_${id}_REQUEST_HEADER',
      message: _formatRequestHeaders(options),
    );

    if (options.data != null) {
      _logToProfiler(
        tag: 'OKPRFL_${id}_REQUEST_BODY',
        message: _formatBody(options.data),
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (!Platform.isAndroid) {
      handler.next(response);
      return;
    }

    final id = _getRequestId(response.requestOptions);
    _logToProfiler(
      tag: 'OKPRFL_${id}_RESPONSE_HEADER',
      message: _formatResponseHeaders(response),
    );

    _logToProfiler(
      tag: 'OKPRFL_${id}_RESPONSE_BODY',
      message: _formatBody(response.data),
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (Platform.isAndroid) {
      final id = _getRequestId(err.requestOptions);
      _logToProfiler(
        tag: 'OKPRFL_${id}_RESPONSE_HEADER',
        message: _formatErrorHeaders(err),
      );
      _logToProfiler(
        tag: 'OKPRFL_${id}_RESPONSE_BODY',
        message: '{"error":"${err.message}","type":"${err.type}"}',
      );
    }
    handler.next(err);
  }

  /// 生成请求唯一 ID（基于 URI hash）
  String _getRequestId(RequestOptions options) {
    return (options.uri.hashCode.abs() % 10000).toString().padLeft(4, '0');
  }

  /// 通过 MethodChannel 调用 Android Log.v()
  void _logToProfiler({required String tag, required String message}) {
    try {
      _channel.invokeMethod('log', {
        'tag': tag,
        'message': message,
      });
    } catch (e) {
      // MethodChannel 调用失败时静默处理，不影响正常请求
      // ignore: avoid_print
      print('OkHttpProfiler: Failed to log - $e');
    }
  }

  /// 格式化请求头
  String _formatRequestHeaders(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.writeln('${options.method} ${options.uri}');
    options.headers.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString().trimRight();
  }

  /// 格式化响应头
  String _formatResponseHeaders(Response response) {
    final buffer = StringBuffer();
    buffer.writeln(
        '${response.requestOptions.method} ${response.statusCode} ${response.statusMessage}');
    response.headers.map.forEach((key, values) {
      buffer.writeln('$key: ${values.join(", ")}');
    });
    return buffer.toString().trimRight();
  }

  /// 格式化错误头
  String _formatErrorHeaders(DioException err) {
    final buffer = StringBuffer();
    buffer.writeln(
        '${err.requestOptions.method} ${err.type} ${err.message}');
    if (err.response?.headers != null) {
      err.response!.headers.map.forEach((key, values) {
        buffer.writeln('$key: ${values.join(", ")}');
      });
    }
    return buffer.toString().trimRight();
  }

  /// 格式化请求/响应体
  String _formatBody(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    return data.toString();
  }
}
