import '../modal/app_notification.dart';
import 'subscription_service.dart';
import 'firestore_service.dart';

class NotificationService {
  final SubscriptionService subscriptionService = SubscriptionService();
  final FirestoreService firestoreService = FirestoreService();

  //Owner subscription Notification

  Future<List<AppNotification>> getSubscriptionNotifications() async {

    final List<AppNotification> notifications = [];

    final subscription =
    await subscriptionService.getSubscription();

    if (subscription == null) {
      return notifications;
    }

    final DateTime endDate =
    subscription["endDate"].toDate();

    final now = DateTime.now();

    final difference =
        endDate.difference(now).inDays;

    if (difference == 7) {

      notifications.add(
        AppNotification(
          title: "Subscription Reminder",
          message:
          "Your Gym Manager Pro subscription expires in 7 days.",
          type: NotificationType.subscription,
          priority: NotificationPriority.low,
          date: now,
        ),
      );
    }

    if (difference == 3) {

      notifications.add(
        AppNotification(
          title: "Subscription Reminder",
          message:
          "Your Gym Manager Pro subscription expires in 3 days.",
          type: NotificationType.subscription,
          priority: NotificationPriority.medium,
          date: now,
        ),
      );
    }

    if (difference == 1) {

      notifications.add(
        AppNotification(
          title: "Subscription Reminder",
          message:
          "Your Gym Manager Pro subscription expires tomorrow.",
          type: NotificationType.subscription,
          priority: NotificationPriority.high,
          date: now,
        ),
      );
    }

    if (difference == 0) {

      notifications.add(
        AppNotification(
          title: "Subscription Expiring Today",
          message:
          "Your subscription expires today. Renew to avoid interruption.",
          type: NotificationType.subscription,
          priority: NotificationPriority.high,
          date: now,
        ),
      );
    }

    if (difference < 0) {
      notifications.add(
        AppNotification(
          title: "Subscription Expired",
          message:
          "Your Gym Manager Pro subscription has expired. Renew to continue using premium features.",
          type: NotificationType.subscription,
          priority: NotificationPriority.high,
          date: now,
        ),
      );
    }

    return notifications;
  }

  //Member Notification

  Future<List<AppNotification>> getMemberNotifications() async {

    final List<AppNotification> notifications = [];

    final expiringMembers =
    await firestoreService.getExpiringMembers();

    final expiredMembers =
    await firestoreService.getExpiredMembers();

    if (expiringMembers.isNotEmpty) {

      notifications.add(
        AppNotification(
          title: "Membership Expiring",
          message:
          "${expiringMembers.length} member(s) have memberships expiring soon.",
          type: NotificationType.member,
          priority: NotificationPriority.medium,
          date: DateTime.now(),
        ),
      );
    }

    if (expiredMembers.isNotEmpty) {

      notifications.add(
        AppNotification(
          title: "Membership Expired",
          message:
          "${expiredMembers.length} member(s) have expired memberships.",
          type: NotificationType.member,
          priority: NotificationPriority.high,
          date: DateTime.now(),
        ),
      );
    }

    return notifications;
  }

  //Merge Both Notification

  Future<List<AppNotification>> getAllNotifications() async {

    final List<AppNotification> notifications = [];

    notifications.addAll(
      await getSubscriptionNotifications(),
    );

    notifications.addAll(
      await getMemberNotifications(),
    );

    notifications.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return notifications;
  }


}