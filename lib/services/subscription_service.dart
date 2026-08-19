import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_constants.dart';


class SubscriptionPeriod {
  final DateTime startDate;
  final DateTime endDate;

  const SubscriptionPeriod({
    required this.startDate,
    required this.endDate,
  });
}


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

  Future<void> activateMonthlyPlan({
    required SubscriptionPeriod period,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection("gyms")
        .doc(uid)
        .update({
      "subscription.plan": AppConstants.monthlyPlan,
      "subscription.memberLimit": AppConstants.unlimitedMembers,
      "subscription.isActive": true,
      "subscription.amountPaid": AppConstants.monthlyPrice,
      "subscription.paymentStatus": AppConstants.paymentPaid,
      "subscription.endDate": period.endDate,
      "subscription.status": "active",
    });
  }

  Future<void> activateQuarterlyPlan({
    required SubscriptionPeriod period,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection("gyms")
        .doc(uid)
        .update({
      "subscription.plan": AppConstants.quarterlyPlan,
      "subscription.memberLimit": AppConstants.unlimitedMembers,
      "subscription.isActive": true,
      "subscription.amountPaid": AppConstants.quarterlyPrice,
      "subscription.paymentStatus": AppConstants.paymentPaid,
      "subscription.endDate": period.endDate,
      "subscription.status": "active",
    });
  }

  Future<void> activateHalfYearlyPlan({
    required SubscriptionPeriod period,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection("gyms")
        .doc(uid)
        .update({
      "subscription.plan": AppConstants.halfYearlyPlan,
      "subscription.memberLimit": AppConstants.unlimitedMembers,
      "subscription.isActive": true,
      "subscription.amountPaid": AppConstants.halfYearlyPrice,
      "subscription.paymentStatus": AppConstants.paymentPaid,
      "subscription.endDate": period.endDate,
      "subscription.status": "active",
    });
  }

  Future<void> activateYearlyPlan({
    required SubscriptionPeriod period,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection("gyms")
        .doc(uid)
        .update({
      "subscription.plan":
      AppConstants.yearlyPlan,
      "subscription.memberLimit": AppConstants.unlimitedMembers,
      "subscription.isActive": true,
      "subscription.amountPaid": AppConstants.yearlyPrice,
      "subscription.paymentStatus": AppConstants.paymentPaid,
      "subscription.endDate": period.endDate,
      "subscription.status": "active",
    });
  }

  Future<Map<String, dynamic>?> getSubscription() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await _firestore
        .collection("gyms")
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    final subscription =
    doc.data()?["subscription"];

    if (subscription == null) return null;

    // Automatic Migration
    if (!subscription.containsKey("status")) {

      await _updateSubscriptionStatus(uid, subscription);

      // Read again after update
      final updatedDoc = await _firestore
          .collection("gyms")
          .doc(uid)
          .get();

      return updatedDoc.data()?["subscription"];
    }

    return subscription;

  }


  //

  Future<void> _updateSubscriptionStatus(
      String uid,
      Map<String, dynamic> subscription,
      ) async {

    final today = DateTime.now();

    final endDate =
    (subscription["endDate"] as Timestamp).toDate();

    String status;

    if (today.isBefore(endDate) ||
        today.isAtSameMomentAs(endDate)) {

      status = "active";

    } else {

      final difference = today.difference(endDate).inDays;

      if (difference <= AppConstants.subscriptionGraceDays) {

        status = "gracePeriod";

      } else {

        status = "restricted";

      }

    }

    await _firestore
        .collection("gyms")
        .doc(uid)
        .update({

      "subscription.status": status,

    });

  }

  //helper for deciding end date issue(Usefull when someone upgrade plan before end date or before trial finishes)

  Future<DateTime> _getSubscriptionBaseDate() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final gymDoc = await _firestore
        .collection("gyms")
        .doc(uid)
        .get();

    final subscription = gymDoc.data()?["subscription"];

    final Timestamp? endTimestamp = subscription?["endDate"];

    final today = DateTime.now();

    if (endTimestamp == null) {
      return today;
    }

    final currentEndDate = endTimestamp.toDate();

    if (currentEndDate.isAfter(today)) {
      return currentEndDate;
    }

    return today;
  }

  Future<SubscriptionPeriod> getNextSubscriptionPeriod({
    required int durationMonths,
  }) async {
    final baseDate = await _getSubscriptionBaseDate();

    final endDate = DateTime(
      baseDate.year,
      baseDate.month + durationMonths,
      baseDate.day,
    );

    return SubscriptionPeriod(
      startDate: baseDate,
      endDate: endDate,
    );
  }

}