import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/banner_placeholder.dart';
import '../services/apis/groups_api.dart';
import '../services/apis/poll_api.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final GroupsApi api = GroupsApi();
  late Future<Map<String, dynamic>> _group;
  int? _pollId;

  void _onPollCreated(Map<String, dynamic> poll) {
    setState(() {
      _pollId = poll['id'] as int?;
    });
  }

  @override
  void initState() {
    super.initState();
    _group = api.fetchGroupDetail(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Detail')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _group,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final g = snapshot.data ?? {};
          final members = g['members'] as List<dynamic>? ?? [];
          final isOwner = g['isOwner'] == true;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                g['name'] ?? 'Group',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text('Members', style: Theme.of(context).textTheme.titleMedium),
              ...members.map((m) => ListTile(title: Text(m['name'] ?? 'Member'))),
              const SizedBox(height: 24),
              PollCreationForm(
                groupId: widget.groupId,
                onCreated: _onPollCreated,
              ),
              const SizedBox(height: 24),
              if (_pollId != null)
                PollStatusWidget(
                  pollId: _pollId!,
                ),
              const SizedBox(height: 24),
              if (isOwner)
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Manage Group'),
                )
              else
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Leave Group'),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BannerPlaceholder(),
    );
  }
}

class PollCreationForm extends StatefulWidget {
  final String groupId;
  final void Function(Map<String, dynamic>) onCreated;

  const PollCreationForm({
    super.key,
    required this.groupId,
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
    final poll = await PollApi(null)
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

class PollStatusWidget extends StatefulWidget {
  final int pollId;

  const PollStatusWidget({super.key, required this.pollId});

  @override
  State<PollStatusWidget> createState() => _PollStatusWidgetState();
}

class _PollStatusWidgetState extends State<PollStatusWidget> {
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
    final poll = await PollApi(null).getResults(widget.pollId);
    setState(() {
      _poll = poll;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_poll == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final options = _poll!['options'] as List<dynamic>? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_poll!['question'] ?? ''),
        ...options.map((o) {
          final votes = (o['votes'] as List<dynamic>? ?? []).length;
          return ListTile(
            title: Text('${o['text']} ($votes)'),
          );
        }),
      ],
    );
  }
}
