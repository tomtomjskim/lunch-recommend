import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupsApi {
  final String baseUrl;
  GroupsApi({this.baseUrl = '/api'});

  Future<List<dynamic>> fetchGroups() async {
    final resp = await http.get(Uri.parse('$baseUrl/groups'));
    if (resp.statusCode != 200) {
      throw Exception('Failed to load groups');
    }
    return jsonDecode(resp.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> fetchGroupDetail(String groupId) async {
    final resp = await http.get(Uri.parse('$baseUrl/groups/$groupId'));
    if (resp.statusCode != 200) {
      throw Exception('Group not found');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createGroup(String name) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/groups'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (resp.statusCode != 201) {
      throw Exception('Failed to create group');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> joinGroup(String inviteCode) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/groups/join'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'inviteCode': inviteCode}),
    );
    if (resp.statusCode == 404) {
      throw InvalidInviteCodeException();
    }
    if (resp.statusCode != 200) {
      throw Exception('Failed to join group');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }
}

class InvalidInviteCodeException implements Exception {}
