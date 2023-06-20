class setExersice {
  String id;
  String dayId;
  String blockId;
  String programId;
  String coachId;
  String athleteId;
  String workoutId;
  String exerciseId;
  String reps;
  String intensity;
  String load;
  String RPE;
  bool done;
  String link;
  String notes;

  setExersice({
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

  factory setExersice.fromJson(Map<String, dynamic> json) {
    return setExersice(
      id: json['id'],
      dayId: json['dayId'],
      blockId: json['blockId'],
      programId: json['programId'],
      coachId: json['coachId'],
      athleteId: json['athleteId'],
      workoutId: json['workoutId'],
      exerciseId: json['exerciseId'],
      reps: json['reps'],
      intensity: json['intensity'],
      RPE: json['RPE'],
      load: json['load'],
      done: json['done'],
      link: json['link'],
      notes: json['notes'],
    );
  }
}
