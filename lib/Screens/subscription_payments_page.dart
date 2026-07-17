import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import '../services/payment_history_service.dart';
import '../modal/payment.dart';
import 'payment_history_page.dart';

class SubscriptionPaymentsPage extends StatefulWidget {
  const SubscriptionPaymentsPage({super.key});

  @override
  State<SubscriptionPaymentsPage> createState() =>
      _SubscriptionPaymentsPageState();
}

class _SubscriptionPaymentsPageState extends State<SubscriptionPaymentsPage> {

  final SubscriptionService subscriptionService = SubscriptionService();
  final PaymentHistoryService paymentHistoryService = PaymentHistoryService();

  List<Payment> recentPayments = [];

  //date
  String formatDate(dynamic timestamp) {

    if (timestamp == null) return "";

    final date = timestamp.toDate();

    return "${date.day}/${date.month}/${date.year}";
  }

  String formatPaymentDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  //days remaining
  int daysRemaining(dynamic timestamp) {

    if (timestamp == null) return 0;

    final endDate = timestamp.toDate();

    return endDate.difference(DateTime.now()).inDays;
  }

  Map<String, dynamic>? subscription;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Later:
    // Load subscription
    loadSubscription();
    // Load last 5 payments
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Subscription Payments"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ): SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            //-----------------------------------------
            // Current Subscription
            //-----------------------------------------

            const Text(
              "Current Subscription",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                     Row(
                      children: [

                        Icon(
                          Icons.workspace_premium,
                          color: Colors.amber,
                          size: 32,
                        ),

                        SizedBox(width: 10),

                        Text(
                          subscription?["plan"] ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Status : ${subscription?["isActive"] == true ? "ACTIVE" : "EXPIRED"}",
                      style: TextStyle(
                        color: subscription?["isActive"] == true
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Expires On : ${formatDate(subscription?["endDate"])}",
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Expires in : ${daysRemaining(subscription?["endDate"])} Days",
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            //-----------------------------------------
            // Recent Payments
            //-----------------------------------------

            const Text(
              "Recent Payments",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentPayments.length,
              itemBuilder: (context, index) {

                final payment = recentPayments[index];

                return Card(
                  child: ListTile(

                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),

                    title: Text(
                      "₹${payment.amount.toStringAsFixed(0)}",
                    ),

                    subtitle: Text(
                      "${formatPaymentDate(payment.paymentDate)}\n${payment.paymentMethod}",
                    ),

                    trailing: Text(
                      payment.paymentStatus,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Center(
              child: TextButton.icon(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const PaymentHistoryPage(),
                    ),
                  );

                },

                icon: const Icon(Icons.history),

                label: const Text(
                  "View Full Payment History",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> loadSubscription() async {

    subscription = await subscriptionService.getSubscription();
    recentPayments = await paymentHistoryService.getLastFivePayments();

    setState(() {
      isLoading = false;
    });
  }
}