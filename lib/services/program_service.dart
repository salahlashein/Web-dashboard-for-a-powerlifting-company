import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/Program.dart';

class ProgramService extends ChangeNotifier {
  
  Future<String> addProgram(Program program) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('program');

    DocumentReference documentReference = collection.doc();

    Map<String, dynamic> programData = program.toJson();
    programData['id'] = documentReference.id;

    await documentReference.set(programData);
    return documentReference.id;
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
