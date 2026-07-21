import 'package:cloud_firestore/cloud_firestore.dart';

import '../modal/attendance.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference attendanceCollection = FirebaseFirestore.instance.collection('attendance');


  Future<bool> isAttendanceMarkedToday(String memberId) async {

    final now = DateTime.now();

    final todayStart = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final todayEnd = todayStart.add(
      const Duration(days: 1),
    );

    final snapshot = await attendanceCollection
        .where('memberId', isEqualTo: memberId)
        .where(
      'attendanceDate',
      isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
    )
        .where(
      'attendanceDate',
      isLessThan: Timestamp.fromDate(todayEnd),
    )
        .get();

    return snapshot.docs.isNotEmpty;
  }

  //marks attendence

  Future<bool> markAttendance({
    required String memberId,
    required String memberName,
  }) async {

    final alreadyMarked = await isAttendanceMarkedToday(memberId);

    if (alreadyMarked) {
      return false;
    }

    final now = DateTime.now();

    final attendance = Attendance(
      memberId: memberId,
      memberName: memberName,
      attendanceDate: DateTime(
        now.year,
        now.month,
        now.day,
      ),
      attendanceTime: now,
      createdAt: now,
    );

    await attendanceCollection.add(
      attendance.toMap(),
    );

    return true;
  }

//for dashbord display no of member attended the hym
  Future<int> getTodayAttendanceCount() async {

    final now = DateTime.now();

    final todayStart = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final todayEnd = todayStart.add(
      const Duration(days: 1),
    );

    final snapshot = await attendanceCollection
        .where(
      'attendanceDate',
      isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
    )
        .where(
      'attendanceDate',
      isLessThan: Timestamp.fromDate(todayEnd),
    )
        .get();

    return snapshot.docs.length;
  }

  Future<List<Attendance>> getAttendanceByDate(
      DateTime selectedDate) async {

    final dayStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final dayEnd = dayStart.add(
      const Duration(days: 1),
    );

    final snapshot = await attendanceCollection
        .where(
      'attendanceDate',
      isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart),
    )
        .where(
      'attendanceDate',
      isLessThan: Timestamp.fromDate(dayEnd),
    )
        .orderBy('attendanceTime')
        .get();

    return snapshot.docs.map((doc) {
      return Attendance.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }



}