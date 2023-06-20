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

class Block {
  List<Day> days = [];
}

class Day {
  List<Workout> workouts = [];
}




class ExerciseProvider with ChangeNotifier {
  String _coachId = ''; // Initialize with an empty string
  List<Block> _blocks = [];
  List<Set> sets = [];
  String _currentWorkout = '';

  String get coachId => _coachId; // Define the coachId getter
  // Initialize with an empty string

  String get currentWorkout => _currentWorkout;

  void updateWorkout(String workout) {
    _currentWorkout = workout;
    notifyListeners();
  }
  List<Exercise> _exercises = [];

  // Getter
  List<Exercise> get exercises {
    return [..._exercises];
  }

  // Your existing code...

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Exercise>> getExercisesForCoach(String coachId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('exerciseLibrary')
          .where('coachId', isEqualTo: coachId)
          .get();

      List<Exercise> exercises =
          snapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList();

      return exercises;
    } catch (e) {
      print('Error retrieving exercises: ${e.toString()}');
      return [];
    }
  }
  List<Block> get blocks => _blocks;

  void addBlock() {
    _blocks.add(Block());
    notifyListeners();
  }

  void addDay(int blockIndex) {
    _blocks[blockIndex].days.add(Day());
    notifyListeners();
  }

  void addWorkout(int blockIndex, int dayIndex) {
    _blocks[blockIndex].days[dayIndex].workouts.add(Workout());
    notifyListeners();
  }

  void addSet(int blockIndex, int dayIndex, int workoutIndex) {
    print(
        'Adding set to block: $blockIndex, day: $dayIndex, workout: $workoutIndex'); // Add this line
    final newSet = Set(); // Create a new Set object

    // Add the newSet to the corresponding block, day, and workout based on the provided indices
    final block = blocks[blockIndex];
    final day = block.days[dayIndex];
    final workout = day.workouts[workoutIndex];
    workout.sets.add(newSet);

    notifyListeners();
  }
}
