class Program {
    final String? id;

  final String ?name;
  final String ?coachId;
  final String ?athleteId;

  Program({
     this.id,

     this.name,
     this.coachId,
     this.athleteId,
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
      id: json['id']??
          '',
      name: json['name']??
          '',
      coachId: json['coachId']??
          '',
      athleteId: json['athleteId']??
          '',
    );
  }
}