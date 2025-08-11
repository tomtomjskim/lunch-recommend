import 'package:flutter/material.dart';
import '../services/apis/groups_api.dart';
import 'group_detail_screen.dart';
import 'group_create_join_screen.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  final GroupsApi api = GroupsApi();
  late Future<List<dynamic>> _groups;

  @override
  void initState() {
    super.initState();
    _groups = api.fetchGroups();
  }

  void _refresh() {
    setState(() {
      _groups = api.fetchGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      body: FutureBuilder<List<dynamic>>(
        future: _groups,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final groups = snapshot.data ?? [];
          if (groups.isEmpty) {
            return const Center(child: Text('No groups yet'));
          }
          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final g = groups[index] as Map<String, dynamic>;
                return ListTile(
                  title: Text(g['name'] ?? 'Group'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupDetailScreen(groupId: g['id'].toString()),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GroupCreateJoinScreen(),
            ),
          );
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
