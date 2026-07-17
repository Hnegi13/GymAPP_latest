import 'package:flutter/material.dart';
import '../modal/member.dart';
import 'add_member_page.dart';
import '../services/firestore_service.dart';
import 'renew_membership_page.dart';

class MemberDetailsPage extends StatefulWidget {
  final Member member;

  const MemberDetailsPage({
    super.key,
    required this.member,
  });

  @override
  State<MemberDetailsPage> createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  final FirestoreService firestoreService = FirestoreService();
  late Member member;

  @override
  void initState() {
    super.initState();
    member = widget.member;
  }

  Future<void> refreshMember() async {

    final updatedMember =
    await firestoreService.getMemberById(member.id!);

    if (updatedMember != null) {
      setState(() {
        member = updatedMember;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("MemberDetailsPage ID = ${member.id}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member Details"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddMemberPage(
                    member: member,
                  ),
                ),
              );
              await refreshMember();
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete),
    onPressed: () async {
    bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
    return AlertDialog(
    title: const Text("Delete Member"),
    content: const Text(
    "Are you sure you want to delete this member?",
    ),
    actions: [
    TextButton(
    onPressed: () => Navigator.pop(context, false),
    child: const Text("Cancel"),
    ),
    TextButton(
    onPressed: () => Navigator.pop(context, true),
    child: const Text("Delete"),
    ),
    ],
    );
    },
    );

    if (confirm == true) {
    final firestoreService = FirestoreService();

    await firestoreService.deleteMember(member.id!);

    Navigator.pop(context);
    }

            },
          ),
        ],
      ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
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
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Start Date"),
              subtitle: Text(
                "${member.startDate.day}/${member.startDate.month}/${member.startDate.year}",
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("End Date"),
              subtitle: Text(
                "${member.endDate.day}/${member.endDate.month}/${member.endDate.year}",
              ),
            ),
            ListTile(
              leading: Icon(
                member.isActive ? Icons.check_circle : Icons.cancel,
                color: member.isActive ? Colors.green : Colors.red,
              ),
              title: const Text("Status"),
              subtitle: Text(
                member.isActive ? "Active" : "Inactive",
              ),
            ),

                const SizedBox(height: 30),

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

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RenewMembershipPage(
                            member: member,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      "Renew Membership",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

          ],
        ),
          ),
      ),
    );
  }
}