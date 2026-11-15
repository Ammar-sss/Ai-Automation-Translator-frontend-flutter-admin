import 'package:dio/dio.dart';
import 'package:smart_translater_admin/feature/auth/data/models/user.dart';
import 'package:smart_translater_admin/feature/dashboard/data/datasource/user_remote_datasource.dart';
import 'package:smart_translater_admin/feature/dashboard/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource userRemoteDatasource;

  const UserRepositoryImpl({required this.userRemoteDatasource});

  @override
  Future<void> activateUserByID(int id) async {
    try {
      await userRemoteDatasource.activateUserByID(id);
    } on DioException catch (e) {
      throw _handelDioErrorException(e);
    }
  }

  @override
  Future<void> deActivateUserByEmail(String email) async {
    try {
      await userRemoteDatasource.deActivateUserByEmail(email);
    } on DioException catch (e) {
      throw _handelDioErrorException(e);
    }
  }

  @override
  Future<void> deActivateUserByID(int id) async {
    try {
      await userRemoteDatasource.deActivateUserByID(id);
    } on DioException catch (e) {
      throw _handelDioErrorException(e);
    }
  }

  @override
  Future<void> deleteUserByEmail(String email) async {
    try {
      await userRemoteDatasource.deleteUserByEmail(email);
    } on DioException catch (e) {
      throw _handelDioErrorException(e);
    }
  }

  @override
  Future<void> deleteUserByID(int id) async {
    try {
      await userRemoteDatasource.deleteUserByID(id);
    } on DioException catch (e) {
      throw _handelDioErrorException(e);
    }
  }

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final response = await userRemoteDatasource.getAllUsers();
      return response.data ?? [];
    } on DioException catch (e) {
      throw _handelDioErrorException(e);
    }
  }

  @override
  Future<User> getUserByEmail(String email) async {
    try {
      final response = await userRemoteDatasource.getUserByEmail(email);
      if (response.data == null) throw Exception(response.message);
      return response.data!;
    } on DioException catch (e) {
      throw _handelDioErrorException(e);
    }
  }

  @override
  Future<User> getUserById(int id) async {
    try {
      final response = await userRemoteDatasource.getUserById(id);
      if (response.data == null) throw Exception(response.message);
      return response.data!;
    } on DioException catch (e) {
      throw _handelDioErrorException(e);
    }
  }

  Exception _handelDioErrorException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception("Server is unreachable. Please check your connection.");
    }
    String? message;
    if (e.response?.data is Map<String, dynamic>) {
      message = e.response?.data["message"] as String?;
    }

    return Exception(
      message ?? 'An unexpected error occurred. Please try again.',
    );
  }
}
