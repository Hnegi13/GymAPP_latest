import 'package:flutter/material.dart';
import '../Screens/dashboard/header_widget.dart';
import '../Screens/dashboard/stats_panel.dart';
import '../services/attendance_service.dart';
import '../services/firestore_service.dart';
import '../services/gym_service.dart';
import 'dashboard/quick_action_bar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../modal/gym.dart';
import '../services/gym_service.dart';

class DashboardV2Page extends StatefulWidget {
  const DashboardV2Page({super.key});

  @override
  State<DashboardV2Page> createState() => _DashboardV2PageState();
}

class _DashboardV2PageState extends State<DashboardV2Page> {

  final FirestoreService firestoreService = FirestoreService();
  final AttendanceService attendanceService = AttendanceService();
  final GymService gymService = GymService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const HeaderWidget(),

            Transform.translate(
              offset: const Offset(0, -70),
              child: StreamBuilder<int>(
                stream: firestoreService.getMembersCountStream(),
                builder: (context, membersSnapshot) {

                  if (!membersSnapshot.hasData) {
                    return const StatsPanel(
                      attendanceCount: "0",
                      membersCount: "0",
                      expiringCount: "0",
                      expiredCount: "0",
                    );
                  }

                  return StreamBuilder<int>(
                    stream: firestoreService.getExpiringMembersCountStream(),
                    builder: (context, expiringSnapshot) {

                      if (!expiringSnapshot.hasData) {
                        return StatsPanel(
                          membersCount: membersSnapshot.data.toString(),
                          attendanceCount: "0",
                          expiringCount: "0",
                          expiredCount: "0",
                        );
                      }

                      return StreamBuilder<int>(
                        stream: firestoreService.getExpiredMembersCountStream(),
                        builder: (context, expiredSnapshot) {

                          if (!expiredSnapshot.hasData) {
                            return StatsPanel(
                              membersCount: membersSnapshot.data.toString(),
                              attendanceCount: "0",
                              expiringCount: expiringSnapshot.data.toString(),
                              expiredCount: "0",
                            );
                          }

                          return StreamBuilder<int>(
                            stream: attendanceService.getTodayAttendanceCountStream(),
                            builder: (context, attendanceSnapshot) {

                              return StatsPanel(
                                membersCount: membersSnapshot.data.toString(),
                                attendanceCount:
                                (attendanceSnapshot.data ?? 0).toString(),
                                expiringCount: expiringSnapshot.data.toString(),
                                expiredCount: expiredSnapshot.data.toString(),
                              );

                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -50),
              child: const QuickActionBar(),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}