import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/components/loading.dart';
import 'package:uat_project/feature/auth/presentation/components/my_textfield.dart';
import 'package:uat_project/feature/profile/presentation/cubits/profile_states.dart';

import '../../domain/entities/profile_user.dart';
import '../cubits/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();

  void updateProfile() async{

    final profileCubit = context.read<ProfileCubit>();
    if(bioTextController.text.isNotEmpty){
      profileCubit.updateProfile(uid: widget.user.uid, newBio: bioTextController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if(state is ProfileLoading){
          return Scaffold(
            body: LoadingScreen(),

          );
        }else{
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded){
          Navigator.pop(context);
        }
      },
    );
  }
  Widget buildEditPage({double uploadProgress = 0.0}){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: updateProfile, icon: const Icon(Icons.upload))
        ]
      ),
      body: Column(
        children: [
          const Text("Biography"),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MyTextField(controller: bioTextController, hintText: widget.user.bio, obscureText: false),
          )
        ],
      )
    );
  }
}
