import 'package:flutter/material.dart';
import '../../modal/app_notification.dart';
import '../../services/notification_service.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() =>
      _NotificationPageState();
}

class _NotificationPageState
    extends State<NotificationPage> {

  final NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Notifications"),
      ),

      body: FutureBuilder<List<AppNotification>>(

        future: notificationService.getAllNotifications(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {

            return const Center(
              child: Text(
                "No notifications",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final notifications = snapshot.data!;

          return ListView.builder(

            itemCount: notifications.length,

            itemBuilder: (context, index) {

              final notification =
              notifications[index];

              return ListTile(

                leading: CircleAvatar(
                  backgroundColor:
                  notification.type ==
                      NotificationType.subscription
                      ? Colors.deepPurple
                      : Colors.orange,
                  child: Icon(
                    notification.type ==
                        NotificationType.subscription
                        ? Icons.workspace_premium
                        : Icons.notifications,
                    color: Colors.white,
                  ),
                ),

                title: Text(notification.title),

                subtitle: Text(notification.message),

                trailing: Text(
                  "${notification.date.day}/${notification.date.month}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}