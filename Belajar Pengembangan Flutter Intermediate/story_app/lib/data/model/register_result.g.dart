// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResult _$RegisterResultFromJson(Map<String, dynamic> json) =>
    RegisterResult(
      error: json['error'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$RegisterResultToJson(RegisterResult instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
    };
