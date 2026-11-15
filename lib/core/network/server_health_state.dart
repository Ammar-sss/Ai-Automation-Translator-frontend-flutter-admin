part of 'server_health_cubit.dart';

@immutable
sealed class ServerHealthState {}

final class ServerHealthSleeping extends ServerHealthState {}

final class ServerHealthWaking extends ServerHealthState {}

final class ServerHealthAwake extends ServerHealthState {}
