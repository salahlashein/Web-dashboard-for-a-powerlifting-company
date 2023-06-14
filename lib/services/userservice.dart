import 'package:cloud_firestore/cloud_firestore.dart';
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
}
