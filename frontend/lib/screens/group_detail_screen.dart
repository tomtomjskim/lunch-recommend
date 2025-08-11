import 'package:flutter/material.dart';
import '../services/apis/groups_api.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final GroupsApi api = GroupsApi();
  late Future<Map<String, dynamic>> _group;

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
    );
  }
}
