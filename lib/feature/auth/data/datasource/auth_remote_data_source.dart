import 'package:smart_translater_admin/core/storage/secure_storage_service.dart';
import 'package:smart_translater_admin/feature/auth/data/datasource/auth_api_service.dart';
import 'package:smart_translater_admin/feature/auth/data/models/login_request.dart';
import 'package:smart_translater_admin/feature/auth/data/models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest loginRequest);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;
  final SecureStorageService _storageService;

  AuthRemoteDataSourceImpl({
    required this._apiService,
    required this._storageService,
  });

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await _apiService.login(loginRequest);

    if (response.data == null) {
      throw Exception(
        response.message.isNotEmpty ? response.message : "Login failed",
      );
    }

    final loginResponse = response.data!;

    await _storageService.saveToken(
      accessToken: loginResponse.token,
      refreshToken: loginResponse.refreshToken,
    );

    return loginResponse;
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _apiService.logout({"refreshToken": refreshToken});
      } catch (_) {}
    }

    await _storageService.clearToken();
  }
}
