class Subscription {
  final String plan;
  final int memberLimit;
  final bool isActive;
  final double amountPaid;
  final String paymentStatus;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  const Subscription({
    required this.plan,
    required this.memberLimit,
    required this.isActive,
    required this.amountPaid,
    required this.paymentStatus,
    required this.startDate,
    required this.endDate,
    required this.status,
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
      'status': status,
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
      status: map['status'] ?? "",
    );
  }
}