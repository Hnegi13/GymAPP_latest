import 'package:flutter/material.dart';
import '../../services/attendance_service.dart';
import '../../modal/attendance.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() =>
      _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {

  final AttendanceService attendanceService = AttendanceService();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        centerTitle: true,
      ),
        body: Column(
          children: [

          InkWell(
          onTap: selectDate,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat('dd MMM yyyy').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),

        Expanded(
          child: FutureBuilder<List<Attendance>>(
        future: attendanceService.getAttendanceByDate(selectedDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          final attendanceList = snapshot.data ?? [];

          if (attendanceList.isEmpty) {
            return const Center(
              child: Text(
                "No attendance available for today.",
              ),
            );
          }

          return ListView.builder(
            itemCount: attendanceList.length,
            itemBuilder: (context, index) {
              final attendance = attendanceList[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                elevation: 2,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    attendance.memberName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('hh:mm a').format(
                      attendance.attendanceTime,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              );
            },
          );
        },
      ),
        )
    ],
    ),
    );
  }

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}