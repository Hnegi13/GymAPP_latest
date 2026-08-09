import 'package:flutter/material.dart';

import '../../../subscription_page.dart';
import '../common_banner.dart';


class TrialBanner extends StatelessWidget {

  final int daysRemaining;

  const TrialBanner({

    super.key,

    required this.daysRemaining,

  });

  @override
  Widget build(BuildContext context) {

    final int daysLeft =
    daysRemaining < 0 ? 0 : daysRemaining;

    return CommonBanner(

      statusIcon: Icons.stars,

      statusIconColor: Colors.amber,

      backgroundColor: Colors.deepPurple.shade50,

      borderColor: Colors.deepPurple.shade200,

      title: "Free Trial",

      subtitle: daysLeft == 1
          ? "1 Day Remaining"
          : "$daysLeft Days Remaining",

      buttonText: "Upgrade",

      onPressed: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
            const SubscriptionPage(),

          ),

        );

      },

    );

  }

}