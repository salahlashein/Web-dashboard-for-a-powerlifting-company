class Workout {
  final String? id;
  final String? dayId;
  final String? exerciseId;

  Workout({
    this.id,
    this.exerciseId,
    this.dayId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'blockId': dayId,
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
