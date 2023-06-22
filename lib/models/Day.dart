class Day {
  late String id;
  late String blockId;
  late String name;
  late dynamic date;
  // late String athleteId;
  // final bool done;

  Day({
    required this.id,
    required this.blockId,
    required this.name,
    required this.date,
    // required this.athleteId,
    // required this.done,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockId': blockId,
      'name': name,
      'date': date,
      // 'athleteId': athleteId,
      // 'done': done,
    };
  }

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      id: json['id'],
      blockId: json['blockId'],
      name: json['name'],
      date: json['date'],
      // athleteId: json['athleteId'],
      // done: json['done'],
    );
  }
}
