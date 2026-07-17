class Payment {

  final String? id;

  final String paymentId;
  final String receiptNumber;
  final String plan;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime paymentDate;
  final DateTime startDate;
  final DateTime endDate;
  final String transactionType;



  Payment({
    this.id,

    required this.paymentId,
    required this.receiptNumber,
    required this.plan,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentDate,
    required this.startDate,
    required this.endDate,
    required this.transactionType,
  });

  Map<String, dynamic> toMap() {
    return {

      "paymentId": paymentId,
      "receiptNumber": receiptNumber,
      "plan": plan,
      "amount": amount,
      "paymentMethod": paymentMethod,
      "paymentStatus": paymentStatus,
      "paymentDate": paymentDate,
      "startDate": startDate,
      "endDate": endDate,
      "transactionType": transactionType,

    };
  }

  factory Payment.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Payment(
      id: id,

      paymentId: map["paymentId"],
      receiptNumber: map["receiptNumber"] ?? "N/A",
      plan: map["plan"],
      amount: (map["amount"] as num).toDouble(),
      paymentMethod: map["paymentMethod"],
      paymentStatus: map["paymentStatus"],
      paymentDate: map["paymentDate"].toDate(),
      startDate: map["startDate"].toDate(),
      endDate: map["endDate"].toDate(),
      transactionType: map["transactionType"],
    );
  }
}