import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';
import '../../services/razor_payment_link_service.dart';

class PaymentOptionsPage extends StatelessWidget {
  final String plan;
  final double amount;
  static  final RazorPaymentLinkService paymentLinkService = RazorPaymentLinkService();


  const PaymentOptionsPage({
    super.key,
    required this.plan,
    required this.amount,
  });



  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Choose Payment Method"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Your Selected Plan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    Text(
                      plan,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "₹${amount.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Choose Payment Method",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.all(18),

                leading: const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.payment,
                    color: Colors.white,
                  ),
                ),

                title: const Text(
                  "Razorpay",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Pay securely using Razorpay",
                  ),
                ),

                trailing: ElevatedButton(
                  onPressed: () async {
                    // Payment Link will be connected here.

                    final opened = await paymentLinkService.openPaymentLink(
                      AppConstants.razorpayMonthlyPaymentLink,
                    );

                    if (!opened && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Unable to open Razorpay payment page."),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Continue"),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                "Your payment is processed securely.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}