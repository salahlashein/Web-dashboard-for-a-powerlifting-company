import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/Coach.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Coach? _userFromFirebaseUser(User? user) {
    return user != null
        ? Coach(
            id: user.uid,
            email: user.email ?? '',
            firstName: '', // Update this based on how you retrieve firstName
            lastName: '', // Update this based on how you retrieve lastName
            imagePath: '', // Update this based on how you retrieve imagePath
          )
        : null;
  }

  // Auth change user stream
  Stream<Coach?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // Sign in with email and password
  Future<Coach?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Coach? user = _userFromFirebaseUser(result.user);
      notifyListeners();
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<Coach?> registerUser(
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
