import 'package:declarative_navigation/data/model/story.dart';

import 'package:json_annotation/json_annotation.dart';
part 'story_result.g.dart';

@JsonSerializable()
class StoryResult {
  bool error;
  String message;
  List<Story> listStory;

  StoryResult({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryResult.fromJson(Map<String, dynamic> json) =>
      _$StoryResultFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResultToJson(this);
}
