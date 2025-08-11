import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl;
  static const _tokenKey = 'access_token';

  AuthService({this.baseUrl = '/api'});

  Future<String> login(
      String email, String nickname, String socialProvider) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'nickname': nickname,
        'socialProvider': socialProvider,
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to login');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final token = data['accessToken'] as String;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    return token;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
