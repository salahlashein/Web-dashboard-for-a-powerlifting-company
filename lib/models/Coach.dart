import 'package:flutter/material.dart';

class Coach {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  final String imagePath;

  Coach({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imagePath,
  });

  // Convert a Coach into a JSON string
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'imagePath': imagePath,
    };
  }

  // Convert a JSON string into a Coach
  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imagePath: json['imagePath'],
    );
  }
}

class CoachProvider with ChangeNotifier {
  Coach _coach = Coach(
    id: '',
    email: '',
    firstName: '',
    lastName: '',
    imagePath: '',
  );

  Coach get coach => _coach;

  void setCoach(Coach coach) {
    _coach = coach;
    notifyListeners();
  }

  Coach getcoach() {
    return _coach;
  }
}
