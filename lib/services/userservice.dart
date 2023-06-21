import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:web_dashboard/models/userdata.dart';

import '../models/Athlete.dart';

class UserService extends ChangeNotifier {
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

//salah function that get all the athleates with id of the coach

  Stream<List<Athlete>> getAthletes(String? coachId) {
    final athletesCollection =
        FirebaseFirestore.instance.collection('Athletes');
    final query = athletesCollection.where('coachId', isEqualTo: coachId);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Athlete.fromJson(data);
      }).toList();
    });
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
}
