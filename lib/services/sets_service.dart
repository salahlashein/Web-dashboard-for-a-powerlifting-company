import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:web_dashboard/models/createprogrammodels.dart';
import 'package:web_dashboard/models/setExersice.dart';

class SetsService extends ChangeNotifier{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addSet(
      String ?athleteId, String? workoutId, setExersice_p sets) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('sets');

    // Generate a new document reference with a unique ID, but don't put it in Firestore yet
    DocumentReference documentReference = collection.doc(sets.id);

    // Add the document ID to the program data
    Map<String, dynamic> programData = sets.toJson();
    programData['id'] = sets.id;
    programData['workoutId'] = workoutId;
    programData['athleteId'] = athleteId;
    programData['intensity'] = sets.intensity;
    programData['reps'] = sets.reps;
    programData['notes'] = sets.notes;
    await documentReference.set(programData);
  }

  Future<void> UpdateSets(setExersice sets) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('sets');

    // Convert the program to a JSON object
    Map<String, dynamic> programData = sets.toJson();

    return collection
        .doc(sets.id) // Get the document with the provided id
        .update(programData) // Update the document with the new data
        .then((_) {
      print('Document updated with ID: ${sets.id}');
    }).catchError((e) {
      print('Error updating document: $e');
    });
  }

  Future<void> deletesets(setExersice sets) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('sets');

    return collection
        .doc(sets.id) // Get the document with the provided id
        .delete() // Delete the document
        .then((_) {
      print('Document deleted with ID: ${sets.id}');
    }).catchError((e) {
      print('Error deleting document: $e');
    });
  }
}
