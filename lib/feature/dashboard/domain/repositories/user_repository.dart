import '../../../auth/data/models/user.dart';

abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<User> getUserById(int id);
  Future<User> getUserByEmail(String email);
  Future<void> deleteUserByID(int id);
  Future<void> deleteUserByEmail(String email);
  Future<void> deActivateUserByID(int id);
  Future<void> activateUserByID(int id);
  Future<void> deActivateUserByEmail(String email);
}
