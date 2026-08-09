import 'package:flutter/material.dart';

import '../common_banner.dart';

class OfferBanner extends StatelessWidget {

  const OfferBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return CommonBanner(

      statusIcon: Icons.local_offer_outlined,
      statusIconColor: Colors.deepPurple,
      backgroundColor: Colors.deepPurple.shade50,
      borderColor: Colors.deepPurple.shade200,
      title: "Special Offer",
      subtitle: "Get more with Gym Manager Pro",
      buttonText: "View",
      onPressed: () {
        // Offer action will be implemented later
      },

    );

  }

}