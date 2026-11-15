import 'package:dio/dio.dart';
import 'package:smart_translater_admin/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:smart_translater_admin/feature/auth/data/models/login_request.dart';
import 'package:smart_translater_admin/feature/auth/data/models/login_response.dart';
import 'package:smart_translater_admin/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      return await authRemoteDataSource.login(loginRequest);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Server is waking up or unreachable. Please try again in a moment.',
        );
      }

      String? serverMessage;
      if (e.response?.data is Map<String, dynamic>) {
        serverMessage = e.response?.data["message"] as String?;
      }
      throw Exception(
        serverMessage ?? "Login failed. Please check your credentials.",
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> logout() async {
    await authRemoteDataSource.logout();
  }
}
