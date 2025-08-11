import 'package:flutter/material.dart';
import '../services/apis/poll_api.dart';

class PollCreateScreen extends StatefulWidget {
  final String groupId;
  const PollCreateScreen({super.key, required this.groupId});

  @override
  State<PollCreateScreen> createState() => _PollCreateScreenState();
}

class _PollCreateScreenState extends State<PollCreateScreen> {
  final PollApi api = PollApi(null);
  final TextEditingController _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionCtrls = [
    TextEditingController(),
    TextEditingController(),
  ];
  bool _loading = false;

  @override
  void dispose() {
    _questionCtrl.dispose();
    for (final c in _optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionCtrls.add(TextEditingController());
    });
  }

  Future<void> _create() async {
    setState(() => _loading = true);
    try {
      final options =
          _optionCtrls.map((c) => c.text).where((s) => s.isNotEmpty).toList();
      await api.createPoll(_questionCtrl.text, options, widget.groupId);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create poll: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Poll')),
      body: AbsorbPointer(
        absorbing: _loading,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              TextField(
                controller: _questionCtrl,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              const SizedBox(height: 16),
              ..._optionCtrls.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: controller,
                    decoration:
                        InputDecoration(labelText: 'Option ${index + 1}'),
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _addOption,
                icon: const Icon(Icons.add),
                label: const Text('Add Option'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _create,
                child: const Text('Create Poll'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
