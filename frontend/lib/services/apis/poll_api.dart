import 'dart:convert';
import 'package:http/http.dart' as http;

class PollApi {
  final String? token;
  final String baseUrl;

  PollApi(this.token, {this.baseUrl = 'http://localhost:3000'});

  Map<String, String> _headers() => {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  Future<Map<String, dynamic>> createPoll(
      String question, List<String> options, String groupId) async {
    final res = await http.post(Uri.parse('$baseUrl/polls'),
        headers: _headers(),
        body: jsonEncode(
            {'question': question, 'options': options, 'groupId': groupId}));
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPoll(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/polls/$id'),
        headers: _headers());
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> vote(int pollId, int optionId) async {
    final res = await http.post(Uri.parse('$baseUrl/polls/$pollId/vote'),
        headers: _headers(),
        body: jsonEncode({'optionId': optionId}));
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> retractVote(int pollId) async {
    await http.delete(Uri.parse('$baseUrl/polls/$pollId/vote'),
        headers: _headers());
  }
}
