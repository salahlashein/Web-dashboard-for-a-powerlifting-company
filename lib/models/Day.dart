class Day {
  final String id;
  final String blockId;
  final String programId;
  final String coachId;
  final String athleteId;
  final bool done;

  Day({
    required this.id,
    required this.blockId,
    required this.programId,
    required this.coachId,
    required this.athleteId,
    required this.done,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockId': blockId,
      'programId': programId,
      'coachId': coachId,
      'athleteId': athleteId,
      'done': done,
    };
  }

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      id: json['id'],
      blockId: json['blockId'],
      programId: json['programId'],
      coachId: json['coachId'],
      athleteId: json['athleteId'],
      done: json['done'],
    );
  }
}
