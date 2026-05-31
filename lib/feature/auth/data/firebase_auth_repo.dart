import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uat_project/feature/auth/domain/entities/app_user.dart';
import 'package:uat_project/feature/auth/domain/entities/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // firebase_auth_repo.dart
  @override
  Future<void> deleteAccount({String? password}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('No user logged in.');

    try {
      await user.delete();
      await logout();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (password == null) {
          // Javi UI-u da treba lozinku
          throw Exception('requires-recent-login');
        }
        // Reauth i pokušaj opet
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        await logout();
      } else {
        throw Exception('Failed to delete account: $e');
      }
    }
  }

  @override
  Future<void> reauthenticate(String password) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('No user logged in.');

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }
  @override
  Future<AppUser?> getCurrentUser() async {
    // get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;
    // no logged in user
    if (firebaseUser == null) return null;
    // logged in user exists
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: '');
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
      );

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    // TODO: implement registerWithEmailPassword
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());
      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email! Check your inbox";
    } catch (e) {
      return "An error occured: $e";
    }
  }
}
