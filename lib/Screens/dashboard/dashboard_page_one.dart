import 'package:flutter/material.dart';
import 'package:gym_app/Screens/dashboard/stat_card.dart';
import '../../services/attendance_service.dart';
import '../../services/firestore_service.dart';

import '../member_list_page.dart';
import 'handlers/expiring_members_handler.dart';
import 'handlers/expired_members_handler.dart';
import 'handlers/attendance_handler.dart';


class DashboardPageOne extends StatefulWidget {
  final String membersCount;
  final String expiringCount;
  final String expiredCount;
  final String attendanceCount;

  const DashboardPageOne({
    super.key,
    required this.membersCount,
    required this.expiringCount,
    required this.expiredCount,
    required this.attendanceCount,
  });


  @override
  State<DashboardPageOne> createState() => _DashboardPageOneState();
}

class _DashboardPageOneState extends State<DashboardPageOne> {

  final FirestoreService firestoreService = FirestoreService();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "Members",
                value: widget.membersCount,
                subtitle: "Active Members",
                icon: Icons.people,
                color: Colors.blue,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MemberListPage(),
                    ),
                  );
                },


              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: "Attendance",
                value: widget.attendanceCount,
                subtitle: "Today",
                icon: Icons.check_circle,
                color: Colors.green,

                onTap: () => AttendanceHandler.execute(context),

              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children:  [
            Expanded(
              child: StatCard(
                title: "Expiring",
                value: widget.expiringCount,
                subtitle: "Next 3 Days",
                icon: Icons.schedule,
                color: Colors.orange,

                onTap: () {
                  ExpiringMembersHandler.execute(context);
                },


              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: "Expired",
                value: widget.expiredCount,
                subtitle: "Need Renewal",
                icon: Icons.cancel,
                color: Colors.red,

                onTap: () => ExpiredMembersHandler.execute(context),



              ),
            ),
          ],
        ),
      ],
    );
  }
}