class Session {
  final Map<String, dynamic> skill;
  final DateTime scheduledAt;
  final String status;
  final String studentId;
  final String tutorId;
  final String verifCode;

  Session({
    required this.skill,
    required this.scheduledAt,
    required this.status,
    required this.studentId,
    required this.tutorId,
    required this.verifCode,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      skill: Map<String, dynamic>.from(json['skill']),
      scheduledAt: DateTime.parse(json['scheduledAt']),
      status: json['status'],
      studentId: json['studentId'],
      tutorId: json['tutorId'],
      verifCode: json['verifCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skill': skill,
      'scheduledAt': scheduledAt.toIso8601String(),
      'status': status,
      'studentId': studentId,
      'tutorId': tutorId,
      'verifCode': verifCode,
    };
  }
}
