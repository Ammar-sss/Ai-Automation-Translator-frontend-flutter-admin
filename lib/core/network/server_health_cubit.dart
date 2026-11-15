import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_translater_admin/core/network/server_health_service.dart';

part 'server_health_state.dart';

class ServerHealthCubit extends Cubit<ServerHealthState>
    with WidgetsBindingObserver {
  final ServerHealthService _service;
  Timer? _timer;

  ServerHealthCubit({required this._service}) : super(ServerHealthSleeping()) {
    WidgetsBinding.instance.addObserver(this);
    _startHealthTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startHealthTimer();
    } else if (state == AppLifecycleState.paused) {
      _stopHealthTimer();
    }
  }

  void _startHealthTimer() {
    wakeServer();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      wakeServer();
    });
  }

  void _stopHealthTimer() {
    _timer?.cancel();
  }

  Future<void> wakeServer() async {
    if (state is ServerHealthWaking) return;

    emit(ServerHealthWaking());

    final isActive = await _service.isServerAwake();

    if (isActive) {
      emit(ServerHealthAwake());
    } else {
      emit(ServerHealthSleeping());
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _stopHealthTimer();
    return super.close();
  }
}
