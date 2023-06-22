import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/Workout.dart';
import 'package:web_dashboard/models/createprogrammodels.dart';

class WorkoutService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addWorkout(
      String dayId, Workout_p workout, String? exerciseId) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('workout');
    // Generate a new document reference with a unique ID, but don't put it in Firestore yet
    DocumentReference documentReference = collection.doc(workout.id);
    // Add the document ID and programId to the program data
    Map<String, dynamic> programData = workout.toJson();
    programData['id'] = workout.id;
    programData['dayID'] = dayId;
    programData['exerciseId'] = exerciseId;
    // add programId to programData
    await documentReference.set(programData);
    return documentReference.id;
  }

  Future<void> updateWorkout(Workout_p workout) async {
    await _db.doc(workout.id).set(workout.toJson());
  }


  Future<void> deleteWorkout(Workout workout) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('workout');

    return collection
        .doc(workout.id) // Get the document with the provided id
        .delete() // Delete the document
        .then((_) {
      print('Document deleted with ID: ${workout.id}');
    }).catchError((e) {
      print('Error deleting document: $e');
    });
  }
}
