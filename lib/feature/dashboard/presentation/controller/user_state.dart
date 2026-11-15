part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final List<User> user;

  UserLoaded({required this.user});
}

final class SingleUserLoaded extends UserState {
  final User? user;

  SingleUserLoaded({required this.user});
}

final class UserOperationSuccess extends UserState {
  final String message;

  UserOperationSuccess({required this.message});
}

final class UserFailer extends UserState {
  final String message;

  UserFailer({required this.message});
}
