class Block {
  final String? id;
  final String? name;
  final String? programId;

  Block({
    this.id,
    this.name,
    this.programId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'programId': programId,
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      programId: json['programId'] ?? '',
    );
  }
}
