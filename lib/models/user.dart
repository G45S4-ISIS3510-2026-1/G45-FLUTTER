class User {
  final String id;
  final String name;
  final String email;
  final String major;
  final bool isTutoring;
  final int uniandesId;
  final List<String> tutoringSkills;
  final List<String> interestedSkills;
  final List<String> fcmTokens;
  final List<String> favTutors;
  final Map<String, dynamic> availability;
  final List<dynamic> paymentMethods;
  final int sessionPrice;
  final String profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.isTutoring,
    required this.uniandesId,
    required this.tutoringSkills,
    required this.interestedSkills,
    required this.fcmTokens,
    required this.favTutors,
    required this.availability,
    required this.paymentMethods,
    required this.sessionPrice,
    required this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      major: json["major"],
      isTutoring: json["isTutoring"],
      uniandesId: json["uniandesId"],
      tutoringSkills: List<String>.from(json["tutoringSkills"]),
      interestedSkills: List<String>.from(json["interestedSkills"]),
      fcmTokens: List<String>.from(json["fcmTokens"]),
      favTutors: List<String>.from(json["favTutors"]),
      availability: Map<String, dynamic>.from(json["availability"]),
      paymentMethods: List<dynamic>.from(json["paymentMethods"]),
      sessionPrice: json["sessionPrice"],
      profileImageUrl: json["profileImageUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "major": major,
      "isTutoring": isTutoring,
      "uniandesId": uniandesId,
      "tutoringSkills": tutoringSkills,
      "interestedSkills": interestedSkills,
      "fcmTokens": fcmTokens,
      "favTutors": favTutors,
      "availability": availability,
      "paymentMethods": paymentMethods,
      "sessionPrice": sessionPrice,
      "profileImageUrl": profileImageUrl,
    };
  }
}
