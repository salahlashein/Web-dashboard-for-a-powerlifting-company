import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exercise.dart';

class Exercise_service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Exercise>> getExercisesForCoach(String coachId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('exerciseLibrary')
          .where('coachId', isEqualTo: coachId)
          .get();

      List<Exercise> exercises =
          snapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList();

      return exercises;
    } catch (e) {
      print('Error retrieving exercises: ${e.toString()}');
      return [];
    }
  }
}
