import '../utils/app_constants.dart';
import 'subscription_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SubscriptionStatus {
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

}