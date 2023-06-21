class Day {
  final String? id;
  final String? blockId;

  final bool? done;

  Day({
    required this.id,
    required this.blockId,
    required this.done,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockId': blockId,
      'done': done,
    };
  }

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      id: json['id'] ?? '',
      blockId: json['blockId'] ?? '',
      done: json['done'] ?? '',
    );
  }
}
