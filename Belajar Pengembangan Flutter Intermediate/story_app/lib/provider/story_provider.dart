import 'dart:io';

import 'package:camera/camera.dart';
import 'package:declarative_navigation/data/api/api_service.dart';
import 'package:declarative_navigation/data/db/auth_repository.dart';
import 'package:declarative_navigation/data/model/story.dart';
import 'package:declarative_navigation/utils/result_state.dart';
import 'package:flutter/material.dart';

class StoryProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  StoryProvider({required this.authRepository, required this.apiService});

  ResultState? _state;
  String? _message;
  List<Story> storiesResult = [];
  Story? _story;
  String? imagePath;
  XFile? imageFile;
  int? pageItems = 1;
  int sizeItems = 10;

  ResultState? get state => _state;
  String? get message => _message;
  Story? get story => _story;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<dynamic> getAllStories({required bool isRefresh}) async {
    try {
      if (isRefresh) {
        pageItems = 1;
        storiesResult = [];
      }

      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }

      final token = await authRepository.getToken();
      final result = await apiService.getAllStories(
        token: token ?? '',
        pageItems: pageItems!,
        sizeItems: sizeItems,
      );

      if (result.listStory.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }

      if (result.listStory.isNotEmpty) {
        storiesResult.addAll(result.listStory);
        _state = ResultState.hasData;
        notifyListeners();
      } else {
        _state = ResultState.noData;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Tidak ada koneksi internet';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> getDetailStory({required String id}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final token = await authRepository.getToken();
      final result =
          await apiService.getDetailStory(id: id, token: token ?? '');

      if (result.story.id.isNotEmpty) {
        _story = result.story;
        _state = ResultState.hasData;
        notifyListeners();
      } else {
        _state = ResultState.noData;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Tidak ada koneksi internet';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
