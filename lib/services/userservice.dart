import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_dashboard/models/userdata.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late UserDataModel userData;

  Future<String> getCoachName(String coachId) async {
    try {
      var snapshot = await _firestore.collection('Coaches').doc(coachId).get();
      if (snapshot.exists) {
        userData = UserDataModel.fromJson(snapshot.data()!);
        String firstName = snapshot['firstName'];
        String lastName = snapshot['lastName'];
        return '$firstName $lastName';
      }
      return '';
    } catch (e) {
      print('Error retrieving coach name: ${e.toString()}');
      return '';
    }
  }

  Future<List<CoachBillingModel>> getCoachCoachBilling(String coachId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Coaches')
          .doc(coachId)
          .collection('CoachBilling')
          .get();
      // if (snapshot.exists) {
      //   String email = snapshot['email'];
      //   return email;
      // }
      return snapshot.docs
          .map((e) => CoachBillingModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      print('Error retrieving coach email: ${e.toString()}');
      return [];
    }
  }

  Future<List<ManageBillingModel>> getCoachManageBilling(String coachId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Coaches')
          .doc(coachId)
          .collection('ManageBilling')
          .get();
      return snapshot.docs
          .map((e) => ManageBillingModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      print('Error retrieving coach ManageBilling: ${e.toString()}');
      return [];
    }
  }

  Future<void> updateCoachNameEmail({
    required coachId,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      UserDataModel model =
          UserDataModel(firstName: firstName, lastName: lastName, email: email);
      await _firestore.collection('Coaches').doc(coachId).update(model.toMap());
    } catch (e) {
      print('Error Update coach name and email: ${e.toString()}');
    }
  }

  Future<void> updateCoachManageBilling({
    required coachId,
    required manageId,
    required String address1,
    required String address2,
    required String cardNum,
    required String city,
    required String country,
    required String postalNum,
  }) async {
    try {
      ManageBillingModel model = ManageBillingModel(
          id: manageId,
          address1: address1,
          address2: address2,
          cardNum: cardNum,
          city: city,
          country: country,
          postalNum: postalNum);
      await _firestore
          .collection('Coaches')
          .doc(coachId)
          .collection('ManageBilling')
          .doc(manageId)
          .update(model.toMap());
    } catch (e) {
      print('Error Update coach Manage Billing ${e.toString()}');
    }
  }

  Future<bool> changePassword({
    required String currentPass,
    required String newPass,
    required String reNewPass,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Verify current password
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user!.email!, password: currentPass);

      if (result.user != null) {
        // Update password
        await user.updatePassword(reNewPass);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error Change Password ${e.toString()}');
      return false;
    }
  }
}
