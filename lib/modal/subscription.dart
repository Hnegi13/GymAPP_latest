class Subscription {
  final String plan;
  final int memberLimit;
  final bool isActive;
  final double amountPaid;
  final String paymentStatus;
  final DateTime startDate;
  final DateTime endDate;

  const Subscription({
    required this.plan,
    required this.memberLimit,
    required this.isActive,
    required this.amountPaid,
    required this.paymentStatus,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'plan': plan,
      'memberLimit': memberLimit,
      'isActive': isActive,
      'amountPaid': amountPaid,
      'paymentStatus': paymentStatus,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      plan: map['plan'],
      memberLimit: map['memberLimit'],
      isActive: map['isActive'],
      amountPaid: (map['amountPaid'] as num).toDouble(),
      paymentStatus: map['paymentStatus'],
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
    );
  }
}