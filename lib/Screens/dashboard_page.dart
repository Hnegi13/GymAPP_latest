import 'package:flutter/material.dart';
import 'add_member_page.dart';
import 'member_list_page.dart';
import '../services/firestore_service.dart';
import 'filtered_members_page.dart';
import '../modal/member.dart';
import '../auth/auth_service.dart';
import '../services/gym_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payments_home_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();
  final GymService gymService = GymService();

  String ownerName = "";
  String gymName = "";

  int totalMembers = 0;
  int expiringMembers = 0;
  int expiredMembers = 0;

  @override
  Future<void> loadDashboardData() async {

    expiringMembers = await firestoreService.getExpiringMembersCount();
    expiredMembers = await firestoreService.getExpiredMembersCount();
    totalMembers = await firestoreService.getMembersCount();


    setState(() {});
  }

  Future<void> loadGymDetails() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final gym = await gymService.getGym(uid);

    if (gym != null) {
      setState(() {
        ownerName = gym.ownerName;
        gymName = gym.gymName;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    loadDashboardData();
    loadGymDetails();
  }
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
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            onSelected: (value) async {

              if (value == "logout") {
                await authService.signOut();
              }

            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "${getGreeting()}, $ownerName 👋",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  gymName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
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
              ],
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                children: [

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MemberListPage(),
                        ),
                      );
                    },
                    child:  StreamBuilder<int>(
                      stream: firestoreService.getMembersCountStream(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return DashboardCard(
                          title: "Members",
                          value: snapshot.data.toString(),
                          icon: Icons.people,
                          color: Colors.blue,
                        );
                      },
                    ),
                  ),

                  InkWell(
                    onTap: () async {

                      List<Member> members =
                      await firestoreService.getExpiringMembers();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FilteredMembersPage(
                            title: "Expiring",
                            members: members,
                            isExpired: false,
                          ),
                        ),
                      );
                    },

                    child: StreamBuilder<int>(
                      stream: firestoreService.getExpiringMembersCountStream(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return DashboardCard(
                          title: "Expiring",
                          value: snapshot.data.toString(),
                          icon: Icons.warning_amber_rounded,
                          color: Colors.orange,
                        );
                      },
                    )
                  ),

                  InkWell(
                    onTap: () async {

                      List<Member> members =
                      await firestoreService.getExpiredMembers();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FilteredMembersPage(
                            title: "Expired",
                            members: members,
                            isExpired: true,
                          ),
                        ),
                      );
                    },

                    child: StreamBuilder<int>(
                      stream: firestoreService.getExpiredMembersCountStream(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return DashboardCard(
                          title: "Expired",
                          value: snapshot.data.toString(),
                          icon: Icons.cancel,
                          color: Colors.red,
                        );
                      },
                    )
                  ),

                  DashboardCard(
                    title: "Reports",
                    value: expiringMembers.toString(),
                    icon: Icons.report,
                    color: Colors.blueAccent,
                  ),


                  DashboardCard(
                    title: "Attendance",
                    value: "89",
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentsHomePage(),
                        ),
                      );
                    },
                    child: DashboardCard(
                      title: "Payments",
                      value: "",
                      icon: Icons.payments,
                      color: Colors.orange,
                    ),
                  ),



                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
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