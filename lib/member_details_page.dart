import 'package:flutter/material.dart';
import 'member.dart';

class MemberDetailsPage extends StatelessWidget {
  final Member member;

  const MemberDetailsPage({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member Details"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Center(
              child: CircleAvatar(
                radius: 45,
                child: Icon(
                  Icons.person,
                  size: 45,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              member.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 40),

            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(member.phone),
            ),

            ListTile(
              leading: const Icon(Icons.cake),
              title: Text(member.age),
            ),

            ListTile(
              leading: const Icon(Icons.card_membership),
              title: Text(member.plan),
            ),

            ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: Text(member.fee),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),

                child: const Text(
                  "Mark Attendance",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}