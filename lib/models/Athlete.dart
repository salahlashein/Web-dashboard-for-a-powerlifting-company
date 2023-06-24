import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Athlete {
  final String id;
  final String firstName;
  final String lastName;
  final String imagePath;
  final String squat;
  final String bench;
  final String deadlift;
  final String email;
  final List<String> images;
  final List<String> weights;

  Athlete({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.imagePath,
    required this.squat,
    required this.bench,
    required this.deadlift,
    required this.email,
    required this.images,
    required this.weights,
  });

  // Convert an Athlete into a JSON string
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'imagePath': imagePath,
      'squat': squat,
      'bench': bench,
      'deadlift': deadlift,
      'email': email,
      'images': images,
      'weights': weights,
    };
  }

  // Convert a JSON string into an Athlete
  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      imagePath: json['imagePath'] ??
          'https://firebasestorage.googleapis.com/v0/b/powerlifting-application-11263.appspot.com/o/progress_photos%2FHuGTSTBaJGPowITEjCFKSuIh3gX2%2F1687467358077_0.jpg?alt=media&token=62d58f0b-afc4-4127-80c9-509c6beef307',
      squat: json['squat'] ?? '',
      bench: json['bench'] ?? '',
      deadlift: json['deadlift'] ?? '',
      email: json['email'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      weights: List<String>.from((json['weights'] ?? [])),
    );
  }
}
