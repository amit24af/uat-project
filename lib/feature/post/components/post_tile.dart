import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/components/loading.dart';
import 'package:uat_project/feature/post/components/comment_tile.dart';
import 'package:uat_project/feature/post/presentation/cubits/post_states.dart';
import 'package:uat_project/feature/profile/presentation/cubits/profile_cubit.dart';
import '../../auth/domain/entities/app_user.dart';
import '../../auth/presentation/components/my_textfield.dart';
import '../../auth/presentation/cubits/auth_cubit.dart';
import '../domain/entities/comment.dart';
import '../domain/entities/post.dart';
import '../presentation/cubits/post_cubit.dart';
import '../../profile/domain/entities/profile_user.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  AppUser? currentUser;

  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.CurrentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  final commentTextController = TextEditingController();

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add a new comment"),
        content: MyTextField(
          controller: commentTextController,
          hintText: "Comment something...",
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          TextButton(
          onPressed: ()  {
            addComment();
            Navigator.of(context).pop();
          },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void addComment() {
    final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: commentTextController.text,
        timestamp: DateTime.now(),
    );
    if(commentTextController.text.isNotEmpty){
      postCubit.addComment(widget.post.id, newComment);
    }
  }
  @override
  void dispose(){
    commentTextController.dispose();
    super.dispose();
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person_rounded),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person_rounded),

                const SizedBox(width: 10),

                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          ///
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUser!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.post.likes.contains(currentUser!.uid)
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.post.likes.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(widget.post.timeStamp.toString()),
                const SizedBox(width: 12),

                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                      Icons.comment,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary
                  ),
                ),

                Text(widget.post.comments.length.toString(),
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      fontSize: 12,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Row(children: [
              Text(
                  widget.post.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),

              Text(widget.post.text),
            ]
            ),
          ),
          BlocBuilder<PostCubit, PostState>(
              builder: (context, state){
              if(state is PostLoaded){
                final post = state.posts.firstWhere((post) => (post.id == widget.post.id));
                if(post.comments.isNotEmpty){
                  int showCommentCount =  post.comments.length;
                  return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final comment = post.comments[index];


                      return CommentTile(comment: comment);

                      },
                  );
                }
              }
              if(state is PostLoading){
                return LoadingScreen();
              }
              else if (state is PostError){
                return Center(child: Text(state.message));
              }
              else{
                return const Center(
                  child: Text("Something went wrong"),
                );
              }

          })
        ],
      ),
    );
  }

}
