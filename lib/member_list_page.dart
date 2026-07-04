import 'package:flutter/material.dart';
import 'add_member_page.dart';
import 'member.dart';
import 'member_details_page.dart';
import 'services/firestore_service.dart';

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