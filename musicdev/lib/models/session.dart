class Session {
  final int? id;
  final String? title;
  final String mood;
  final String taskType;
  final int energyLevel;
  final int durationMins;
  final String createdAt;

  Session({
    this.id,
    this.title,
    required this.mood,
    required this.taskType,
    required this.energyLevel,
    required this.durationMins,
    required this.createdAt,
  });

  // Convert Session object → Map (for saving to SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'mood': mood,
      'task_type': taskType,
      'energy_level': energyLevel,
      'duration_mins': durationMins,
      'created_at': createdAt,
    };
  }

  // Convert Map → Session object (for reading from SQLite)
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      title: map['title'],
      mood: map['mood'],
      taskType: map['task_type'],
      energyLevel: map['energy_level'],
      durationMins: map['duration_mins'],
      createdAt: map['created_at'],
    );
  }
}