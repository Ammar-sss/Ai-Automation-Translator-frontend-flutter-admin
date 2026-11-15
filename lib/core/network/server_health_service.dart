import 'package:dio/dio.dart';
import 'package:smart_translater_admin/core/config/env.dart';
import 'package:smart_translater_admin/core/network/api_endpoints.dart';

class ServerHealthService {
  final Dio _dio;

  ServerHealthService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: Env.apiBaseUrl,
              connectTimeout: const Duration(seconds: 60),
              receiveTimeout: const Duration(seconds: 60),
            ),
          );

  Future<bool> isServerAwake() async {
    try {
      final response = await _dio.get(ApiEndpoints.health);
      // Any valid HTTP response means the server is active & awake
      return response.statusCode != null;
    } on DioException catch (e) {
      // If the server responded with any HTTP status code (200, 401, 404, etc.), it IS awake!
      if (e.response != null) {
        return true;
      }
      // Connection timeout or connection error means the server is sleeping
      return false;
    } catch (_) {
      return false;
    }
  }
}
