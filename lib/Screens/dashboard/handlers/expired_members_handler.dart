import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_service.dart';
import '../../../services/subscription_guard_service.dart';
import '../../subscription_page.dart';
import '../../filtered_members_page.dart';
import '../../../modal/member.dart';
import 'expired_members_handler.dart';




class ExpiredMembersHandler {

  static final FirestoreService firestoreService = FirestoreService();
  static final SubscriptionGuardService subscriptionGuard = SubscriptionGuardService();

  static Future<void> execute(BuildContext context) async {
    final status = await subscriptionGuard.getSubscriptionStatus();

    // same subscription validation

    if (status != SubscriptionStatus.active) {


      final renew = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Subscription Expired"),
            content: const Text(
              "Renew your subscription to access the Expiring Members feature.",
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

      if (renew == true) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SubscriptionPage(),
          ),
        );

      }

      return;
    }
    final List<Member> members = await firestoreService.getExpiredMembers();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilteredMembersPage(
          title: 'Expired Members',
          members: members,
          isExpired: true,
        ),
      ),
    );



  }
}