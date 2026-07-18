import 'package:flutter/material.dart';
import 'add_member_page.dart';
import '../modal/member.dart';
import 'member_details_page.dart';
import '../services/firestore_service.dart';
import '../services/subscription_service.dart';
import 'subscription_page.dart';
import '../services/subscription_guard_service.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});



  @override
  State<MemberListPage> createState() => _MemberListPageState();
}
class _MemberListPageState extends State<MemberListPage> {


  final FirestoreService firestoreService = FirestoreService();
  final SubscriptionService subscriptionService = SubscriptionService();
  final SubscriptionGuardService subscriptionGuard = SubscriptionGuardService();

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

                  final status =
                  await subscriptionGuard.getSubscriptionStatus();

                  if (status == SubscriptionStatus.active ||
                      status == SubscriptionStatus.gracePeriod) {

                    if (!mounted) return;

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MemberDetailsPage(member: members[index]),
                      ),
                    );

                    return;
                  }

                  if (!mounted) return;

                  final renew = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Account Restricted"),
                        content: const Text(
                          "Your grace period has ended.\n\n"
                              "Renew your subscription to view member details.",
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
                            child: const Text("Renew Now"),
                          ),
                        ],
                      );
                    },
                  );

                  if (renew == true && mounted) {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionPage(),
                      ),
                    );

                  }

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
          final status = await subscriptionGuard.getSubscriptionStatus();
            if (status == SubscriptionStatus.active){

          final allowed = await subscriptionService.canAddMember();

          if (allowed) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddMemberPage(),
              ),
            );
            return;
          }
          }

            else if (status == SubscriptionStatus.gracePeriod) {

              final renew = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Subscription Expired"),
                    content: const Text(
                      "Your subscription has expired.\n\n"
                          "You are currently in the 3-day grace period.\n"
                          "Renew now to continue adding new members.",
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
                        child: const Text("Renew Now"),
                      ),
                    ],
                  );
                },
              );

              if (renew == true && mounted) {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubscriptionPage(),
                  ),
                );

              }

            }

            else {

              final renew = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Account Restricted"),
                    content: const Text(
                      "Your grace period has ended.\n\n"
                          "Renew your subscription to regain access to premium features.",
                    ),
                    actions: [

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("Exit"),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text("Renew Now"),
                      ),
                    ],
                  );
                },
              );

              if (renew == true && mounted) {

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