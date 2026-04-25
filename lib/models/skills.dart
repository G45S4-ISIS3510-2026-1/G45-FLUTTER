class Skill {
  final String id;
  final String? major;
  final String label;
  final String? iconUrl;

  Skill({
    required this.id,
    required this.major,
    required this.label,
    required this.iconUrl,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      major: json['major'],
      label: json['label'],
      iconUrl: json['iconUrl'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'major': major,
      'label': label,
      'iconUrl': iconUrl,
    };
  }
}