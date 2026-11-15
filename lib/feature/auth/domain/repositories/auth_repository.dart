import 'package:smart_translater_admin/feature/auth/data/models/login_request.dart';
import 'package:smart_translater_admin/feature/auth/data/models/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest loginRequest);
  Future<void> logout();
}
