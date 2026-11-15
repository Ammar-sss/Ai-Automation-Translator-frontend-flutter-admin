import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smart_translater_admin/core/config/env.dart';
import 'package:smart_translater_admin/core/network/auth_interceptor.dart';
import 'package:smart_translater_admin/core/storage/secure_storage_service.dart';

class DioClient {
  final Dio dio;

  DioClient({required SecureStorageService storageService, Dio? customDio})
    : dio =
          customDio ??
          Dio(
            BaseOptions(
              baseUrl: Env.apiBaseUrl,
              connectTimeout: Env.connectTimeout,
              receiveTimeout: Env.receiveTimeout,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
              },
            ),
          ) {
    dio.interceptors.add(
      AuthInterceptor(storageService: storageService, dio: dio),
    );

    if (kDebugMode || Env.isDevelopment) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false,
          responseHeader: true,
          error: true,
        ),
      );
    }
  }
}
