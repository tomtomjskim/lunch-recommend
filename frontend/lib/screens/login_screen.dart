import 'package:flutter/material.dart';
import '../services/apis/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoggedIn;
  const LoginScreen({super.key, this.onLoggedIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _nicknameCtrl = TextEditingController();
  final _providerCtrl = TextEditingController(text: 'google');
  final AuthService _authService = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nicknameCtrl.dispose();
    _providerCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await _authService.login(
          _emailCtrl.text, _nicknameCtrl.text, _providerCtrl.text);
      widget.onLoggedIn?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: AbsorbPointer(
        absorbing: _loading,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nicknameCtrl,
                decoration: const InputDecoration(labelText: 'Nickname'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _providerCtrl,
                decoration: const InputDecoration(labelText: 'Provider'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                child: _loading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
