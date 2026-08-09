import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../modal/member.dart';
import '../../services/gym_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';


class PaymentRequestPage extends StatefulWidget {
  final Member member;
  const PaymentRequestPage({
    super.key,
    required this.member,
  });

  @override
  State<PaymentRequestPage> createState() => _PaymentRequestPageState();
}

class _PaymentRequestPageState extends State<PaymentRequestPage> {

  String gymName = "";
  String upiId = "";
  String paymentQrUrl = "";
  late final expiredDays = DateTime.now().difference(widget.member.endDate).inDays;

  final GymService gymService = GymService();

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadGymDetails();
  }


  String _generateMessage() {

    return '''
Hi ${widget.member.name},

Your membership at $gymName has expired $expiredDays day(s) ago .
Plan : ${widget.member.plan}
Renewal Amount : ₹${widget.member.fee}

Please complete the payment using the UPI ID or attached QR Code image.

UPI ID : $upiId

Payment QR :
$paymentQrUrl

Once the payment is completed, kindly share the payment screenshot.

Thank you,
$gymName
''';
  }


  Future<void> loadGymDetails() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final gym = await gymService.getGym(uid);

    final paymentDoc = await FirebaseFirestore.instance
        .collection("gyms")
        .doc(uid)
        .get();

    if (gym != null) {

      setState(() {

        gymName = gym.gymName;

        upiId = paymentDoc.data()?["upiId"] ?? "";

        paymentQrUrl = paymentDoc.data()?["paymentQrUrl"] ?? "";

        messageController.text = _generateMessage();

      });

    }
  }



  @override
  Widget build(BuildContext context) {

    final expiredDays = DateTime.now().difference(widget.member.endDate).inDays;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Request Payment"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            buildMemberCard(),

            const SizedBox(height: 16),

            buildPaymentMethodCard(),

            const SizedBox(height: 16),

            buildMessageCard(),

            const SizedBox(height: 24),

            buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildMemberCard() {
    final expiredDays = DateTime.now().difference(widget.member.endDate).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children:  [

            Text(
              "Member Details",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.deepPurple.shade50,
                  child: Icon(
                    Icons.person,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [

                      Text(
                        widget.member.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        widget.member.plan,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Expired",
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Divider(),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Amount Due",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 4),

                    Text(
                      widget.member.fee,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Text(
                      "Expired",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "$expiredDays day(s) ago",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FBF5), // Light mint green
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Payment Method",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.green.shade300,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.qr_code,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 15),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "UPI ID & QR Code",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Send your gym UPI ID & QR Code",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7FF), // Light lavender
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: const [

              Icon(
                Icons.message_outlined,
                color: Colors.deepPurple,
              ),

              SizedBox(width: 8),

              Text(
                "Message",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          TextField(
            controller: messageController,
            maxLines: 8,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: "Enter your payment request message...",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.deepPurple.shade200,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.deepPurple.shade100,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.deepPurple,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    return Column(
      children: [

        buildActionButton(
          title: "Send via WhatsApp",
          icon: Icons.chat,
          startColor: const Color(0xFF81C784),
          endColor: const Color(0xFFA5D6A7),
          onTap: sendWhatsApp,
        ),

        const SizedBox(height: 14),

        buildActionButton(
          title: "Send via SMS",
          icon: Icons.sms,
          startColor: Colors.blue.shade400,
          endColor: Colors.blue.shade700,
          onTap: sendSms,
        ),

        const SizedBox(height: 14),

        buildActionButton(
          title: "Share Payment Request",
          icon: Icons.share,
          startColor: Colors.deepPurple.shade400,
          endColor: Colors.deepPurple.shade700,
          onTap: shareMessage,
        ),
      ],
    );
  }

  //send via SMS

  Future<void> sendSms() async {

    final phone = widget.member.phone;

    final message = Uri.encodeComponent(
      messageController.text,
    );

    final Uri smsUri = Uri.parse(
      "sms:$phone?body=$message",
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to open SMS app."),
          ),
        );
      }
    }
  }

  //send via Whatsapp

  Future<void> sendWhatsApp() async {

    final phone = "91${widget.member.phone}";

    final message = Uri.encodeComponent(
      messageController.text,
    );

    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$phone?text=$message",
    );

    if (await canLaunchUrl(whatsappUri)) {

      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );

    } else {

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp is not installed."),
          ),
        );

      }

    }
  }

//share the message

  Future<void> shareMessage() async {

    await Share.share(
      messageController.text,
      subject: "Membership Renewal",
    );

  }

  //helper

  Widget buildActionButton({
    required String title,
    required IconData icon,
    required Color startColor,
    required Color endColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shadowColor: startColor.withOpacity(.4),
          backgroundColor: startColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }



}