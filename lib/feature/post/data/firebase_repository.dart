import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uat_project/feature/post/domain/entities/post.dart';

import '../repos/post_repo.dart';

class FirebasePostRepo implements PostRepo{
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    // TODO: implement createPost
    try{
      await postCollection.doc(post.id).set(post.toJson());
    }catch(e){
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    // TODO: implement deletePost
    await postCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    // TODO: implement fetchAllPosts
    try{
      final postsSnapshot = await postCollection.orderBy('timestamp', descending: true).get();
      final List<Post> allPosts = postsSnapshot.docs.map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return allPosts;
    }catch(e){
      throw Exception("Error fetching post {$e}");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    // TODO: implement fetchPostsByUserId
    try{
      final postsSnapshot =
          await postCollection.where('userId', isEqualTo: userId).get();
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    }catch(e){
      throw Exception("Error fetching posts by userID: $userId");
    }
  }
  
}