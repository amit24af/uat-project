import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uat_project/feature/profile/domain/entities/profile_user.dart';
import 'package:uat_project/feature/search/domain/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo{
  // TODO: implement searchUsers
  @override
  Future<List<ProfileUser?>> searchUsers(String query) async{
    try{
      final result = await FirebaseFirestore.instance
          .collection("users")
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff').get();
      return result.docs.map((doc)=> ProfileUser.fromJson(doc.data())).toList();
    }catch(e){
      print("SEARCH ERROR: $e");
      throw Exception("Error searching for users: $e");
    }

  }
  
}