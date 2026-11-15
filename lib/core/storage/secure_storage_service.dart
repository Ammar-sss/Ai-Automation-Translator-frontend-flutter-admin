import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(resetOnError: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  static const String _keyAccessToken = "access_token";
  static const String _keyRefreshToken = "refresh_token";
  static const String _keyAdmin = "is_admin";
  static const String _keyThemeMode = "theme_mode";
  static const String _keyFontFamily = "font_family";

  Future<void> saveThemeMode(String themeMode) async {
    await _storage.write(key: _keyThemeMode, value: themeMode);
  }

  Future<String?> getThemeMode() async {
    return await _storage.read(key: _keyThemeMode);
  }

  Future<void> saveFontFamily(String font) async {
    await _storage.write(key: _keyFontFamily, value: font);
  }

  Future<String?> getFontFamily() async {
    return await _storage.read(key: _keyFontFamily);
  }

  Future<void> saveTsAdmin(bool isAdmin) async {
    await _storage.write(key: _keyAdmin, value: isAdmin.toString());
  }

  Future<bool> getIsAdmin() async {
    final value = await _storage.read(key: _keyAdmin);
    return value == "true";
  }

  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearToken() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyAdmin),
    ]);
  }
}
