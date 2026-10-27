import 'package:dio/dio.dart';
import 'package:loyaltri_minimal/utils/api_constants.dart';

import 'logging_interceptor.dart';

class DioClient {
  DioClient._();
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants().growth,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: ApiConstants().apiHeader,
      ),
    );

    dio.interceptors.addAll([
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
