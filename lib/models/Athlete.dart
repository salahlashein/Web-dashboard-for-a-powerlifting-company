class Athlete {
  final String id;
  final String firstName;
  final String lastName;
  final String imagePath;
  final double squat;
  final double bench;
  final double deadlift;
  final String email;
  final List<String> images;
  final List<String> weights;

  Athlete({
        required this.id,
    required this.firstName,
    required this.lastName,
    required this.imagePath,
    required this.squat,
    required this.bench,
    required this.deadlift,
    required this.email,
    required this.images,
    required this.weights,
  });

  // Convert an Athlete into a JSON string
  Map<String, dynamic> toJson() {
    return {
            'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'imagePath': imagePath,
      'squat': squat,
      'bench': bench,
      'deadlift': deadlift,
      'email': email,
      'images': images,
      'weights': weights,
    };
  }

  // Convert a JSON string into an Athlete
  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
            id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imagePath: json['imagePath'],
      squat: json['squat'],
      bench: json['bench'],
      deadlift: json['deadlift'],
      email: json['email'],
      images: List<String>.from(json['images']),
      weights: List<String>.from(json['weights'].map((x) => x.toDouble())),
    );
  }
}
