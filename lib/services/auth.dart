import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Coach.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Coach? _userFromFirebaseUser(User? user) {
    return user != null ? Coach(uid: user.uid) : null;
  }

  Stream<Coach?> get firebaseUser {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> registerUser(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = authResult.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Coaches')
            .doc(user.uid)
            .set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        });
      }
    } catch (e) {
      print('Registration failed: ${e.toString()}');
      // Handle registration failure
    }
  }

  Future<bool> isUserSignedUp(String email) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (e) {
      print('Error checking if user is signed up: ${e.toString()}');
      return false;
    }
  }
}
