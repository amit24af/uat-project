import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
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
  PlatformFile? imagePickedFile;

  final bioTextController = TextEditingController();

  Future<void> pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
    );
    if(result!=null){
      setState(() {
        imagePickedFile = result.files.first;
      });
    }
  }

  void updateProfile() async{
    final profileCubit = context.read<ProfileCubit>();
    final String uid =  widget.user.uid;
    final imageMobilePath = imagePickedFile?.path;
    final String? newBio = bioTextController.text.isNotEmpty ? bioTextController.text : null;

    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(uid: uid,
          newBio: bioTextController.text,
          imageMobilePath: imageMobilePath);
    }else{
      Navigator.pop(context);
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
  Widget buildEditPage(){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        actions: [
          IconButton(onPressed: updateProfile, icon: const Icon(Icons.upload))
        ]
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,
              child: (imagePickedFile != null) ? Image.file(File(imagePickedFile!.path!), fit: BoxFit.cover) : CachedNetworkImage(
                imageUrl: widget.user.profileImageUrl,
                placeholder: (context,
                    url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.person_rounded, size: 72, color: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,),


                imageBuilder: (context, imageProvider) =>
                    Image(image: imageProvider, fit: BoxFit.cover, width: 90, height: 90),

              ),
            )
          ),
          const SizedBox(height: 25),
          Center(child: MaterialButton(onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Select Profile Picture"))),
          const SizedBox(height: 25),
          Text("Biography", style: TextStyle(
            color: Theme
                .of(context)
                .colorScheme
                .primary,
          ),),
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
