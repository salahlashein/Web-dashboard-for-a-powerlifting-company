class Workout {
  final String? id;
  final String? dayId;
  final String? blockId;
  final String? programId;
  final String? coachId;
  final String? athleteId;
  final String? exerciseId;
  List<Set> sets = [];
  String selectedExercise = '';

  Workout({
    this.id,
    this.dayId,
    this.blockId,
    this.programId,
    this.coachId,
    this.athleteId,
    this.exerciseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayId': dayId,
      'blockId': blockId,
      'programId': programId,
      'coachId': coachId,
      'athleteId': athleteId,
      'exerciseId': exerciseId,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] ?? '',
      dayId: json['dayId'] ?? '',
      blockId: json['blockId'] ?? '',
      programId: json['programId'] ?? '',
      coachId: json['coachId'] ?? '',
      athleteId: json['athleteId'] ?? '',
      exerciseId: json['exerciseId'] ?? '',
    );
  }
}
