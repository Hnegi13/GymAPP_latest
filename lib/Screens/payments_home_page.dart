import 'package:flutter/material.dart';
import 'subscription_payments_page.dart';

class PaymentsHomePage extends StatefulWidget {
  const PaymentsHomePage({super.key});

  @override
  State<PaymentsHomePage> createState() => _PaymentsHomePageState();
}

class _PaymentsHomePageState extends State<PaymentsHomePage> {
  @override
  void initState() {
    super.initState();

    // Future:
    // Load subscription details
    // Load latest payments
    // Load payment statistics
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Payments"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Payment Center",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Manage your Gym Manager Pro subscription and member payments from one place.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                leading: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                  ),
                ),

                title: const Text(
                  "Subscription Payments",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "View your Gym Manager Pro subscription payments and payment history.",
                  ),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SubscriptionPaymentsPage(),
                    ),
                  );

                  // Open Subscription Payments Page

                },
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                leading: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                ),

                title: const Text(
                  "Member Payments",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Track membership fees collected from your gym members.",
                  ),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),

                onTap: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Member Payments module coming soon.",
                      ),
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}