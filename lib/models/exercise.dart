import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/Workout.dart';
import 'package:web_dashboard/models/block.dart';

class Exercise {
  final String id;
  final String name;
  final String exerciseType;
  final String primary;
  final String secondary;
  final String videoLink;

  Exercise({
    required this.id,
    required this.name,
    required this.exerciseType,
    required this.primary,
    required this.secondary,
    required this.videoLink,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exerciseType': exerciseType,
      'primary': primary,
      'secondary': secondary,
      'videoLink': videoLink,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '', // Default tyo an empty string if id is null
      name: json['name'] ?? '', // Default to an empty string if name is null
      exerciseType: json['exerciseType'] ??
          '', // Default to an empty string if exerciseType is null
      primary: json['primary'] ??
          '', // Default to an empty string if primary is null
      secondary: json['secondary'] ??
          '', // Default to an empty string if secondary is null
      videoLink: json['videoLink'] ??
          '', // Default to an empty string if videoLink is null
    );
  }
}



