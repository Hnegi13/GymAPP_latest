import 'package:flutter/material.dart';
import 'add_member_page.dart';
import '../modal/member.dart';
import 'member_details_page.dart';
import '../services/firestore_service.dart';
import '../services/subscription_guard_service.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}
class _MemberListPageState extends State<MemberListPage> {


  final FirestoreService firestoreService = FirestoreService();


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

                onTap: () async {

                  if (!await SubscriptionGuardService.checkGracePeriodAccess(
                    context,
                    featureName: "Member Details",
                  )) {
                    return;
                  }

                  await Navigator.push(
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

      //Floating button '+'

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {

          final allowed =
          await SubscriptionGuardService.checkAddMemberAccess(
            context,
          );

          if (!allowed) {
            return;
          }

          if (!context.mounted) return;

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMemberPage(),
            ),
          );
        },
      ),
    );
  }
}