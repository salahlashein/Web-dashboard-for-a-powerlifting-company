class Sets {
  final String id;
  final String dayId;
  final String blockId;
  final String programId;
  final String coachId;
  final String athleteId;
  final String workoutId;
  final String exerciseId;
  final int reps;
  final double intensity;
  final double load;
  final double RPE;
  final bool done;
  final String link;
  final String notes;

  Sets({
    required this.id,
    required this.dayId,
    required this.blockId,
    required this.programId,
    required this.coachId,
    required this.athleteId,
    required this.workoutId,
    required this.exerciseId,
    required this.reps,
    required this.intensity,
    required this.load,
    required this.RPE,
    required this.done,
    required this.link,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayId': dayId,
      'blockId': blockId,
      'programId': programId,
      'coachId': coachId,
      'athleteId': athleteId,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'reps': reps,
      'intensity': intensity,
      'load': load,
      'RPE': RPE,
      'done': done,
      'link': link,
      'notes': notes,
    };
  }

  factory Sets.fromJson(Map<String, dynamic> json) {
    return Sets(
      id: json['id'],
      dayId: json['dayId'],
      blockId: json['blockId'],
      programId: json['programId'],
      coachId: json['coachId'],
      athleteId: json['athleteId'],
      workoutId: json['workoutId'],
      exerciseId: json['exerciseId'],
      reps: json['reps'],
      intensity: (json['intensity'] as num).toDouble(),
      load: (json['load'] as num).toDouble(),
      RPE: (json['RPE'] as num).toDouble(),
      done: json['done'],
      link: json['link'],
      notes: json['notes'],
    );
  }
}
