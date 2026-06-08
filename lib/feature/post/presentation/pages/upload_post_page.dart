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
import '../../components/location_picker_widget.dart';
import '../../domain/entities/post_location.dart';
import '../../services/location_service.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  PlatformFile? imagePickedFile;
  final textController = TextEditingController();
  AppUser? currentUser;

  PostLocation? selectedLocation;
  bool isLoadingLocation = false;
  final _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
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

  Future<void> useMyLocation() async {
    setState(() => isLoadingLocation = true);
    try {
      final location = await _locationService.getMyLocation();
      setState(() => selectedLocation = location);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoadingLocation = false);
    }
  }

  void uploadPost() {
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("I slika i caption su obavezni.")),
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
      location: selectedLocation,
      likes: [],
      comments: [],
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
        title: const Text("CREATE POST"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (imagePickedFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePickedFile!.path!),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            MaterialButton(
              onPressed: pickImage,
              color: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                imagePickedFile == null ? "CHOOSE IMAGE" : "CHANGE IMAGE",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: textController,
              hintText: "Caption",
              obscureText: false,
            ),
            const SizedBox(height: 20),
            LocationPickerWidget(
              selectedLocation: selectedLocation,
              isLoading: isLoadingLocation,
              onUseMyLocation: useMyLocation,
              onLocationSelected: (location) {
                setState(() => selectedLocation = location);
              },
              onRemove: () => setState(() => selectedLocation = null),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}