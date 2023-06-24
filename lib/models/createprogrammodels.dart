import 'package:flutter/foundation.dart';
import 'package:web_dashboard/services/workout_service.dart';

class ExerciseProvider with ChangeNotifier {
  String? athleteId;
  String name = '';
  List<Block_p> _blocks = [];
  List<setExersice_p> _exercises = [];

  List<Block_p> get blocks => _blocks;
  List<setExersice_p> get exercises => _exercises;

  void setAthleteId(String id) {
    athleteId = id;
    print('Selected athleteId: $athleteId');
    notifyListeners();
  }

  void addBlock() {
    _blocks.add(Block_p());
    notifyListeners();
  }

  void addDay(int blockIndex, String dayId) {
    _blocks[blockIndex].addDay(dayId);
    notifyListeners();
  }

  void addWorkout(int blockIndex, int dayIndex, Workout_p work) {
    _blocks[blockIndex].days[dayIndex].addWorkout(work);
    notifyListeners();
  }

  void addSet(
      int blockIndex, int dayIndex, int workoutIndex, setExersice_p set) {
    _blocks[blockIndex].days[dayIndex].workouts[workoutIndex].addSet(set);

    // Update the workout in Firestore
    String workoutId =
        _blocks[blockIndex].days[dayIndex].workouts[workoutIndex].id;
    WorkoutService().updateWorkout(
        _blocks[blockIndex].days[dayIndex].workouts[workoutIndex]);

    notifyListeners();
    print('Set added and listeners notified');
  }

  void loadExercises() {
    _exercises = [];
    notifyListeners();
  }

  void addBlockId(int index, String blockId) {
    blocks[index].id = blockId;
    notifyListeners();
  }

  void addDayId(int blockIndex, int dayIndex, String DayId) {
    _blocks[blockIndex].days[dayIndex].id = DayId;
    notifyListeners();
  }

  void addWorkoutId(
      int blockIndex, int dayIndex, int workoutIndex, String workoutId) {
    _blocks[blockIndex].days[dayIndex].workouts[workoutIndex].id = workoutId;
    notifyListeners();
  }
}

class Block_p {
  String? id = '';
  String? name = '';
  String? programId = '';
  List<Day_p> days = [];

  Block_p({
    this.id,
    this.name,
    this.programId,
  });

  void addDay(String dayId) {
    days.add(Day_p(id: dayId));
  }

  String? getBlockId() {
    return id;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'programId': programId,
      'days': days.map((set) => set.toJson()).toList(),
    };
  }

  factory Block_p.fromJson(Map<String, dynamic> json) {
    return Block_p(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      programId: json['programId'] ?? '',
    );
  }
}

class Day_p {
  List<Workout_p> workouts = [];

  void addWorkout(Workout_p workout) {
    workouts.add(workout);
  }

  String id;
  final String? blockId;
  final bool? done;

  Day_p({
    required this.id,
    this.blockId,
    this.done,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockId': blockId,
      'done': done,
      'workouts': workouts.map((set) => set.toJson()).toList(),
    };
  }

  factory Day_p.fromJson(Map<String, dynamic> json) {
    return Day_p(
      id: json['id'] ?? '',
      blockId: json['blockId'] ?? '',
      done: json['done'] ?? '',
    );
  }
}

class Workout_p {
  String selectedExercise = '';
  String? selectedExerciseId = '';
  List<setExersice_p> sets = [];

  void setSelectedExercise(String exerciseName, String exerciseId) {
    selectedExercise = exerciseName;
    selectedExerciseId = exerciseId;
  }

  void addSet(setExersice_p set) {
    sets.add(set);
  }

  late String id;
  final String? dayId;
  final String? exerciseId;

  Workout_p({
    required this.id,
    this.exerciseId,
    this.dayId,
    this.sets = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'blockId': dayId,
      'sets': sets.map((set) => set.toJson()).toList(),
    };
  }

  factory Workout_p.fromJson(Map<String, dynamic> json) {
    return Workout_p(
      id: json['id'] ?? '',
      dayId: json['dayId'] ?? '',
      exerciseId: json['exerciseId'] ?? '',
    );
  }
}

class setExersice_p {
  String? id;
  String? athleteId;

  String? workoutId;
  String? reps;
  String? intensity;
  String? load;
  String? RPE;
  bool? done;
  String? link;
  String? notes;

  setExersice_p({
    this.id,
    this.workoutId,
    this.reps,
    this.intensity,
    this.load,
    this.RPE,
    this.done,
    this.link,
    this.notes,
    this.athleteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'reps': reps,
      'intensity': intensity,
      'load': load,
      'RPE': RPE,
      'done': done,
      'link': link,
      'notes': notes,
      'athleteId': athleteId,
    };
  }

  factory setExersice_p.fromJson(Map<String, dynamic> json) {
    return setExersice_p(
      id: json['id'] ?? '',
      workoutId: json['workoutId'] ?? '',
      reps: json['reps'] ?? '',
      intensity: json['intensity'] ?? '',
      RPE: json['RPE'] ?? '',
      load: json['load'] ?? '',
      done: json['done'] ?? '',
      link: json['link'] ?? '',
      notes: json['notes'] ?? '',
      athleteId: json['athleteId'] ?? '',
    );
  }
}
