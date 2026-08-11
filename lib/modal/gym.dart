import 'subscription.dart';

class Gym {
  final String id;
  final String gymName;
  final String ownerName;
  final String location;
  final String state;
  final String country;
  final String phone;
  final String email;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final Subscription subscription;

  Gym({
    required this.id,
    required this.gymName,
    required this.ownerName,
    required this.location,
    required this.state,
    required this.country,
    required this.phone,
    required this.email,
    required this.createdAt,
    this.lastLogin,
    required this.subscription,
  });

  Map<String, dynamic> toMap() {
    return {
      'gymName': gymName,
      'ownerName': ownerName,
      'location': location,
      'state': state,
      'country': country,
      'phone': phone,
      'email': email,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'subscription': subscription.toMap(),
    };
  }

  factory Gym.fromMap(String id, Map<String, dynamic> map) {
    return Gym(
      id: id,
      gymName: map['gymName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      location: map['location'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'].toDate(),
      lastLogin: map['lastLogin'] != null
          ? map['lastLogin'].toDate()
          : null,
      subscription: Subscription.fromMap(map['subscription']),
    );
  }
}