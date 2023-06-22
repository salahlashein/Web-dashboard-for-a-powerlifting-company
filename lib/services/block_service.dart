import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/block.dart';
import 'package:web_dashboard/models/createprogrammodels.dart';

class BlockService extends ChangeNotifier {
  Future<String> addBlock(String programId, Block_p block) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('block');
    // Generate a new document reference with a unique ID, but don't put it in Firestore yet
    DocumentReference documentReference = collection.doc(block.id);
    // Add the document ID and programId to the program data
    Map<String, dynamic> programData = block.toJson();
    programData['id'] = block.id;
    programData['programId'] = programId; // add programId to programData
    await documentReference.set(programData);
    return documentReference.id;
  }

  Future<void> updateBlock(Block block) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('block');

    // Convert the program to a JSON object
    Map<String, dynamic> programData = block.toJson();

    return collection
        .doc(block.id) // Get the document with the provided id
        .update(programData) // Update the document with the new data
        .then((_) {
      print('Document updated with ID: ${block.id}');
    }).catchError((e) {
      print('Error updating document: $e');
    });
  }

  Future<void> deleteBlock(Block block) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('block');

    return collection
        .doc(block.id) // Get the document with the provided id
        .delete() // Delete the document
        .then((_) {
      print('Document deleted with ID: ${block.id}');
    }).catchError((e) {
      print('Error deleting document: $e');
    });
  }
}
