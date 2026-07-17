import 'subscription.dart';

class Gym {
  final String id;
  final String gymName;
  final String ownerName;
  final String phone;
  final String email;
  final DateTime createdAt;
  final Subscription subscription;

  Gym({
    required this.id,
    required this.gymName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.subscription,
  });

  Map<String, dynamic> toMap() {
    return {
      'gymName': gymName,
      'ownerName': ownerName,
      'phone': phone,
      'email': email,
      'createdAt': createdAt,
      'subscription': subscription.toMap(),
    };
  }

  factory Gym.fromMap(String id, Map<String, dynamic> map) {
    return Gym(
      id: id,
      gymName: map['gymName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'].toDate(),
      subscription: Subscription.fromMap(map['subscription']),
    );
  }
}