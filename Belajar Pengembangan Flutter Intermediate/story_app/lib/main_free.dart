import 'package:declarative_navigation/flavor_config.dart';
import 'package:declarative_navigation/story_app.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    flavor: FlavorType.free,
    values: const FlavorValues(
      isPaid: false,
    ),
  );

  runApp(const StoryApp());
}
