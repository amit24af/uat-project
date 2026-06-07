import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/post/presentation/cubits/post_states.dart';

import '../../../storage/domain/storage_repo.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../repos/post_repo.dart';

class PostCubit extends Cubit<PostState>{
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({required this.postRepo, required this.storageRepo,}) : super(PostInitial());

  Future<void> createPost(Post post, {String? imagePath}) async{
    String? imageUrl;
    try {
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl =
        await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }
      final newPost = post.copyWith(imageUrl: imageUrl);
      postRepo.createPost(newPost);
      fetchAllPost();
    } catch(e){
      emit(PostError("Failed to create post: $e"));
    }
  }

  Future<void> fetchAllPost() async {
    try{
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts));
    } catch (e){
      emit(PostError('Failed to fetch posts: $e'));
    }
  }

  Future<void> deletePost(String postId) async{
    try{
      await postRepo.deletePost(postId);
    }catch(e){
      emit(PostError('Failed to delete post: $e'));
    }
  }

  Future<void> toggleLikePost(String postId, String userId) async{
    try{
      await postRepo.toggleLikePost(postId, userId);
    }catch (e){
      emit(PostError("Failed to toggle like: $e"));
    }
  }

  Future<void> addComment(String postId, Comment comment) async{
    try{
      await postRepo.addComment(postId, comment);
      await fetchAllPost();
    }catch(e){
      emit (PostError("Failed to add comment: $e"));
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try{
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPost();
    }catch(e){
      emit(PostError("Failed to delete comment: $e"));
    }
  }

}