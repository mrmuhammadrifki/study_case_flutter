import 'package:json_annotation/json_annotation.dart';
part 'upload_result.g.dart';

@JsonSerializable()
class UploadResult {
  final bool error;
  final String message;

  UploadResult({
    required this.error,
    required this.message,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) =>
      _$UploadResultFromJson(json);

  Map<String, dynamic> toJson() => _$UploadResultToJson(this);
}
