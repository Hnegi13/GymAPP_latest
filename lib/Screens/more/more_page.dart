import 'package:flutter/material.dart';
import 'package:gym_app/Screens/more/rate_app_page.dart';
import 'package:gym_app/Screens/more/suggest_feature_page.dart';

import '../../utils/app_constants.dart';
import 'bulk_messaging_page.dart';
import 'contact_us_page.dart';
import 'export_members_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {

  @override
  void initState() {
    super.initState();

    // Future initialization
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("More"),
        centerTitle: true,
      ),

      body: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 6),

                Text(
                  "Business Tools & Support",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          buildSectionTitle("Business Tools"),

          buildMoreTile(
            icon: Icons.campaign_outlined,
            title: "Bulk Messaging",
            subtitle: "Coming Soon",
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const BulkMessagingPage(),

              ),
            );},
          ),


          buildMoreTile(
            icon: Icons.file_download_outlined,
            title: "Export Members",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExportMembersPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          buildSectionTitle("Support"),

          buildMoreTile(
            icon: Icons.support_agent_outlined,
            title: "Contact Us",
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (_) => const ContactUsPage(),
                ),
              );
            },
          ),

          buildMoreTile(
            icon: Icons.star_outline,
            title: "Rate App",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RateAppPage(),
                ),
              );
            },
          ),

          buildMoreTile(
            icon: Icons.lightbulb_outline,
            title: "Suggest a Feature",
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const SuggestFeaturePage(),
                ),
              );

            },
          ),

          const Divider(height: 28),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(
                "Gym Manager Pro\nVersion ${AppConstants.appVersion}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          letterSpacing: 1,
        ),
      ),
    );
  }


  Widget buildMoreTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [

        ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),

          leading: Icon(
            icon,
            size: 22,
          ),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),

          trailing: Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey.shade400,
          ),

          onTap: onTap,
        ),

        Divider(
          height: 1,
          indent: 56,
          endIndent: 16,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }
}