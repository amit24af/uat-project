import 'package:firebase_auth/firebase_auth.dart';
import 'package:uat_project/feature/auth/domain/entities/app_user.dart';
import 'package:uat_project/feature/auth/domain/entities/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> deleteAccount() async {
    try{
      final user = firebaseAuth.currentUser;
      if (user == null) throw Exception('No user logged in..');
      await user.delete();
      await logout();
    }catch (e){
      throw Exception('Failed to delete account: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async{
    // get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;
    // no logged in user
    if (firebaseUser == null) return null;
    // logged in user exists
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: '');
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try{
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(uid: userCredential.user!.uid, email: email, name: '');

      return user;
    }catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async{
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password) async {
    // TODO: implement registerWithEmailPassword
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(uid: userCredential.user!.uid, email: email, name: '');
      return user;
    } catch (e){
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email! Check your inbox";
    }catch (e){
      return "An error occured: $e";
    }
  }

}