import 'package:flutter/material.dart';
import '../../services/api.dart';
import '../../widgets/banner_placeholder.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final ApiService api = ApiService();
  late Future<Map<String, dynamic>> _group;

  @override
  void initState() {
    super.initState();
    _group = api.getGroup(widget.groupId);
  }

  Future<void> _removeMember(String userId) async {
    await api.removeMember(widget.groupId, userId);
    setState(() {
      _group = api.getGroup(widget.groupId);
    });
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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                g['name'] ?? 'Group',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text('Members', style: Theme.of(context).textTheme.titleMedium),
              ...members.map((m) {
                final user = m['user'] as Map<String, dynamic>? ?? {};
                final role = m['role'] ?? '';
                return ListTile(
                  title: Text(user['nickname'] ?? 'Member'),
                  subtitle: Text(role),
                  trailing: role == 'owner'
                      ? const Text('Owner')
                      : IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () =>
                              _removeMember(user['id'].toString()),
                        ),
                );
              }),
            ],
          );
        },
      ),
      bottomNavigationBar: const BannerPlaceholder(),
    );
  }
}
