import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register', style: TextStyle(
          color: Colors.indigo, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.lock_open, size: 75,  color: Colors.indigo),
              const SizedBox(height: 25),
              MyTextField(
                controller: nameController,
                hintText: "Name..",
                obscureText: false,
              ),
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
              MyTextField(
                controller: confirmPwController,
                hintText: "Confirm password..",
                obscureText: true,
              ),


              const SizedBox(height: 25),
              MyButton(onTap: () {}, text: 'Sign Up'),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                          backgroundColor: Colors.indigo.shade50,
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
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
