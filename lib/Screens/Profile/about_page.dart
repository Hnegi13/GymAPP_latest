import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'lib/assets/images/app_logo.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Gym Manager Pro",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [

                    Text(
                      "About",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Gym Manager Pro is designed to help gym owners efficiently manage members, attendance, payments and memberships through a simple and intuitive interface.",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [

                    Text(
                      "Features",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    ListTile(
                      dense: true,
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Member Management"),
                    ),

                    ListTile(
                      dense: true,
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Attendance Tracking"),
                    ),

                    ListTile(
                      dense: true,
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Payment Management"),
                    ),

                    ListTile(
                      dense: true,
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Membership Plans"),
                    ),

                    ListTile(
                      dense: true,
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Dashboard Analytics"),
                    ),

                    ListTile(
                      dense: true,
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Expiry Notifications"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Developed By",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Himanshu Negi",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            Text(
              "© 2026 Gym Manager Pro\nAll Rights Reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}