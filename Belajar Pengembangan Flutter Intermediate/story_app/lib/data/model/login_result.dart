import 'package:declarative_navigation/data/model/login.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
  bool error;
  String message;
  Login loginResult;

  LoginResult({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
