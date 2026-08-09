import 'package:flutter/material.dart';

import '../../../subscription_page.dart';
import '../common_banner.dart';


class GracePeriodBanner extends StatelessWidget {

  final int daysRemaining;

  const GracePeriodBanner({
    super.key,
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {

    return CommonBanner(

      statusIcon: Icons.warning_amber_rounded,
      statusIconColor: Colors.orange,
      backgroundColor: Colors.orange.shade50,
      borderColor: Colors.orange.shade200,
      title: "Grace Period",
      subtitle: daysRemaining == 1
          ? "1 Day Remaining"
          : "$daysRemaining Days Remaining",

      buttonText: "Renew",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SubscriptionPage(),
          ),
        );

      },

    );

  }

}