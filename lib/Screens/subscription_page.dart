import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import '../utils/app_constants.dart';
import '../services/payment_service.dart';
import '../services/payment_history_service.dart';
import '../modal/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final SubscriptionService subscriptionService = SubscriptionService();
  final PaymentService paymentService = PaymentService();
  final PaymentHistoryService paymentHistoryService = PaymentHistoryService();

  Future<void> upgradeToMonthly() async {}

  Future<void> upgradeToYearly() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Unlock Gym Manager Pro"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Center(
              child: Icon(
                Icons.workspace_premium,
                size: 80,
                color: Colors.amber,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Manage Smarter. Grow Faster.",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "We don't just simplify your daily gym operations.\n\n"
                  "Our mission is to become your business growth partner.\n\n"
                  "Along with member management, we will continuously introduce tools, "
                  "reports and business guidance to help you grow your gym.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Everything included in Pro",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            featureTile(Icons.people, "Unlimited Members"),
            featureTile(Icons.check_circle, "Attendance Tracking"),
            featureTile(Icons.payments, "Payment Records"),
            featureTile(Icons.sms, "SMS Reminders"),
            featureTile(Icons.message, "WhatsApp Integration"),
            featureTile(Icons.bar_chart, "Reports & Analytics"),
            featureTile(Icons.auto_graph, "Business Growth Insights"),
            featureTile(Icons.smart_toy, "Future AI Business Advisor"),

            const SizedBox(height: 30),

            const Text(
              "Choose Your Plan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            buildPlanCard(
              title: "Monthly",
              price: "₹249",
              oldPrice: "₹499",
              savings: "Save ₹250",
              buttonText: "Upgrade",
              highlight: false,
              onPressed: () async {

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Upgrade to Monthly Plan"),

                      content: Text(
                        "This will activate the Monthly Plan for ₹${AppConstants.monthlyPrice}.\n\n"
                            "Payment is being simulated for now.",
                      ),

                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Continue"),
                        ),
                      ],
                    );
                  },
                );

                if (confirm != true) return;

                paymentService.openCheckout(
                  name: "Gym Manager Pro",
                  description: "Monthly Subscription",
                  amount: AppConstants.monthlyPrice,
                  email: "YOUR_EMAIL",
                  contact: "YOUR_PHONE_NUMBER",

                    onSuccess: (paymentId) async {

                      final now = DateTime.now();
                      final receiptNumber = await paymentHistoryService.generateReceiptNumber();

                      final payment = Payment(
                        paymentId: paymentId,
                        receiptNumber: receiptNumber,
                        plan: AppConstants.monthlyPlan,
                        amount: AppConstants.monthlyPrice,
                        paymentMethod: "UPI",
                        paymentStatus: AppConstants.paymentPaid,
                        paymentDate: now,
                        startDate: now,
                        endDate: DateTime(
                          now.year,
                          now.month + 1,
                          now.day,
                        ),
                        transactionType: "NEW",
                      );

                      await paymentHistoryService.savePayment(payment);

                      await subscriptionService.activateMonthlyPlan();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Monthly Subscription Activated Successfully!",
                          ),
                        ),
                      );

                      Navigator.pop(context);
                    },

                  onFailure: (message) {

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            buildPlanCard(
              title: "Yearly ⭐",
              price: "₹1899",
              oldPrice: "₹5000",
              savings: "Save ₹3101",
              buttonText: "Upgrade",
              highlight: true,
              onPressed: () async {

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Upgrade to Yearly Plan"),

                      content: Text(
                        "This will activate the Yearly Plan for ₹${AppConstants.yearlyPlan}.\n\n"
                            "Payment is being simulated for now.",
                      ),

                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Continue"),
                        ),
                      ],
                    );
                  },
                );

                if (confirm != true) return;

                await subscriptionService.activateYearlyPlan();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Yearly Subscription Activated Successfully!",
                    ),
                  ),
                );

                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "Need help?\nContact us anytime.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }

  Widget featureTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.deepPurple,
      ),
      title: Text(text),
    );
  }

  Widget buildPlanCard({
    required String title,
    required String price,
    required String oldPrice,
    required String savings,
    required String buttonText,
    required bool highlight,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: highlight ? 8 : 3,
      color: highlight ? Colors.deepPurple.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              price,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              oldPrice,
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              savings,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}