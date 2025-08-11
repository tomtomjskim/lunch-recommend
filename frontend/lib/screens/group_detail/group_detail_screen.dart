import 'dart:async';

import 'package:flutter/material.dart';
import '../../services/apis/poll_api.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  final String? token;

  const GroupDetailScreen({super.key, required this.groupId, this.token});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  Map<String, dynamic>? _poll;

  void _loadPoll(Map<String, dynamic> poll) {
    setState(() {
      _poll = poll;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PollCreationForm(
              groupId: widget.groupId,
              token: widget.token,
              onCreated: _loadPoll,
            ),
            const SizedBox(height: 24),
            if (_poll != null)
              PollVotingWidget(
                pollId: _poll!['id'],
                token: widget.token,
              ),
          ],
        ),
      ),
    );
  }
}

class PollCreationForm extends StatefulWidget {
  final String groupId;
  final String? token;
  final Function(Map<String, dynamic>) onCreated;

  const PollCreationForm({
    super.key,
    required this.groupId,
    required this.token,
    required this.onCreated,
  });

  @override
  State<PollCreationForm> createState() => _PollCreationFormState();
}

class _PollCreationFormState extends State<PollCreationForm> {
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  void _addOptionField() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  Future<void> _submit() async {
    final options =
        _optionControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList();
    final poll = await PollApi(widget.token)
        .createPoll(_questionController.text, options, widget.groupId);
    widget.onCreated(poll);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Start a Poll'),
        TextField(
          controller: _questionController,
          decoration: const InputDecoration(labelText: 'Question'),
        ),
        ..._optionControllers
            .map((c) => TextField(
                  controller: c,
                  decoration: const InputDecoration(labelText: 'Option'),
                ))
            .toList(),
        TextButton(onPressed: _addOptionField, child: const Text('Add Option')),
        ElevatedButton(onPressed: _submit, child: const Text('Create Poll')),
      ],
    );
  }
}

class PollVotingWidget extends StatefulWidget {
  final int pollId;
  final String? token;

  const PollVotingWidget({super.key, required this.pollId, required this.token});

  @override
  State<PollVotingWidget> createState() => _PollVotingWidgetState();
}

class _PollVotingWidgetState extends State<PollVotingWidget> {
  Map<String, dynamic>? _poll;
  int? _selectedOptionId;
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
    final poll = await PollApi(widget.token).getPoll(widget.pollId);
    setState(() {
      _poll = poll;
    });
  }

  Future<void> _vote(int optionId) async {
    final poll =
        await PollApi(widget.token).vote(widget.pollId, optionId);
    setState(() {
      _poll = poll;
      _selectedOptionId = optionId;
    });
  }

  Future<void> _retract() async {
    await PollApi(widget.token).retractVote(widget.pollId);
    setState(() {
      _selectedOptionId = null;
    });
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    if (_poll == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final options = _poll!['options'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_poll!['question'] ?? ''),
        ...options.map((o) {
          final votes = (o['votes'] as List).length;
          final isSelected = _selectedOptionId == o['id'];
          return ListTile(
            title: Text('${o['text']} ($votes)'),
            trailing: isSelected ? const Icon(Icons.check) : null,
            onTap: () => _vote(o['id']),
          );
        }),
        TextButton(onPressed: _retract, child: const Text('Retract Vote')),
      ],
    );
  }
}
