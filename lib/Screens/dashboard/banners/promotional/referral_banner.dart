import 'package:flutter/material.dart';

import '../common_banner.dart';

class ReferralBanner extends StatelessWidget {

  const ReferralBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return CommonBanner(

      statusIcon: Icons.card_giftcard_outlined,
      statusIconColor: Colors.purple,
      backgroundColor: Colors.purple.shade50,
      borderColor: Colors.purple.shade200,
      title: "Refer & Earn",
      subtitle: "Refer a gym owner and earn extra subscription",
      buttonText: "Invite",
      onPressed: () {
        // Referral action will be implemented later
      },

    );

  }

}