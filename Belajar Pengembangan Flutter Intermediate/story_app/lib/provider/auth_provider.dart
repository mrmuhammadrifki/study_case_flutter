import 'dart:io';

import 'package:declarative_navigation/data/api/api_service.dart';
import 'package:declarative_navigation/data/db/auth_repository.dart';
import 'package:declarative_navigation/utils/result_state.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  AuthProvider({required this.authRepository, required this.apiService});

  ResultState? _state;
  String? _message;

  ResultState? get state => _state;
  String? get message => _message;

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.login(email: email, password: password);
      final token = result.loginResult.token;
      if (token.isNotEmpty) {
        _message = result.message;
        await authRepository.saveToken(token);
      }
      _state = ResultState.hasData;
      notifyListeners();
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

  Future<dynamic> logout() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      await authRepository.deleteToken();

      _state = ResultState.hasData;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.register(
        name: name,
        email: email,
        password: password,
      );
      _message = result.message;
      _state = ResultState.hasData;
      notifyListeners();
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
