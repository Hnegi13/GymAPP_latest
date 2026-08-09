
import 'package:flutter/material.dart';

import '../Screens/subscription_page.dart';
import '../utils/app_constants.dart';
import 'subscription_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SubscriptionStatus {
  trial,
  active,
  gracePeriod,
  restricted,
}

class SubscriptionGuardService {

  final SubscriptionService _subscriptionService = SubscriptionService();

  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final subscription = await _subscriptionService.getSubscription();

    if (subscription == null) {
      return SubscriptionStatus.restricted;
    }

    final today = DateTime.now();

    final endDate = (subscription["endDate"] as Timestamp).toDate();

    if (today.isBefore(endDate) ||
        today.isAtSameMomentAs(endDate)) {

      return SubscriptionStatus.active;
    }

    final difference = today.difference(endDate).inDays;

    if (difference <= AppConstants.subscriptionGraceDays) {

      return SubscriptionStatus.gracePeriod;

    }

    return SubscriptionStatus.restricted;

  }

  Future<bool> canAddMember() async {

    final status = await getSubscriptionStatus();

    return status == SubscriptionStatus.active;
  }

  Future<bool> canViewMemberDetails() async {

    final status = await getSubscriptionStatus();

    return status != SubscriptionStatus.restricted;
  }

  Future<bool> canEditMember() async {

    final status = await getSubscriptionStatus();

    return status != SubscriptionStatus.restricted;
  }

  Future<bool> canDeleteMember() async {

    final status = await getSubscriptionStatus();

    return status != SubscriptionStatus.restricted;
  }

  Future<bool> canOpenAttendance() async {

    final status = await getSubscriptionStatus();

    return status != SubscriptionStatus.restricted;
  }

  Future<bool> canOpenReports() async {

    final status = await getSubscriptionStatus();

    return status != SubscriptionStatus.restricted;
  }

  Future<bool> canOpenExpiredMembers() async {

    final status = await getSubscriptionStatus();

    return status != SubscriptionStatus.restricted;
  }

  Future<bool> canOpenExpiring() async {

    final status = await getSubscriptionStatus();

    return status != SubscriptionStatus.restricted;
  }


  static Future<bool> checkSubscriptionAccess(
      BuildContext context, {
        required String featureName,
      }) async {


    final status = await SubscriptionGuardService().getSubscriptionStatus();


    if (status == SubscriptionStatus.active) {
      return true;
    }

    final renew = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Subscription Required"),
          content: Text(
            "Renew your subscription to access $featureName.",
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

    return false;

  }

  static Future<bool> checkGracePeriodAccess(
      BuildContext context, {
        required String featureName,
      }) async {

    final status = await SubscriptionGuardService().getSubscriptionStatus();

    if (status == SubscriptionStatus.active ||
        status == SubscriptionStatus.gracePeriod) {
      return true;
    }

    final renew = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Account Restricted"),
          content: Text(
            "Your grace period has ended.\n\n"
                "Renew your subscription to access $featureName.",
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

    return false;

  }

  // add member button

  static Future<bool> checkAddMemberAccess(
      BuildContext context,
      ) async {

    final status = await SubscriptionGuardService().getSubscriptionStatus();

    if (status == SubscriptionStatus.active) {
      return true;
    }

    if (status == SubscriptionStatus.gracePeriod) {

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

      if (renew == true) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SubscriptionPage(),
          ),
        );

      }

      return false;
    }

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

    if (renew == true) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SubscriptionPage(),
        ),
      );

    }

    return false;

  }





}