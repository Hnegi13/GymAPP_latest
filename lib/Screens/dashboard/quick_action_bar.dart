import 'package:flutter/material.dart';

import '../../services/subscription_guard_service.dart';
import '../Profile/notification_page.dart';
import '../add_member_page.dart';
import '../subscription_page.dart';
import 'quick_action_card.dart';

class QuickActionBar extends StatelessWidget {
  const QuickActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [

              QuickActionCard(
                icon: Icons.person_add_alt_1,
                title: "Add Member",
                color: Colors.blue,
                onTap: () async {

                  final allowed =
                  await SubscriptionGuardService.checkAddMemberAccess(
                    context,
                  );

                  if (!allowed) {
                    return;
                  }

                  if (!context.mounted) return;

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddMemberPage(),
                    ),
                  );
                },
              ),

              QuickActionCard(
                icon: Icons.workspace_premium,
                title: "Subscription",
                color: Colors.deepPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SubscriptionPage(),
                    ),
                  );
                },
              ),

              QuickActionCard(
                icon: Icons.notifications_active,
                title: "Notifications",
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}