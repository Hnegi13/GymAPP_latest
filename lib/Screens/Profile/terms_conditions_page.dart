import 'package:flutter/material.dart';

class TermsConditionsPage extends StatefulWidget {
  const TermsConditionsPage({super.key});

  @override
  State<TermsConditionsPage> createState() =>
      _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildSection(
              "Acceptance of Terms",
              "By using Gym Manager Pro, you agree to these Terms & Conditions. If you do not agree, please discontinue using the application.",
            ),
            _buildSection(
              "Use of the Application",
              "Gym Manager Pro is intended for gym owners and authorized staff to manage memberships, attendance, payments, and subscriptions.",
            ),
            _buildSection(
              "User Responsibilities",
              "You are responsible for maintaining accurate member information, protecting your account credentials, and ensuring that your use of the application complies with applicable laws.",
            ),
            _buildSection(
              "Payments & Subscription",
              "Subscription fees are charged according to the selected plan. Payments processed through integrated payment gateways are subject to their respective terms and policies.",
            ),
            _buildSection(
              "Limitation of Liability",
              "Gym Manager Pro is provided 'as is'. While we strive to provide a reliable service, we are not liable for any indirect, incidental, or consequential damages arising from the use of the application.",
            ),
            _buildSection(
              "Changes to the Terms",
              "We reserve the right to update these Terms & Conditions at any time. Continued use of the application after changes indicates your acceptance of the revised terms.",
            ),
            _buildSection(
              "Contact Us",
              "For any questions regarding these Terms & Conditions, please contact the Gym Manager Pro support team.",
            ),
            const SizedBox(height: 20),

            Center(
              child: Text(
                "Last Updated: July 2026",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title,
      String content,
      ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),

          ],
        ),
      ),
    );
  }
}