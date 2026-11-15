import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smart_translater_admin/core/network/api_endpoints.dart';
import 'package:smart_translater_admin/core/utils/api_response.dart';
import 'package:smart_translater_admin/feature/auth/data/models/login_request.dart';
import 'package:smart_translater_admin/feature/auth/data/models/login_response.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST(ApiEndpoints.login)
  Future<ApiResponse<LoginResponse>> login(@Body() LoginRequest loginRequest);

  @POST(ApiEndpoints.logout)
  Future<ApiResponse<dynamic>> logout(@Body() Map<String, dynamic> body);
}
