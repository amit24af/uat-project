import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:uat_project/feature/post/domain/entities/post.dart';
import 'package:uat_project/feature/post/presentation/cubits/post_cubit.dart';
import 'package:uat_project/feature/post/presentation/cubits/post_states.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/components/my_textfield.dart';


class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  PlatformFile? imagePickedFile;

  final textController = TextEditingController();

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.CurrentUser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
      });
    }
  }

  void uploadPost() {
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both image and caption are required.")),
      );
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timeStamp: DateTime.now(),
      location: null,
      likes: [],
      comments: []
    );

    final postCubit = context.read<PostCubit>();
    postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        print(state);
        if (state is PostLoading || state is PostUploading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            if (imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),
            MaterialButton(
              onPressed: pickImage,
              color: Theme.of(context).primaryColor,
              child: const Text("Pick Image"),
            ),
            const SizedBox(height: 25),
            MyTextField(
              controller: textController,
              hintText: "Caption",
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}