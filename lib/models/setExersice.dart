class setExersice {
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

  setExersice({
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

  factory setExersice.fromJson(Map<String, dynamic> json) {
    return setExersice(
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
