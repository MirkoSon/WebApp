import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/providers/auth_provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) => authProvider.user != null
            ? WelcomeScreen()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        child: const Text('Register'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
