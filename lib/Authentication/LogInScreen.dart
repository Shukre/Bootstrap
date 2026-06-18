import 'package:flutter/material.dart';
import 'package:codingminds_bootstrap/Dashboard/HomePage.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LogInScreen> {
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailAddressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
    );
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Spacer(),
              Row(
                mainAxisSize:
                    MainAxisSize.min, // Keeps the row centered in the AppBar
                children: [
                  const Text(
                    'Boot',
                    style: TextStyle(
                      fontSize: 39,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(width: 4), // Tiny gap
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Inverts the color for the badge
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'strap',
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal, // Text matches your app bar
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter email address',
                ),
                controller: emailAddressController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter password',
                ),
                controller: passwordController,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  child: const Text('Log In'),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
