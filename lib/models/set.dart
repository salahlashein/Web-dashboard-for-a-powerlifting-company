class setExersice {
  String id;
  String workoutId;
  String reps;
  String intensity;
  String load;
  String RPE;
  bool done;
  String link;
  String notes;

  setExersice({
    required this.id,
    required this.workoutId,
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
      'workoutId': workoutId,
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
      workoutId: json['workoutId'],
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
