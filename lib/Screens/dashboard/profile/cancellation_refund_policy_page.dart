import 'package:flutter/material.dart';

class CancellationRefundPolicyPage extends StatelessWidget {
  const CancellationRefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cancellation & Refund Policy"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Cancellation & Refund Policy",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Subscription Cancellation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "You may choose not to continue your Gym Manager Pro "
                    "subscription. Cancellation will prevent future renewal, "
                    "while access to the service may continue until the end "
                    "of the applicable subscription period.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Refunds",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Subscription payments are generally non-refundable "
                    "after activation. However, refund requests may be "
                    "considered by the Gym Manager Pro team on a case-by-case "
                    "basis, depending on the circumstances of the request.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Refund Decision",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Any refund, if approved, will be at the sole discretion "
                    "of Gym Manager Pro, including the amount and method of "
                    "refund, subject to applicable laws and regulations.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Payment Issues",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "If you believe that you have been charged incorrectly, "
                    "charged more than once, or experienced a payment-related "
                    "issue, you may contact our support team. We will review "
                    "the transaction and determine the appropriate resolution.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "No Automatic Refunds",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Submitting a refund request does not guarantee that a "
                    "refund will be issued. Refund eligibility and the final "
                    "resolution will be determined after reviewing the "
                    "individual case.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Changes to this Policy",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Gym Manager Pro reserves the right to modify this policy "
                    "from time to time. The updated policy will be made "
                    "available through the application.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "For cancellation, payment, or refund-related queries, "
                    "please contact Gym Manager Pro support.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}