import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String? id;
  final String memberId;
  final String gymId;
  final String memberName;
  final DateTime attendanceDate;
  final DateTime attendanceTime;
  final DateTime createdAt;

  Attendance({
    this.id,
    required this.memberId,
    required this.gymId,
    required this.memberName,
    required this.attendanceDate,
    required this.attendanceTime,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'gymId': gymId,
      'memberName': memberName,
      'attendanceDate': Timestamp.fromDate(attendanceDate),
      'attendanceTime': Timestamp.fromDate(attendanceTime),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Attendance.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return Attendance(
      id: documentId,
      gymId: map['gymId'],
      memberId: map['memberId'],
      memberName: map['memberName'],
      attendanceDate:
      (map['attendanceDate'] as Timestamp).toDate(),
      attendanceTime:
      (map['attendanceTime'] as Timestamp).toDate(),
      createdAt:
      (map['createdAt'] as Timestamp).toDate(),
    );
  }
}