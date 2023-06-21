import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/models/Workout.dart';

class WorkoutService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addWorkout(Workout workout) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Workout');

    // Generate a new document reference with a unique ID, but don't put it in Firestore yet
    DocumentReference documentReference = collection.doc();

    // Add the document ID to the program data
    Map<String, dynamic> programData = workout.toJson();
    programData['id'] = documentReference.id;

    return documentReference
        .set(programData) // Store the program data in the new document
        .then((_) {
      print('Document added with ID: ${documentReference.id}');
    }).catchError((e) {
      print('Error adding document: $e');
    });
  }

  Future<void> updateWorkout(Workout workout) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('workout');

    // Convert the program to a JSON object
    Map<String, dynamic> programData = workout.toJson();

    return collection
        .doc(workout.id) // Get the document with the provided id
        .update(programData) // Update the document with the new data
        .then((_) {
      print('Document updated with ID: ${workout.id}');
    }).catchError((e) {
      print('Error updating document: $e');
    });
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
