import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/app_constants.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Contact Us"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              "Need help?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "We're here to help you with any questions, technical issues or business enquiries.",
            ),

            const SizedBox(height: 30),

            buildContactCard(),

            const SizedBox(height: 30),

            buildActionButtons(),

          ],
        ),
      ),
    );
  }


  // Reusable Contact Card

  Widget buildContactCard() {

    return Card(

      elevation: 1,

      child: Padding(

        padding: const EdgeInsets.all(18),

        child: Column(

          children: [

            buildRow(
              Icons.email_outlined,
              "Email",
              AppConstants.supportEmail,
            ),

            const Divider(),

            buildRow(
              Icons.phone_outlined,
              "WhatsApp",
              AppConstants.supportPhone,
            ),

            const Divider(),

            buildRow(
              Icons.access_time,
              "Business Hours",
              AppConstants.businessHours,

              // "Mon - Sat\n9:00 AM - 7:00 PM",
            ),

          ],
        ),
      ),
    );
  }

  //Reusable Row

  Widget buildRow(
      IconData icon,
      String title,
      String value,
      ) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(icon),

          const SizedBox(width: 15),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(value),

              ],
            ),
          ),
        ],
      ),
    );
  }

//Action Buttons

  Widget buildActionButtons() {

    return Column(

      children: [

        SizedBox(

          width: double.infinity,

          child: ElevatedButton.icon(

            icon: const Icon(Icons.email_outlined),

            label: const Text(
              "Contact via Email",
            ),

            onPressed: contactViaEmail,
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(

          width: double.infinity,

          child: OutlinedButton.icon(

            icon: const Icon(Icons.chat),

            label: const Text(
              "Chat on WhatsApp",
            ),

            onPressed: contactViaWhatsApp,
          ),
        ),
      ],
    );
  }

  //Email Method

  Future<void> contactViaEmail() async {
    final subject = Uri.encodeComponent(
      "Gym Manager Pro Support",
    );

    final body = Uri.encodeComponent('''
Hello Gym Manager Pro Team,

App Version: ${AppConstants.appVersion}

I need assistance regarding:





Regards,
''');

    final Uri emailUri = Uri.parse(
      "mailto:${AppConstants.supportEmail}?subject=$subject&body=$body",
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No email application found.",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to open email app.\n$e",
          ),
        ),
      );
    }
  }

  //WhatsApp Method

  Future<void> contactViaWhatsApp() async {

    final message = Uri.encodeComponent(
        "Hello Gym Manager Pro Team,\n\nI need assistance regarding:\n");

    final Uri whatsappUri = Uri.parse(
        "https://wa.me/${AppConstants.supportPhone.replaceAll("+", "")}?text=$message");

    if (await canLaunchUrl(whatsappUri)) {

      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );

    } else {

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(

            content: Text(
              "WhatsApp is not installed.",
            ),

          ),
        );
      }
    }
  }

}