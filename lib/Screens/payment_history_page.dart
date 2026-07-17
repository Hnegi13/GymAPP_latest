import 'package:flutter/material.dart';

import '../modal/payment.dart';
import '../services/payment_history_service.dart';
import 'package:flutter/services.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() =>
      _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {

  final PaymentHistoryService paymentHistoryService = PaymentHistoryService();
  List<Payment> payments = [];

  double totalPaid = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadPayments();
  }

  Future<void> loadPayments() async {

    payments = await paymentHistoryService.getAllPayments();
    totalPaid = payments.fold(0, (sum, payment) => sum + payment.amount,);

    setState(() {
      isLoading = false;
    });

  }

  String formatDate(DateTime date) {

    return "${date.day}/${date.month}/${date.year}";

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Payment History"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
          padding: const EdgeInsets.all(16),
          children: [Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Payment Summary",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text("Total Payments"),

                  Text(
                    payments.length.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text("Total Paid"),

                  Text(
                    "₹${totalPaid.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),

        const SizedBox(height: 20),

      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: payments.length,
        itemBuilder: (context, index) {

          final payment = payments[index];

          return Card(

            margin:
            const EdgeInsets.only(bottom: 15),

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "₹${payment.amount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        payment.paymentStatus,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(payment.plan,),

                  Text(payment.paymentMethod,),

                  Text(formatDate(payment.paymentDate,),),

                  const SizedBox(height: 10),

                  const Text(
                    "Receipt Number",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    children: [

                      Expanded(
                        child: SelectableText(
                          payment.receiptNumber,
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {

                          await Clipboard.setData(
                            ClipboardData(
                              text: payment.receiptNumber,
                            ),
                          );

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Receipt Number Copied",
                              ),
                            ),
                          );
                        },
                      ),

                    ],
                  ),

                ],
              ),
            ),
          );
        },
      ),
      ]
      ),
    );
  }
}
