import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:uat_project/feature/post/presentation/cubits/post_cubit.dart';
import '../../auth/domain/entities/app_user.dart';
import '../domain/entities/comment.dart';
class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.CurrentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Comment?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<PostCubit>().deleteComment(widget.comment.postId, widget.comment.id);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(widget.comment.userName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(widget.comment.text),
          const Spacer(),
          if (isOwnPost)
            GestureDetector(
                onTap: showOptions,
                child: Icon(Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary)
            )
        ],
      ),
    );
  }
}
