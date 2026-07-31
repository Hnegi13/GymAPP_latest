import 'package:flutter/material.dart';

import '../../Attendance/attendance_history_page.dart';


class AttendanceHandler {

  static Future<void> execute(BuildContext context) async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AttendanceHistoryPage(),
      ),
    );

  }

}