import 'package:flutter/foundation.dart';

class ExerciseProvider with ChangeNotifier {
  String? athleteId;
  String name = '';
  List<Block_p> _blocks = [];
  List<setExersice_p> _exercises = [];

  List<Block_p> get blocks => _blocks;
  List<setExersice_p> get exercises => _exercises;

  void setAthleteId(String id) {
    athleteId = id;
    print('Selected athleteId: $athleteId'); // print the selected athleteId
    notifyListeners(); // Notifies all the listeners about this change.
  }

  void addBlock() {
    // Add a new Block to _blocks
    _blocks.add(Block_p());
    notifyListeners();
  }

  void addDay(int blockIndex) {
    // Add a new Day to the block at blockIndex
    _blocks[blockIndex].addDay();
    notifyListeners();
  }

  void addWorkout(int blockIndex, int dayIndex) {
    // Add a new Workout to the day at dayIndex in the block at blockIndex
    _blocks[blockIndex].days[dayIndex].addWorkout();
    notifyListeners();
  }

  void addSet(int blockIndex, int dayIndex, int workoutIndex) {
    // Add a new Set to the workout at workoutIndex in the day at dayIndex in the block at blockIndex
    _blocks[blockIndex].days[dayIndex].workouts[workoutIndex].addSet();
    notifyListeners();
  }

  void loadExercises() {
    // TODO: Replace with your actual logic to load exercises
    // For example, from a database, API, etc.
    _exercises = [];
    notifyListeners();
  }
}

class Block_p {
  List<Day_p> days = [];

  void addDay() {
    days.add(Day_p());
  }
}

class Day_p {
  List<Workout_p> workouts = [];

  void addWorkout() {
    workouts.add(Workout_p());
  }
}

class Workout_p {
  String selectedExercise = '';
  List<setExersice_p> sets = [];

  void addSet() {
    sets.add(setExersice_p());
  }
}

class setExersice_p {
  String name = '';
  String reps = '';
  String intensity = '';
  String notes = '';
}
