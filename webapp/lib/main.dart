import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:webapp/login.dart';
import 'package:webapp/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:webapp/welcome_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showLoginField = true;
  final bool _isLoggedIn = false;
  late User user;

  void _toggleField() {
    setState(() {
      _showLoginField = !_showLoginField;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? WelcomePage(user: user) // Pass context as a parameter
        : Scaffold(
            appBar: AppBar(
              title: const Text('Login/Register'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () {
                          if (!_showLoginField) {
                            _toggleField();
                          }
                        },
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        child: const Text('Register'),
                        onPressed: () {
                          if (_showLoginField) {
                            _toggleField();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  IndexedStack(
                    index: _showLoginField ? 0 : 1,
                    children: [
                      LoginField(),
                      RegisterField(),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
