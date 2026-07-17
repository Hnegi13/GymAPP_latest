class Member {
  final String? id;
  final String name;
  final String phone;
  final String age;
  final String plan;
  final String fee;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  Member({
    this.id,
    required this.name,
    required this.phone,
    required this.age,
    required this.plan,
    required this.fee,
    required this.startDate,
    required this.endDate,
    required this.isActive
  });
}
