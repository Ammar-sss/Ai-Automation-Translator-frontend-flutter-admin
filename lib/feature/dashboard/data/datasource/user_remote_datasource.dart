import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smart_translater_admin/core/network/api_endpoints.dart';
import 'package:smart_translater_admin/core/utils/api_response.dart';
import 'package:smart_translater_admin/feature/auth/data/models/user.dart';

part 'user_remote_datasource.g.dart';

@RestApi()
abstract class UserRemoteDatasource {
  factory UserRemoteDatasource(Dio dio, {String baseUrl}) =
      _UserRemoteDatasource;

  @GET(ApiEndpoints.getAllUsers)
  Future<ApiResponse<List<User>>> getAllUsers();

  @GET(ApiEndpoints.getUserById)
  Future<ApiResponse<User>> getUserById(@Path("id") int id);

  @GET(ApiEndpoints.getUserByEmail)
  Future<ApiResponse<User>> getUserByEmail(@Query("email") String email);

  @DELETE(ApiEndpoints.deleteUserByID)
  Future<ApiResponse<dynamic>> deleteUserByID(@Path("id") int id);

  @DELETE(ApiEndpoints.deleteUserByEmail)
  Future<ApiResponse<dynamic>> deleteUserByEmail(@Query("email") String email);

  @PATCH(ApiEndpoints.deActivateUserByID)
  Future<ApiResponse<dynamic>> deActivateUserByID(@Path("id") int id);

  @PATCH(ApiEndpoints.activateUserByID)
  Future<ApiResponse<dynamic>> activateUserByID(@Path("id") int id);

  @PATCH(ApiEndpoints.deActivateUserByEmail)
  Future<ApiResponse<dynamic>> deActivateUserByEmail(
    @Query("email") String email,
  );
}
