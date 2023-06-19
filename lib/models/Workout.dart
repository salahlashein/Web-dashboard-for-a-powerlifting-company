class Workout {
  final String id;
  final String dayId;
  final String blockId;
  final String programId;
  final String coachId;
  final String athleteId;
  final String exerciseId;

  Workout({
    required this.id,
    required this.dayId,
    required this.blockId,
    required this.programId,
    required this.coachId,
    required this.athleteId,
    required this.exerciseId,
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
      id: json['id'],
      dayId: json['dayId'],
      blockId: json['blockId'],
      programId: json['programId'],
      coachId: json['coachId'],
      athleteId: json['athleteId'],
      exerciseId: json['exerciseId'],
    );
  }
}
