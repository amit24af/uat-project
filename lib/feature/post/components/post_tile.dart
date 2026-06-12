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
import '../../profile/presentation/pages/profile_page.dart';
import '../domain/entities/comment.dart';
import '../domain/entities/post.dart';
import '../presentation/cubits/post_cubit.dart';
import '../../profile/domain/entities/profile_user.dart';

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
import '../../profile/presentation/pages/profile_page.dart';
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
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((error) {
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
        title: const Text("Add a new comment"),
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
            onPressed: () {
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
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
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

  void openImageViewer() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 4,
              child: CachedNetworkImage(
                imageUrl: widget.post.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── HEADER: avatar + ime + delete ──────────────────────
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfilePage(uid: widget.post.userId)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
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
                            image: imageProvider, fit: BoxFit.cover),
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
                      child: Icon(Icons.delete,
                          color:
                          Theme.of(context).colorScheme.inversePrimary),
                    ),
                ],
              ),
            ),
          ),

          // ── SLIKA ───────────────────────────────────────────────
          GestureDetector(
            onDoubleTap: openImageViewer,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.zero, bottom: Radius.zero),
              child: CachedNetworkImage(
                imageUrl: widget.post.imageUrl,
                height: 430,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(height: 430),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),
            ),
          ),

          // ── LIKE / DATUM / KOMENTAR ─────────────────────────────
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.post.likes.length.toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 12),
                ),
                const Spacer(),
                Text(
                  widget.post.timeStamp.toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 11),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(Icons.comment,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 12),
                ),
              ],
            ),
          ),

          // ── CAPTION ─────────────────────────────────────────────
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.post.userName}  ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  TextSpan(
                    text: widget.post.text,
                    style: TextStyle(
                        color:
                        Theme.of(context).colorScheme.inversePrimary),
                  ),
                ],
              ),
            ),
          ),

          // ── LOKACIJA ────────────────────────────────────────────
          if (widget.post.location != null)
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 6, top: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.post.location!.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          // ── KOMENTARI ───────────────────────────────────────────
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoaded) {
                final post = state.posts.firstWhere(
                      (p) => p.id == widget.post.id,
                  orElse: () => widget.post,
                );
                if (post.comments.isEmpty) return const SizedBox(height: 12);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.2),
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 6),
                      child: Text(
                        "Comments",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: post.comments.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CommentTile(comment: post.comments[index]);
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              } else if (state is PostLoading) {
                return const LoadingScreen();
              } else if (state is PostError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox(height: 12);
            },
          ),
        ],
      ),
    );
  }
}