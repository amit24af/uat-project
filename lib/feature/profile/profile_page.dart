import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/cubits/auth_cubit.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit  = context.read<AuthCubit>();
    final currentUser = authCubit.CurrentUser;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.person,
                size: 80,
              ),
            ),
            Text(currentUser!.name)
          ]
        ),
      )
    );
  }
}
