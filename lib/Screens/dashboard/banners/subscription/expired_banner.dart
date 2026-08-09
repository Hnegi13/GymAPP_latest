import 'package:flutter/material.dart';

import '../../../subscription_page.dart';
import '../common_banner.dart';


class ExpiredBanner extends StatelessWidget {

  const ExpiredBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return CommonBanner(

      statusIcon: Icons.cancel,

      statusIconColor: Colors.red,

      backgroundColor: Colors.red.shade50,

      borderColor: Colors.red.shade200,

      title: "Subscription Expired",

      subtitle: "Renew to continue premium features",

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