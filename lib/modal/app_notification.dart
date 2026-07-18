enum NotificationType {
  subscription,
  member,
}

enum NotificationPriority {
  low,
  medium,
  high,
}

class AppNotification {
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime date;
  final bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.date,
    this.isRead = false,
  });
}