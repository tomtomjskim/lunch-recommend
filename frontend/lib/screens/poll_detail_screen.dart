import 'package:flutter/material.dart';
import '../services/apis/poll_api.dart';
import '../widgets/poll_option_list.dart';

class PollDetailScreen extends StatefulWidget {
  final int pollId;
  const PollDetailScreen({super.key, required this.pollId});

  @override
  State<PollDetailScreen> createState() => _PollDetailScreenState();
}

class _PollDetailScreenState extends State<PollDetailScreen> {
  final PollApi api = PollApi(null);
  late Future<Map<String, dynamic>> _poll;
  int? _selectedOption;

  @override
  void initState() {
    super.initState();
    _poll = api.getPoll(widget.pollId);
  }

  Future<void> _vote(int optionId) async {
    await api.vote(widget.pollId, optionId);
    final data = await api.getPoll(widget.pollId);
    setState(() {
      _poll = Future.value(data);
      _selectedOption = optionId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poll Detail')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _poll,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final poll = snapshot.data ?? {};
          final options =
              (poll['options'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poll['question'] ?? '',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                PollOptionList(
                  options: options,
                  onVote: _vote,
                  selectedOption: _selectedOption,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
