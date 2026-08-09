import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/payment_qr_service.dart';


class PaymentSettingsPage extends StatefulWidget {
  const PaymentSettingsPage({super.key});

  @override
  State<PaymentSettingsPage> createState() =>
      _PaymentSettingsPageState();
}

class _PaymentSettingsPageState extends State<PaymentSettingsPage> {

  final PaymentQrService paymentQrService = PaymentQrService();
  String? paymentQrUrl;
  Timestamp? paymentQrUpdatedAt;

  bool isUploading = false;

  final TextEditingController upiIdController = TextEditingController();

  bool isSavingUpi = false;

  @override
  void initState() {
    super.initState();

    loadPaymentQr();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Payment Settings"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            buildQrCard(),

            const SizedBox(height: 20),

            buildUpiCard(),
          ],
        ),
      ),
    );
  }

  Widget buildQrCard() {

    DateTime? updatedDate;
    String formattedDate = "";

    if (paymentQrUpdatedAt != null) {
      updatedDate = paymentQrUpdatedAt!.toDate();
      formattedDate =
          DateFormat('dd MMM yyyy • h:mm a').format(updatedDate);
    }

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(

        children: [

          paymentQrUrl == null
              ? const Icon(
            Icons.qr_code_2,
            size: 80,
            color: Colors.deepPurple,
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              paymentQrUrl!,
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 15),

           Text(
            paymentQrUrl == null
                ? "Gym Payment QR"
                : "Payment QR Uploaded",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          paymentQrUrl == null
              ? Text(
            "Upload your payment QR code.\nIt will be used while requesting payments.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          )
              : Column(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "✓ Payment QR Active",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Icon(
                    Icons.schedule,
                    size: 18,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    "Last Updated",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(

              onPressed: isUploading ? null : uploadQrCode,

              icon: const Icon(Icons.upload),

              label: Text(
                isUploading
                    ? "Uploading..."
                    : paymentQrUrl == null
                    ? "Upload QR Code"
                    : "Change QR Code",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUpiCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Row(
            children: [

              Icon(
                Icons.account_balance_wallet,
                color: Colors.blue,
              ),

              SizedBox(width: 10),

              Text(
                "UPI Payment",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          TextField(

            controller: upiIdController,

            decoration: const InputDecoration(
              labelText: "UPI ID",
              hintText: "example@okhdfcbank",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(

            width: double.infinity,

            child: ElevatedButton(

              onPressed: isSavingUpi
                  ? null
                  : saveUpiId,

              child: Text(
                isSavingUpi
                    ? "Saving..."
                    : "Save UPI ID",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadQrCode() async {

    setState(() {
      isUploading = true;
    });

    try {

      final url = await paymentQrService.uploadPaymentQr();

      if (url != null) {

        await paymentQrService.saveQrUrl(url);
        await loadPaymentQr();

        if (mounted) {

          ScaffoldMessenger.of(context).showSnackBar(

            const SnackBar(
              content: Text("QR Code uploaded successfully."),
            ),

          );
        }
      }

    } catch (e) {

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(e.toString()),
          ),

        );
      }

    } finally {

      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }

    }
  }


  Future<void> saveUpiId() async {

    final upiId = upiIdController.text.trim();

    if (upiId.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your UPI ID."),
        ),
      );

      return;
    }

    if (!upiId.contains("@")) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid UPI ID."),
        ),
      );

      return;
    }

    setState(() {
      isSavingUpi = true;
    });

    try {

      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("gyms")
          .doc(uid)
          .set({
        "upiId": upiId,
      }, SetOptions(merge: true));

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("UPI ID saved successfully."),
          ),
        );

      }

    } catch (e) {

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );

      }

    } finally {

      if (mounted) {

        setState(() {
          isSavingUpi = false;
        });

      }

    }
  }



  Future<void> loadPaymentQr() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("gyms")
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        paymentQrUrl = doc.data()?["paymentQrUrl"];
        paymentQrUpdatedAt = doc.data()?["paymentQrUpdatedAt"];

        upiIdController.text = doc.data()?["upiId"] ?? "";
      });
    }
  }
}