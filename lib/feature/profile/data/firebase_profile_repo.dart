
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uat_project/feature/profile/domain/entities/profile_user.dart';

import '../repository/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo{
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async{
    // TODO: implement fetchUserProfile
    try{
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();
      if(userDoc.exists){
        final userData = userDoc.data();
        if(userData != null){
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            following: following,
          );
        }
      }
      return null;
    }catch(e){
      return null;
    }

  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    // TODO: implement updateProfile
    try{
      await firebaseFirestore.collection('users').doc(updatedProfile.uid).update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl,
      });
    }catch (e){
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    // TODO: implement toggleFollow
    try{
      final currentUserDocument = await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDocument = await firebaseFirestore.collection('users').doc(targetUid).get();
      if(currentUserDocument.exists && targetUserDocument.exists){
        final currentUserData = currentUserDocument.data();
        final targetUserData = targetUserDocument.data();
        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
          List<String>.from(currentUserData['following'] ?? []);

          if (currentFollowing.contains(targetUid)) {
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid])
            });

            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid])
            });
          } else {
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid])
            });

            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid])
            });
          }
        }
      }
    }catch(e){

    }
  }
}