import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../modal/member.dart';
import '../../services/gym_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpiringMemberPaymentPage extends StatefulWidget {
  final Member member;

  const ExpiringMemberPaymentPage({
    super.key,
    required this.member,
  });
  @override
  State<ExpiringMemberPaymentPage> createState() => _ExpiringMemberPaymentPageState();
}

class _ExpiringMemberPaymentPageState
    extends State<ExpiringMemberPaymentPage> {
  String gymName = "";
  String upiId = "";
  String paymentQrUrl = "";

  final GymService gymService = GymService();
  final TextEditingController messageController =
  TextEditingController();

  int get daysRemaining {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final expiryDate = DateTime(
      widget.member.endDate.year,
      widget.member.endDate.month,
      widget.member.endDate.day,
    );

    return expiryDate.difference(today).inDays;
  }

  @override
  void initState() {
    super.initState();
    loadGymDetails();
  }

  String _generateMessage() {
    final days = daysRemaining;

    String expiryMessage;

    if (days == 0) {
      expiryMessage = "Your membership at $gymName expires today.";
    } else if (days == 1) {
      expiryMessage =
      "Your membership at $gymName expires in 1 day.";
    } else {
      expiryMessage =
      "Your membership at $gymName expires in $days days.";
    }

    return '''
Hi ${widget.member.name},

$expiryMessage

Plan : ${widget.member.plan}
Renewal Amount : ₹${widget.member.fee}

Please renew your membership before the expiry date.

Thank you,
$gymName
''';
  }

  Future<void> loadGymDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final gym = await gymService.getGym(user.uid);

    final paymentDoc = await FirebaseFirestore.instance
        .collection("gyms")
        .doc(user.uid)
        .get();

    if (!mounted) return;

    if (gym != null) {
      setState(() {
        gymName = gym.gymName;

        upiId = paymentDoc.data()?["upiId"] ?? "";
        paymentQrUrl =
            paymentDoc.data()?["paymentQrUrl"] ?? "";

        messageController.text = _generateMessage();
      });
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Expiring Member"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            buildMemberCard(),

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
    final days = daysRemaining;

    String expiryText;

    if (days == 0) {
      expiryText = "Expires Today";
    } else if (days == 1) {
      expiryText = "Expires in 1 day";
    } else {
      expiryText = "Expires in $days days";
    }

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

          children: [
            const Text(
              "Member Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                  Colors.deepPurple.shade50,

                  child: const Icon(
                    Icons.person,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        widget.member.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.member.plan,
                        style: const TextStyle(
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
                    color: Colors.orange.shade50,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: Text(
                    "Expiring",
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Renewal Amount",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "₹${widget.member.fee}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,

                  children: [
                    const Text(
                      "Membership",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      expiryText,
                      style: TextStyle(
                        color: Colors.orange.shade800,
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

  Widget buildMessageCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFFAF7FF),
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
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          const Row(
            children: [
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
              hintText:
              "Enter your reminder message...",

              filled: true,
              fillColor: Colors.white,

              contentPadding:
              const EdgeInsets.all(18),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(15),

                borderSide: BorderSide(
                  color:
                  Colors.deepPurple.shade100,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(15),

                borderSide:
                const BorderSide(
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
          title: "Call Member",
          icon: Icons.call,
          color: Colors.green,
          onTap: callMember,
        ),

        const SizedBox(height: 14),

        buildActionButton(
          title: "WhatsApp Reminder",
          icon: Icons.chat,
          color: Colors.green,
          onTap: sendWhatsApp,
        ),

        const SizedBox(height: 14),

        buildActionButton(
          title: "SMS Reminder",
          icon: Icons.sms,
          color: Colors.blue,
          onTap: sendSms,
        ),
      ],
    );
  }

  Future<void> callMember() async {
    final Uri phoneUri = Uri.parse(
      "tel:${widget.member.phone}",
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> sendSms() async {
    final message = Uri.encodeComponent(
      messageController.text,
    );

    final Uri smsUri = Uri.parse(
      "sms:${widget.member.phone}?body=$message",
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

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
    }
  }

  Widget buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
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
          backgroundColor: color,
          elevation: 5,

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}