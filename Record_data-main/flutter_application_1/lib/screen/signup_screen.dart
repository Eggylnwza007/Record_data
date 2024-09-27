import 'package:flutter/material.dart';
import 'package:task/service/auth-service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () async {
                var res = await AuthService().registration(
                  email: _emailController.text,
                  password: _passwordController.text,
                  confirm: _confirmPasswordController.text,
                );
                if (res == 'success') {
                  Navigator.pop(context); // กลับไปที่หน้า Sign In
                } else {
                  setState(() {
                    errorMessage = res;
                  });
                }
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}