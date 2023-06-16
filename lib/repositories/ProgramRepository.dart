import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/program.dart';

class ProgramRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Program>> getProgramsForAthlete(String athleteId) async {
    try {
      final querySnapshot = await _db
          .collection('Programs')
          .where('athleteId', isEqualTo: athleteId)
          .get();

      return querySnapshot.docs.map((doc) => Program.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting programs for athlete: ${e.toString()}');
      return [];
    }
  }

  Future<List<Program>> getProgramsForCoach(String coachId) async {
    try {
      final querySnapshot = await _db
          .collection('Programs')
          .where('coachId', isEqualTo: coachId)
          .get();

      return querySnapshot.docs.map((doc) => Program.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting programs for coach: ${e.toString()}');
      return [];
    }
  }
}
