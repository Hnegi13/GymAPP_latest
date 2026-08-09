import 'package:flutter/material.dart';

import '../common_banner.dart';

class MaintenanceBanner extends StatelessWidget {

  const MaintenanceBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return CommonBanner(

      statusIcon: Icons.build_circle_outlined,
      statusIconColor: Colors.orange,
      backgroundColor: Colors.orange.shade50,
      borderColor: Colors.orange.shade200,
      title: "Scheduled Maintenance",
      subtitle: "Few services temporarily unavailable",
      buttonText: "Details",

      onPressed: () {
        // Maintenance details will be implemented later
      },

    );

  }

}