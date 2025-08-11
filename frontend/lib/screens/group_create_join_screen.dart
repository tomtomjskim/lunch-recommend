import 'package:flutter/material.dart';
import '../services/apis/groups_api.dart';

class GroupCreateJoinScreen extends StatefulWidget {
  const GroupCreateJoinScreen({super.key});

  @override
  State<GroupCreateJoinScreen> createState() => _GroupCreateJoinScreenState();
}

class _GroupCreateJoinScreenState extends State<GroupCreateJoinScreen> {
  final GroupsApi api = GroupsApi();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _codeCtrl = TextEditingController();
  bool _loading = false;
  String? _joinError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    setState(() => _loading = true);
    try {
      await api.createGroup(_nameCtrl.text);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not create group: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _join() async {
    setState(() {
      _loading = true;
      _joinError = null;
    });
    try {
      await api.joinGroup(_codeCtrl.text);
      if (!mounted) return;
      Navigator.pop(context, true);
    } on InvalidInviteCodeException {
      setState(() => _joinError = 'Invalid invite code');
    } catch (_) {
      setState(() => _joinError = 'Failed to join group');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create or Join Group')),
      body: AbsorbPointer(
        absorbing: _loading,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Group name'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _create,
                child: const Text('Create'),
              ),
              const Divider(height: 32),
              TextField(
                controller: _codeCtrl,
                decoration: InputDecoration(
                  labelText: 'Invite code',
                  errorText: _joinError,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _join,
                child: const Text('Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
