// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryResult _$StoryResultFromJson(Map<String, dynamic> json) => StoryResult(
      error: json['error'] as bool,
      message: json['message'] as String,
      listStory: (json['listStory'] as List<dynamic>)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryResultToJson(StoryResult instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
    };
