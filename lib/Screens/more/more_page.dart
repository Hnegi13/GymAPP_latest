import 'package:flutter/material.dart';

import '../../services/gym_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../profile/about_page.dart';
import '../profile/notification_page.dart';
import '../profile/privacy_policy_page.dart';
import '../profile/settings_page.dart';
import '../profile/terms_conditions_page.dart';

import '../../auth/auth_service.dart';
import '../../widgets/logout_dialog.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  String ownerName = "";
  String gymName = "";
  final GymService gymService = GymService();

  @override
  void initState() {
    super.initState();
    loadGymDetails();
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
  Widget build(BuildContext context) {
    final authService = AuthService();

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        centerTitle: true,
      ),

        body: SafeArea(
          child: ListView(
        children: [

          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person, size: 35),
                ),

                const SizedBox(height: 10),

                Text(
                  ownerName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  gymName,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 20),

              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text("Notifications"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationPage(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacyPolicyPage(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text("Terms & Conditions"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TermsConditionsPage(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutPage(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () async {

              final shouldLogout =
              await showLogoutDialog(context);

              if (shouldLogout == true) {
                await authService.signOut();
              }

            },
          ),

        ],
      ),
        ),
    );
  }


}