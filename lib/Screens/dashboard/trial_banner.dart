import 'package:flutter/material.dart';
import '../subscription_page.dart';

class TrialBanner extends StatelessWidget {
  final int daysRemaining;

  const TrialBanner({
    super.key,
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final int daysLeft = daysRemaining < 0 ? 0 : daysRemaining;

    final bool isExpired = daysLeft == 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isExpired
            ? Colors.red.shade50
            : Colors.deepPurple.shade50,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: isExpired
              ? Colors.red.shade200
              : Colors.deepPurple.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(isExpired
                ? Icons.warning_amber_rounded
                : Icons.workspace_premium,
            color: isExpired
                ? Colors.red
                : Colors.deepPurple,
            size: 24,
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpired
                      ? "Trial Expired"
                      : "🎉 Free Trial",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isExpired
                        ? Colors.red
                        : Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  daysLeft == 0
                      ? "Trial Expired"
                      : daysLeft == 1
                      ? "1 Day Remaining"
                      : "$daysLeft Days Remaining",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(90, 36),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SubscriptionPage(),
                ),
              );
            },
            child: const Text("Upgrade"),
          ),
        ],
      ),
    );
  }
}