import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = '/api'});

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getGroups() async {
    final res = await http.get(Uri.parse('$baseUrl/groups'), headers: await _headers());
    if (res.statusCode != 200) {
      throw Exception('Failed to load groups');
    }
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getGroup(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/groups/$id'), headers: await _headers());
    if (res.statusCode != 200) {
      throw Exception('Failed to load group');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createGroup(String name) async {
    final res = await http.post(Uri.parse('$baseUrl/groups'), headers: await _headers(), body: jsonEncode({'name': name}));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to create group');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> joinGroup(String code) async {
    final res = await http.post(Uri.parse('$baseUrl/groups/join'), headers: await _headers(), body: jsonEncode({'code': code}));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to join group');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> removeMember(String groupId, String userId) async {
    final res = await http.delete(Uri.parse('$baseUrl/groups/$groupId/members/$userId'), headers: await _headers());
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to remove member');
    }
  }
}
