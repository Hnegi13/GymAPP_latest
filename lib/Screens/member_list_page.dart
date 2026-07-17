import 'package:flutter/material.dart';
import 'add_member_page.dart';
import '../modal/member.dart';
import 'member_details_page.dart';
import '../services/firestore_service.dart';
import '../services/subscription_service.dart';
import 'subscription_page.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});



  @override
  State<MemberListPage> createState() => _MemberListPageState();
}
class _MemberListPageState extends State<MemberListPage> {


  final FirestoreService firestoreService = FirestoreService();
  final SubscriptionService subscriptionService = SubscriptionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Member>>(
        stream: firestoreService.getMembers(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Members Added"),
            );
          }

          final members = snapshot.data!;

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),

                title: Text(members[index].name),

                subtitle: Text(members[index].plan),

                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MemberDetailsPage(
                        member: members[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {

          final allowed =
          await subscriptionService.canAddMember();

          if (allowed) {

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddMemberPage(),
              ),
            );

          } else {

            if (!mounted) return;

            final upgrade = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Free Plan Limit Reached"),

                  content: const Text(
                    "You've reached the limit of 5 members.\n\n"
                        "Upgrade to Gym Manager Pro to add unlimited members and unlock premium features.",
                  ),

                  actions: [

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("Later"),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("Upgrade"),
                    ),
                  ],
                );
              },
            );

            if (upgrade == true && mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SubscriptionPage(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}