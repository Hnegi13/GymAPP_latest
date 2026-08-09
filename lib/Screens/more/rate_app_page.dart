import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class RateAppPage extends StatefulWidget {
  const RateAppPage({super.key});

  @override
  State<RateAppPage> createState() => _RateAppPageState();
}

class _RateAppPageState extends State<RateAppPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Rate App"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Enjoying Gym Manager Pro?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your rating helps us improve the app and reach more gym owners. We truly appreciate your support.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 35),

            Center(
              child: Icon(
                Icons.star_rate_rounded,
                color: Colors.amber,
                size: 90,
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: rateApp,

                child: const Text(
                  "Rate Gym Manager Pro",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> rateApp() async {

    final review = InAppReview.instance;

    try {

      if (await review.isAvailable()) {

        await review.requestReview();

      } else {

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(

            content: Text(
              "Rating will be available after the app is published on the Play Store.",
            ),

          ),
        );
      }

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            "Unable to open rating dialog.\n$e",
          ),

        ),
      );
    }
  }

}