import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/gym_service.dart';
import '../../utils/app_constants.dart';

class SuggestFeaturePage extends StatefulWidget {
  const SuggestFeaturePage({super.key});

  @override
  State<SuggestFeaturePage> createState() => _SuggestFeaturePageState();
}

class _SuggestFeaturePageState extends State<SuggestFeaturePage> {
  final GymService gymService = GymService();

  final titleController = TextEditingController();

  final descriptionController =
  TextEditingController();

  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Suggest a Feature"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              "Have an idea?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "We'd love to hear your suggestions to improve Gym Manager Pro.",
            ),

            const SizedBox(height: 28),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Feature Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: descriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Describe your idea",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: isSubmitting
                    ? null
                    : submitFeature,

                child: Text(
                  isSubmitting
                      ? "Submitting..."
                      : "Submit",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitFeature() async {

    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields."),
        ),
      );

      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {

      final uid = FirebaseAuth.instance.currentUser!.uid;

      final gym = await gymService.getGym(uid);

      await FirebaseFirestore.instance
          .collection("feature_requests")
          .add({

        "uid": uid,

        "gymId": uid,

        "gymName": gym?.gymName ?? "",

        "ownerName": gym?.ownerName ?? "",

        "title": titleController.text.trim(),

        "description": descriptionController.text.trim(),

        "createdAt": FieldValue.serverTimestamp(),

        "status": "NEW",

      });
//Send via email as well

      // await sendFeatureEmail(
      //   gymName: gym?.gymName ?? "",
      //   ownerName: gym?.ownerName ?? "",
      // );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Feature request submitted successfully.",
          ),
        ),
      );

      titleController.clear();
      descriptionController.clear();

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          isSubmitting = false;
        });

      }
    }
  }

  Future<void> sendFeatureEmail({
    required String gymName,
    required String ownerName,
  }) async {

    final subject = Uri.encodeComponent(
        "Feature Request - ${titleController.text.trim()}");

    final body = Uri.encodeComponent('''
            Gym Name: $gymName
           Owner:$ownerName
        Feature Title:${titleController.text.trim()}
       Description:${descriptionController.text.trim()}
        App Version:${AppConstants.appVersion}
     ''');

    final uri = Uri.parse(
        "mailto:${AppConstants.featureRequestEmail}?subject=$subject&body=$body");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

}