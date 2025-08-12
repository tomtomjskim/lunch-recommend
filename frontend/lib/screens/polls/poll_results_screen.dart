import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/apis/poll_api.dart';

class PollResultsScreen extends StatefulWidget {
  final int pollId;
  const PollResultsScreen({super.key, required this.pollId});

  @override
  State<PollResultsScreen> createState() => _PollResultsScreenState();
}

class _PollResultsScreenState extends State<PollResultsScreen> {
  final PollApi api = PollApi(null);
  Map<String, dynamic>? _poll;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetch();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetch());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetch() async {
    final poll = await api.getResults(widget.pollId);
    setState(() {
      _poll = poll;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Results')),
      body: _poll == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _poll!['question'] ?? '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ...((_poll!['options'] as List<dynamic>? ?? [])).map((o) {
                    final text = o['text'] as String? ?? '';
                    final votes = (o['votes'] as List<dynamic>? ?? []).length;
                    return ListTile(
                      title: Text('$text ($votes)'),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
