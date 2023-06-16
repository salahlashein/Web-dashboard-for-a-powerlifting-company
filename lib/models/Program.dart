class Program {
    final String id;

  final String name;
  final String coachId;
  final String athleteId;

  Program({
    required this.id,

    required this.name,
    required this.coachId,
    required this.athleteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coachId': coachId,
      'athleteId': athleteId,
    };
  }

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      name: json['name'],
      coachId: json['coachId'],
      athleteId: json['athleteId'],
    );
  }
}