import 'package:smart_translater_admin/core/config/secrets.dart';

class Env {
  const Env._();

  static const String baseUrl = Secrets.baseUrl;

  static const Duration connectTimeout = Duration(seconds: 100);
  static const Duration receiveTimeout = Duration(seconds: 100);

  static const String environment = String.fromEnvironment(
    "ENV",
    defaultValue: "development",
  );

  static bool get isProduction => environment == "production";
  static bool get isDevelopment => environment == "development";
}
