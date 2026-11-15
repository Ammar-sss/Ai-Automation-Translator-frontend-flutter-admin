import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_translater_admin/core/storage/secure_storage_service.dart';

part 'sitting_state.dart';

class SittingCubit extends Cubit<SittingState> {
  final SecureStorageService _storageService;

  SittingCubit({required this._storageService}) : super(const SittingState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final savedTheme = await _storageService.getThemeMode();
    final savedFont = await _storageService.getFontFamily();

    ThemeMode themeMode = ThemeMode.light;
    if (savedTheme == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (savedTheme == 'system') {
      themeMode = ThemeMode.system;
    }

    emit(
      state.copyWith(themeMode: themeMode, fontFamily: savedFont ?? 'Default'),
    );
  }

  Future<void> toggleTheme(bool isDark) async {
    final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: themeMode));
    await _storageService.saveThemeMode(isDark ? 'dark' : 'light');
  }

  Future<void> setFontFamily(String font) async {
    emit(state.copyWith(fontFamily: font));
    await _storageService.saveFontFamily(font);
  }
}
