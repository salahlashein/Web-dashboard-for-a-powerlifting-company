import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/models/block.dart';

class BlockService {
  Future<void> addBlock(Block block) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Block');

    // Generate a new document reference with a unique ID, but don't put it in Firestore yet
    DocumentReference documentReference = collection.doc();

    // Add the document ID to the program data
    Map<String, dynamic> programData = block.toJson();
    programData['id'] = documentReference.id;

    return documentReference
        .set(programData) // Store the program data in the new document
        .then((_) {
      print('Document added with ID: ${documentReference.id}');
    }).catchError((e) {
      print('Error adding document: $e');
    });
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
