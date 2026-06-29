import 'package:flutter/material.dart';
import 'add_member_page.dart';
import 'member_list_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Gym Manager",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              child: Icon(Icons.person),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Good Morning 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Here's today's summary",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                children:  [

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MemberListPage(),
                        ),
                      );
                    },
                    child: const DashboardCard(
                      title: "Members",
                      value: "152",
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),

                  DashboardCard(
                    title: "Attendance",
                    value: "89",
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),

                  DashboardCard(
                    title: "Payments",
                    value: "₹25K",
                    icon: Icons.payments,
                    color: Colors.orange,
                  ),

                  DashboardCard(
                    title: "Expiring",
                    value: "12",
                    icon: Icons.timer,
                    color: Colors.red,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 40,
              color: color,
            ),

            const SizedBox(height: 15),

            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

          ],
        ),
      ),
    );
  }
}