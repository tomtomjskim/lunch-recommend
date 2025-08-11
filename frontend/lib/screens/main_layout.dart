import 'package:flutter/material.dart';
import 'group_list_screen.dart';

class MainLayout extends StatefulWidget {
  final VoidCallback? onLogout;
  const MainLayout({super.key, this.onLogout});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lunch Recommend')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Groups'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GroupListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                widget.onLogout?.call();
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome'),
      ),
    );
  }
}
