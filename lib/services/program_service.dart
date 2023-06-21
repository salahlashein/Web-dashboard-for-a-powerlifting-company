import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Program.dart';

class ProgramService {
  Future<void> addProgram(Program program) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('program');

    // Generate a new document reference with a unique ID, but don't put it in Firestore yet
    DocumentReference documentReference = collection.doc();

    // Add the document ID to the program data
    Map<String, dynamic> programData = program.toJson();
    programData['id'] = documentReference.id;

    return documentReference
        .set(programData) // Store the program data in the new document
        .then((_) {
      print('Document added with ID: ${documentReference.id}');
    }).catchError((e) {
      print('Error adding document: $e');
    });
  }

  Future<void> updateProgram(Program program) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('program');

    // Convert the program to a JSON object
    Map<String, dynamic> programData = program.toJson();

    return collection
        .doc(program.id) // Get the document with the provided id
        .update(programData) // Update the document with the new data
        .then((_) {
      print('Document updated with ID: ${program.id}');
    }).catchError((e) {
      print('Error updating document: $e');
    });
  }

  Future<void> deleteProgram(Program program) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('program');

    return collection
        .doc(program.id) // Get the document with the provided id
        .delete() // Delete the document
        .then((_) {
      print('Document deleted with ID: ${program.id}');
    }).catchError((e) {
      print('Error deleting document: $e');
    });
  }
}
