import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/components/loading.dart';
import 'package:uat_project/feature/home/presentation/components/drawer.dart';
import 'package:uat_project/feature/post/presentation/cubits/post_cubit.dart';
import 'package:uat_project/feature/post/presentation/cubits/post_states.dart';
import 'package:uat_project/feature/post/presentation/pages/upload_post_page.dart';

import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../post/components/post_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPost();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPostPage(),
                  ),
                );
              },
            ),

            /* IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final authCubit = context.read<AuthCubit>();
              authCubit.logout();
            },
          ), */
          ],
        ),

        drawer: MyDrawer(),
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading && state is PostUploading) {
              return LoadingScreen();
            } else if (state is PostLoaded) {
              final allPosts = state.posts;
              if (allPosts.isEmpty) {
                return const Center(
                  child: Text("No posts available"),
                );
              }

              return ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  return PostTile(
                    post: post,
                    onDeletePressed: () => deletePost(post.id),
                  );
                },
              );
            } else if (state is PostError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        )
    );
  }
}