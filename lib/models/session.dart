class Session {
  final Map<String, dynamic>? skill;
  final DateTime scheduledAt;
  final String status;
  final String studentId;
  final String tutorId;
  final String verifCode;
  final String? id;

  Session({
    this.skill,
    required this.scheduledAt,
    required this.status,
    required this.studentId,
    required this.tutorId,
    required this.verifCode,
    this.id,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      skill: json['skill'] != null ? Map<String, dynamic>.from(json['skill']) : null,
      scheduledAt: DateTime.parse(json['scheduledAt']),
      status: json['status'],
      // lee del backend (student.id) o del cache (studentId)
      studentId: json['student'] != null 
          ? json['student']['id'] 
          : json['studentId'] ?? '',
      tutorId: json['tutor'] != null 
          ? json['tutor']['id'] 
          : json['tutorId'] ?? '',
      verifCode: json['verifCode'] ?? '',
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (skill != null) 'skill': skill,
      'scheduledAt': scheduledAt.toIso8601String(),
      'status': status,
      'student': {'id': studentId, 'name': ''},
      'tutor': {'id': tutorId, 'name': ''},
      'verifCode': verifCode,
    };
  }
}
