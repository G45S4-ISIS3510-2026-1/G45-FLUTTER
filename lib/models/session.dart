class Session {
  final String id;
  final String userId;
  final String date;
  final String time;
  final String price;

  Session({
    required this.id,
    required this.userId,
    required this.date,
    required this.time,
    required this.price,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      time: json['time'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'time': time,
      'price': price,
    };
  }
}
