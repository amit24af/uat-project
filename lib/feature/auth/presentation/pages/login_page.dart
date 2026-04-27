import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/cubits/auth_cubit.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  void login(){
    final String email = emailController.text;
    final String pw = pwController.text;

    final authCubit =  context.read<AuthCubit>();

    if(email.isNotEmpty && pw.isNotEmpty){
      authCubit.login(email, pw);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email & password")));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login', style: TextStyle(
          color: Colors.indigo, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Column(
              children: [
              Icon(Icons.lock_open, size: 75,  color: Colors.indigo),
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
          MyButton(onTap: login, text: 'Login'),
          const SizedBox(height: 25),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Do not have an account? '),
            GestureDetector(
              onTap: widget.togglePages,

              child: Text(
                "Register now",
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
