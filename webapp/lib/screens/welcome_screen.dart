import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/providers/auth_provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to My App!'),
            const SizedBox(height: 16),
            Text('Email: ${context.watch<AuthProvider>().user?.email}'),
          ],
        ),
      ),
    );
  }
}
