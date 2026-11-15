import 'package:dio/dio.dart';
import 'package:smart_translater_admin/core/config/env.dart';
import 'package:smart_translater_admin/core/network/api_endpoints.dart';
import 'package:smart_translater_admin/core/storage/secure_storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService _storageService;
  final Dio _dio;

  AuthInterceptor({required this._storageService, required this._dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthEndpoint =
        options.path.contains(ApiEndpoints.login) ||
        options.path.contains(ApiEndpoints.refresh);

    if (!isAuthEndpoint) {
      final token = await _storageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    // Must be called for ALL requests, including auth endpoints!
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // If the failed call itself was the refresh call, clear token and exit
      if (err.requestOptions.path.contains(ApiEndpoints.refresh)) {
        await _storageService.clearToken();
        return handler.next(err);
      }

      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _storageService.clearToken();
        return handler.next(err);
      }

      try {
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: Env.apiBaseUrl,
            connectTimeout: Env.connectTimeout,
            receiveTimeout: Env.receiveTimeout,
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final response = await refreshDio.post(
          ApiEndpoints.refresh,
          data: {"refreshToken": refreshToken},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Unpack Response<LoginResponse> from Spring Boot
          final responseData = response.data["data"];
          final newAccessToken = responseData["token"] as String;
          final newRefreshToken =
              (responseData["refreshToken"] ?? refreshToken) as String;

          await _storageService.saveToken(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          // Retry the original request
          final originalOptions = err.requestOptions;
          originalOptions.headers["Authorization"] = "Bearer $newAccessToken";

          final retryResponse = await _dio.fetch(originalOptions);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        // Only clear tokens if the refresh token was rejected by server (401/403)
        // If it failed because of offline/timeout, do NOT clear tokens!
        if (e is DioException &&
            (e.response?.statusCode == 401 || e.response?.statusCode == 403)) {
          await _storageService.clearToken();
        }
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
