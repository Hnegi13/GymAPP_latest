import 'package:flutter/material.dart';

import '../common_banner.dart';

class AnnouncementBanner extends StatelessWidget {

  const AnnouncementBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return CommonBanner(

      statusIcon: Icons.campaign_outlined,

      statusIconColor: Colors.blue,
      backgroundColor: Colors.blue.shade50,
      borderColor: Colors.blue.shade200,
      title: "Announcement",
      subtitle: "Stay updated with the latest Gym Manager Pro news",
      buttonText: "View",

      onPressed: () {
        // Announcement action will be implemented later
      },

    );

  }

}