import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('➡️ ${options.method} ${options.uri}');
    log('Headers: ${options.headers}');
    log('Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ ${response.statusCode} ${response.requestOptions.uri}');
    log('Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('❌ ${err.requestOptions.uri}');
    log('Error: ${err.message}');
    super.onError(err, handler);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // You can map errors here later to Failure classes
    handler.next(err);
  }
}

