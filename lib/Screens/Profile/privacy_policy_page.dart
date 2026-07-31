import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildSection(
              "Introduction",
              "Gym Manager Pro respects your privacy. This Privacy Policy explains how we collect, use, and protect the information you provide while using our application.",
            ),

            _buildSection(
              "Information We Collect",
              "• Gym information\n"
                  "• Member details\n"
                  "• Attendance records\n"
                  "• Payment information\n"
                  "• Subscription details",
            ),

            _buildSection(
              "How We Use Your Information",
              "Your information is used only to manage gym memberships, attendance, payments, notifications, and improve the overall experience of the application.",
            ),

            _buildSection(
              "Data Security",
              "Your data is securely stored using Firebase services. We implement industry-standard security practices to protect your information from unauthorized access.",
            ),

            _buildSection(
              "Third-Party Services",
              "Gym Manager Pro uses trusted third-party services such as Firebase Authentication, Cloud Firestore, and Razorpay (for payment processing).",
            ),

            _buildSection(
              "Your Rights",
              "You may request to update or delete your information at any time. You also have the right to stop using the application whenever you choose.",
            ),

            _buildSection(
              "Contact Us",
              "For questions regarding this Privacy Policy, please contact the Gym Manager Pro support team.",
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