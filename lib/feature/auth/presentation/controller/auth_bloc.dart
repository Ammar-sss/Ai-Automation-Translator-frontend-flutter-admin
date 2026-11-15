import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_translater_admin/core/storage/secure_storage_service.dart';
import 'package:smart_translater_admin/feature/auth/data/models/login_request.dart';
import 'package:smart_translater_admin/feature/auth/data/models/user.dart';
import 'package:smart_translater_admin/feature/auth/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SecureStorageService storageService;

  AuthBloc({required this.storageService, required this.authRepository})
    : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter emit,
  ) async {
    final hasToken = await storageService.hasAccessToken();
    final isAdmin = await storageService.getIsAdmin();

    if (hasToken && isAdmin) {
      emit(AuthAuthenticated(user: null));
    } else {
      await storageService.clearToken();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter emit,
  ) async {
    emit(AuthLoginLoading());
    try {
      final response = await authRepository.login(
        LoginRequest(email: event.email, password: event.password),
      );

      final isAdmin = response.roles.any(
        (role) =>
            role.toUpperCase() == "ADMIN" || role.toUpperCase() == "ROLE_ADMIN",
      );

      if (!isAdmin) {
        await storageService.clearToken();
        emit(AuthFailure("Access denied: Admin privileges required."));
        emit(AuthUnauthenticated());
        return;
      }
      await storageService.saveTsAdmin(true);
      emit(AuthAuthenticated(user: response.user));
    } catch (e) {
      final error = e.toString().replaceAll('Exception: ', '');
      emit(AuthFailure(error));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter emit,
  ) async {
    emit(AuthLogoutLoading());
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
