import 'package:json_annotation/json_annotation.dart';
import 'package:smart_translater_admin/feature/auth/data/models/user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String token;
  final String refreshToken;
  final String? tokenType;
  final int expiresIn;
  final int refreshExpiresIn;
  final User? user;
  final List<String> roles;

  const LoginResponse({
    required this.token,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    required this.expiresIn,
    required this.refreshExpiresIn,
    this.user,
    this.roles = const [],
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
