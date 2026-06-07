import 'package:flutter/material.dart';
import 'package:uat_project/feature/profile/domain/entities/profile_user.dart';
abstract class SearchRepo {
  Future<List<ProfileUser?>> searchUsers(String query);
}