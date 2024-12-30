import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageManager extends ChangeNotifier {
  late Completer<String> _completer;
  late Completer<LatLng> _latLngCompleter;

  Future<String> waitForResult() async {
    _completer = Completer<String>();
    return _completer.future;
  }

  Future<LatLng> waitForLatLngResult() async {
    _latLngCompleter = Completer<LatLng>();
    return _latLngCompleter.future;
  }

  void returnData(String value) {
    _completer.complete(value);
  }

  void returnLatLng(LatLng storyLatLng) {
    _latLngCompleter.complete(storyLatLng);
  }
}
