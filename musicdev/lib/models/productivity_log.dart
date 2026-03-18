class ProductivityLog {
  final int? id;
  final int sessionId;
  final int focusMinutes;
  final int distractionCount;
  final String? notes;

  ProductivityLog({
    this.id,
    required this.sessionId,
    required this.focusMinutes,
    required this.distractionCount,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'focus_minutes': focusMinutes,
      'distraction_count': distractionCount,
      'notes': notes,
    };
  }

  factory ProductivityLog.fromMap(Map<String, dynamic> map) {
    return ProductivityLog(
      id: map['id'],
      sessionId: map['session_id'],
      focusMinutes: map['focus_minutes'],
      distractionCount: map['distraction_count'],
      notes: map['notes'],
    );
  }
}