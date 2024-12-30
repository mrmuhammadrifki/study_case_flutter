import 'package:json_annotation/json_annotation.dart';
part 'register_result.g.dart';

@JsonSerializable()
class RegisterResult {
  bool error;
  String message;

  RegisterResult({
    required this.error,
    required this.message,
  });

  factory RegisterResult.fromJson(Map<String, dynamic> json) =>
      _$RegisterResultFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResultToJson(this);
}
