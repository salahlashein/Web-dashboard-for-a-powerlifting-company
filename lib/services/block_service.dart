import 'package:cloud_firestore/cloud_firestore.dart';

class BlockService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addBlock(String coachId, String programId, String athleteId,String name) async {
    try {
      // Add a new document to the 'Programs' collection
      await _db.collection('Programs').add({
        'name': name,
        'programId': programId,
        'coachId': coachId, // The ID of the coach who created the program
        'athleteId': athleteId, // The ID of the athlete to whom the program is assigned
        // Add any other attributes of the Program here.
      });
    } catch (e) {
      print('Error adding program: ${e.toString()}');
      // Handle error when adding a program
    }
  }



  
}
