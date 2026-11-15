part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final User? user;

  AuthAuthenticated({required this.user});
}

class AuthUnauthenticated extends AuthState {}

final class AuthLoginLoading extends AuthState {}

final class AuthLogoutLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
