class Exercise {
  final String id;
  final String name;
  final String exerciseType;
  final String primary;
  final String secondary;
  final String videoLink;

  Exercise({
    required this.id,
    required this.name,
    required this.exerciseType,
    required this.primary,
    required this.secondary,
    required this.videoLink,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exerciseType': exerciseType,
      'primary': primary,
      'secondary': secondary,
      'videoLink': videoLink,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      exerciseType: json['exerciseType'],
      primary: json['primary'],
      secondary: json['secondary'],
      videoLink: json['videoLink'],
    );
  }
}
