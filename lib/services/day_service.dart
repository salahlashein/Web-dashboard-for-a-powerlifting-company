import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/models/Day.dart';

class DayService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addDay(Day day) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Day');

    // Generate a new document reference with a unique ID, but don't put it in Firestore yet
    DocumentReference documentReference = collection.doc();

    // Add the document ID to the program data
    Map<String, dynamic> programData = day.toJson();
    programData['id'] = documentReference.id;

    return documentReference
        .set(programData) // Store the program data in the new document
        .then((_) {
      print('Document added with ID: ${documentReference.id}');
    }).catchError((e) {
      print('Error adding document: $e');
    });
  }

  Future<void> updateDay(Day day) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('workout');

    // Convert the program to a JSON object
    Map<String, dynamic> programData = day.toJson();

    return collection
        .doc(day.id) // Get the document with the provided id
        .update(programData) // Update the document with the new data
        .then((_) {
      print('Document updated with ID: ${day.id}');
    }).catchError((e) {
      print('Error updating document: $e');
    });
  }

    Future<void> deleteDary(Day day) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('day');

    return collection
        .doc(day.id) // Get the document with the provided id
        .delete() // Delete the document
        .then((_) {
      print('Document deleted with ID: ${day.id}');
    }).catchError((e) {
      print('Error deleting document: $e');
    });
  }

}
