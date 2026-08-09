import 'package:flutter/material.dart';

import '../common_banner.dart';

class ActivePlanBanner extends StatelessWidget {

  final String planName;

  final String validTill;

  const ActivePlanBanner({

    super.key,

    required this.planName,

    required this.validTill,

  });

  @override
  Widget build(BuildContext context) {

    return CommonBanner(

      statusIcon: Icons.verified,

      statusIconColor: Colors.green,

      backgroundColor: Colors.green.shade50,

      borderColor: Colors.green.shade200,

      title: planName,

      subtitle: "Valid till $validTill",

      buttonText: "Manage",

      onPressed: () {

        // TODO

      },

    );

  }

}