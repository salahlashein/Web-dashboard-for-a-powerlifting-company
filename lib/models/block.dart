class Block {
  final String id;
  final String name;
  final String programId;
  final String coachId;
  final String athleteId;

  Block({
    required this.id,
    required this.name,
    required this.programId,
    required this.coachId,
    required this.athleteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'programId': programId,
      'coachId': coachId,
      'athleteId': athleteId,
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'],
      name: json['name'],
      programId: json['programId'],
      coachId: json['coachId'],
      athleteId: json['athleteId'],
    );
  }
}
