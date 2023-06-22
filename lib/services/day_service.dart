import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/Day.dart';
import 'package:web_dashboard/models/createprogrammodels.dart';

class DayService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addDay(String blockId, Day_p day) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('day');

    // Generate a new document reference with a unique ID, but don't put it in Firestore yet
    DocumentReference documentReference = collection.doc(day.id);

    // Add the document ID and blockId to the day data
    Map<String, dynamic> dayData = day.toJson();
    dayData['id'] = day.id;
    dayData['blockId'] = blockId; // add blockId to dayData

    await documentReference
        .set(dayData); // Store the day data in the new document

    return documentReference.id;
  }
}

Future<void> updateDay(Day day) async {
  CollectionReference collection = FirebaseFirestore.instance.collection('day');

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

Future<void> deleteDay(Day day) async {
  CollectionReference collection = FirebaseFirestore.instance.collection('day');

  return collection
      .doc(day.id) // Get the document with the provided id
      .delete() // Delete the document
      .then((_) {
    print('Document deleted with ID: ${day.id}');
  }).catchError((e) {
    print('Error deleting document: $e');
  });
}
