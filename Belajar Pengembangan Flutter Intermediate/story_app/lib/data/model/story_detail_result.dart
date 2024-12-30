import 'package:declarative_navigation/data/model/story.dart';

import 'package:json_annotation/json_annotation.dart';
part 'story_detail_result.g.dart';

@JsonSerializable()
class StoryDetailResult {
  bool error;
  String message;
  Story story;

  StoryDetailResult({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetailResult.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailResultFromJson(json);

  Map<String, dynamic> toJson() => _$StoryDetailResultToJson(this);
}
