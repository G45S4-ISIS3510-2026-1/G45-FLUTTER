class User {
  final String id;
  final String name;
  final String email;
  final String major;
  final bool isTutoring;
  final int uniandesId;
  final List<String> tutoringSkills;
  List<String> interestedSkills;
  final List<String> fcmTokens;
  final List<String> favTutors;
  final Map<String, dynamic> availability;
  final List<dynamic> paymentMethods;
  final int? sessionPrice;
  final String? profileImageUrl;

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

  factory User.fromMock(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? json["uniandesId"]?.toString() ?? "unknown",
      name: json["name"] ?? "Sin nombre",
      email: json["email"] ?? "",
      major: json["major"] ?? "Otro",
      isTutoring: json["isTutoring"] ?? (json["price"] != null),
      uniandesId: int.tryParse(json["uniandesId"]?.toString() ?? "0") ?? 0,
      tutoringSkills: json["tutoring_skills"] != null
          ? List<String>.from(json["tutoring_skills"])
          : (json["tutoringSkills"] != null
                ? List<String>.from(json["tutoringSkills"])
                : []),
      interestedSkills: json["interestedSkills"] != null
          ? List<String>.from(json["interestedSkills"])
          : [],
      fcmTokens: json["fcmTokens"] != null
          ? List<String>.from(json["fcmTokens"])
          : [],
      favTutors: json["favTutors"] != null
          ? List<String>.from(json["favTutors"])
          : [],
      availability: json["availability"] != null
          ? Map<String, dynamic>.from(json["availability"])
          : {},
      paymentMethods: json["paymentMethods"] != null
          ? List<dynamic>.from(json["paymentMethods"])
          : [],
      sessionPrice:
          json["sessionPrice"] ??
          int.tryParse(
            json["price"]?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? "",
          ),
      profileImageUrl: json["profileImageUrl"] ?? json["image"],
    );
  }

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
