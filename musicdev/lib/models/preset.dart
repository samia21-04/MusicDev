class Preset {
  final int? id;
  final String name;
  final String sounds; // stored as JSON string e.g. '{"Rain":0.5,"Lofi":0.8}'
  final String? mood;
  final int pomodoroMins;
  final int breakMins;

  Preset({
    this.id,
    required this.name,
    required this.sounds,
    this.mood,
    required this.pomodoroMins,
    required this.breakMins,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sounds': sounds,
      'mood': mood,
      'pomodoro_mins': pomodoroMins,
      'break_mins': breakMins,
    };
  }

  factory Preset.fromMap(Map<String, dynamic> map) {
    return Preset(
      id: map['id'],
      name: map['name'],
      sounds: map['sounds'],
      mood: map['mood'],
      pomodoroMins: map['pomodoro_mins'],
      breakMins: map['break_mins'],
    );
  }
}