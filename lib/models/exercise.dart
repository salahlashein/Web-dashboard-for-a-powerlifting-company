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
      id: json['id'],
      name: json['name'],
      exerciseType: json['exerciseType'],
      primary: json['primary'],
      secondary: json['secondary'],
      videoLink: json['videoLink'],
    );
  }
}
class Block {
  List<Day> days = [];
}

class Day {
  List<Workout> workouts = [];
}

class Workout {
  List<Set> sets = [];

}

class Set {
  // Whatever properties a set has
}

class ExerciseProvider with ChangeNotifier {
  List<Block> _blocks = [];

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
    _blocks[blockIndex].days[dayIndex].workouts[workoutIndex].sets.add(Set());
    notifyListeners();
  }


}
