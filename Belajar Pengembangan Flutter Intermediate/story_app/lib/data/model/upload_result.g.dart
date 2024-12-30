// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadResult _$UploadResultFromJson(Map<String, dynamic> json) => UploadResult(
      error: json['error'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$UploadResultToJson(UploadResult instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
    };
