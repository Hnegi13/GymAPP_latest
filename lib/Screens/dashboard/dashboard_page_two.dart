import 'package:flutter/material.dart';
import 'stat_card.dart';

class DashboardPageTwo extends StatefulWidget {
  const DashboardPageTwo({super.key});

  @override
  State<DashboardPageTwo> createState() => _DashboardPageTwoState();
}

class _DashboardPageTwoState extends State<DashboardPageTwo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: StatCard(
                title: "Reports",
                value: "12",
                subtitle: "Monthly Reports",
                icon: Icons.bar_chart,
                color: Colors.purple,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}