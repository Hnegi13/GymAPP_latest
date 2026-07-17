import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_constants.dart';

class SubscriptionService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> canAddMember() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Gym document
    final gymDoc = await _firestore
        .collection("gyms")
        .doc(uid)
        .get();

    final subscription = gymDoc.data()?['subscription'];
    bool isActive = subscription['isActive'];

    if (!isActive) {
      return false;
    }

    int memberLimit = subscription['memberLimit'];

    // Unlimited Plan
    if (memberLimit == -1) {
      return true;
    }

    // Current Members
    final members = await _firestore
        .collection("gyms")
        .doc(uid)
        .collection("members")
        .get();

    return members.docs.length < memberLimit;
  }

  Future<void> activateMonthlyPlan() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final now = DateTime.now();

    final endDate = DateTime(
      now.year,
      now.month + 1,
      now.day,
    );

    await _firestore
        .collection("gyms")
        .doc(uid)
        .update({

      "subscription.plan": AppConstants.monthlyPlan,

      "subscription.memberLimit": AppConstants.unlimitedMembers,

      "subscription.isActive": true,

      "subscription.amountPaid": AppConstants.monthlyPrice,

      "subscription.paymentStatus": AppConstants.paymentPaid,

      "subscription.startDate": now,

      "subscription.endDate": endDate,
    });

  }

  Future<void> activateYearlyPlan() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final now = DateTime.now();

    final endDate = DateTime(
      now.year + 1,
      now.month,
      now.day,
    );

    await _firestore
        .collection("gyms")
        .doc(uid)
        .update({

      "subscription.plan": AppConstants.yearlyPlan,

      "subscription.memberLimit": -1,

      "subscription.isActive": true,

      "subscription.amountPaid":
      AppConstants.yearlyPrice,

      "subscription.paymentStatus":
      AppConstants.paymentPaid,

      "subscription.startDate": now,

      "subscription.endDate": endDate,
    });

  }
  Future<Map<String, dynamic>?> getSubscription() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await _firestore
        .collection("gyms")
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    return doc.data()?["subscription"];
  }

}