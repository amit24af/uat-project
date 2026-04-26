import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uat_project/feature/auth/presentation/components/my_textfield.dart';

import '../components/my_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Column(
              children: [
              Icon(Icons.lock_open, size: 75),
          const SizedBox(height: 25),
          MyTextField(
            controller: emailController,
            hintText: "Email..",
            obscureText: false,
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: pwController,
            hintText: "Password..",
            obscureText: true,
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Forgot password?",
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          MyButton(onTap: () {}, text: 'Login'),
          const SizedBox(height: 25),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Do not have an account? '),
            Text(
              "Register now",
              style: TextStyle(
                  color: Colors.indigo, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ],
      ),
    ),)
    ,
    );
  }
}
