// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_detail_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDetailResult _$StoryDetailResultFromJson(Map<String, dynamic> json) =>
    StoryDetailResult(
      error: json['error'] as bool,
      message: json['message'] as String,
      story: Story.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryDetailResultToJson(StoryDetailResult instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'story': instance.story,
    };
