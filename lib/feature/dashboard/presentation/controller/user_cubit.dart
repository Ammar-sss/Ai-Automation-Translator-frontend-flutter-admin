import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/data/models/user.dart';
import '../../domain/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserInitial());

  Future<void> loadAllUsers() async {
    if (state is UserLoading) return;

    emit(UserLoading());
    try {
      final users = await userRepository.getAllUsers();
      emit(UserLoaded(user: users));
    } catch (e) {
      final error = e.toString().replaceAll("Exception", "");
      emit(UserFailer(message: error));
    }
  }

  Future<void> activateUserById(int id) async {
    emit(UserLoading());
    try {
      await userRepository.activateUserByID(id);
      emit(UserOperationSuccess(message: "User activated successfully"));
      await loadAllUsers();
    } catch (e) {
      final error = e.toString().replaceAll("Exception", "");
      emit(UserFailer(message: error));
    }
  }

  Future<void> deActivateUserByID(int id) async {
    emit(UserLoading());
    try {
      await userRepository.deActivateUserByID(id);
      emit(
        UserOperationSuccess(message: "User deActivated successfully by Id"),
      );
      await loadAllUsers();
    } catch (e) {
      final error = e.toString().replaceAll("Exception", "");
      emit(UserFailer(message: error));
    }
  }

  Future<void> deActivateUserByEmail(String email) async {
    emit(UserLoading());
    try {
      await userRepository.deActivateUserByEmail(email);
      emit(
        UserOperationSuccess(message: "User deActivated successfully by Email"),
      );
      await loadAllUsers();
    } catch (e) {
      final error = e.toString().replaceAll("Exception", "");
      emit(UserFailer(message: error));
    }
  }

  Future<void> deleteUserById(int id) async {
    emit(UserLoading());
    try {
      await userRepository.deleteUserByID(id);
      emit(UserOperationSuccess(message: "User deleted successfully by Id"));
      await loadAllUsers();
    } catch (e) {
      final error = e.toString().replaceAll("Exception", "");
      emit(UserFailer(message: error));
    }
  }

  Future<void> deleteUserByEmail(String email) async {
    emit(UserLoading());
    try {
      await userRepository.deleteUserByEmail(email);
      emit(UserOperationSuccess(message: "User deleted successfully by Email"));
      await loadAllUsers();
    } catch (e) {
      final error = e.toString().replaceAll("Exception", "");
      emit(UserFailer(message: error));
    }
  }

  Future<void> searchUserByEmail(String email) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getUserByEmail(email);
      emit(SingleUserLoaded(user: user));
    } catch (e) {
      final error = e.toString().replaceAll('Exception: ', '');
      emit(UserFailer(message: error));
    }
  }

  Future<void> searchUserById(int id) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getUserById(id);
      emit(SingleUserLoaded(user: user));
    } catch (e) {
      final error = e.toString().replaceAll('Exception: ', '');
      emit(UserFailer(message: error));
    }
  }
}
