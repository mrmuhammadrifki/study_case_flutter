import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String tokenKey = "token";

  Future<bool> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(tokenKey, token);
  }

  Future<bool> deleteToken() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(tokenKey, "");
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final token = preferences.getString(tokenKey) ?? "";
    return token;
  }
}
