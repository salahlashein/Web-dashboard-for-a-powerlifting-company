import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getCoachName(String coachId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('Coaches').doc(coachId).get();
      if (snapshot.exists) {
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
}
