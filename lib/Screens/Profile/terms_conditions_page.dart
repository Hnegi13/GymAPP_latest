import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: const Center(
        child: Text(
          "Terms & Conditions will be added here.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}