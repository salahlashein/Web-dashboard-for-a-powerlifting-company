class Workout {
  final String? id;
  final String? dayId;
  final String? exerciseId;
  List<Set> sets = [];
  String selectedExercise = '';

  Workout({
    this.id,
    this.dayId,
    this.exerciseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayId': dayId,
      'exerciseId': exerciseId,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] ?? '',
      dayId: json['dayId'] ?? '',
      exerciseId: json['exerciseId'] ?? '',
    );
  }
}
