import 'package:flutter/material.dart';
import 'package:gym_app/Screens/payment_request/payment_request_page.dart';
import '../modal/member.dart';
import 'member_details_page.dart';
import 'package:url_launcher/url_launcher.dart';

class FilteredMembersPage extends StatelessWidget {

  final String title;
  final List<Member> members;
  final bool isExpired;

  const FilteredMembersPage({
    super.key,
    required this.title,
    required this.members,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {


    if (members.isEmpty) {

      final message = title == "Expiring Members"
          ? "No memberships are expiring soon."
          : "No expired memberships.\nAll members are active.";

      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 70,
              ),

              const SizedBox(height: 20),

              const Text(
                "Great News!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

            ],
          ),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {

          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),

            title: Text(members[index].name),

            subtitle: Text(
              isExpired
                  ? "Membership Expired ${DateTime.now().difference(members[index].endDate).inDays} day(s) ago"
                  : "Membership Expires in ${members[index].endDate.difference(DateTime.now()).inDays} day(s)",
            ),

            trailing: PopupMenuButton<String>(
              onSelected: (value) {

                if (value == "call") {
                  callMember(members[index].phone);
                }
                if (value == "whatsapp") {
                  sendWhatsApp(members[index]);
                }
                if (value == "sms") {
                  sendSMS(members[index]);
                }

                if (value == "payment") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentRequestPage(
                        member: members[index],
                      ),
                    ),
                  );
                }
              },

              itemBuilder: (context) => [

                const PopupMenuItem(
                  value: "call",
                  child: Row(
                    children: [
                      Icon(Icons.call, color: Colors.green),
                      SizedBox(width: 10),
                      Text("Call Member"),
                    ],
                  ),
                ),

                const PopupMenuItem(
                  value: "whatsapp",
                  child: Row(
                    children: [
                      Icon(Icons.chat, color: Colors.green),
                      SizedBox(width: 10),
                      Text("WhatsApp Reminder"),
                    ],
                  ),
                ),

                const PopupMenuItem(
                  value: "sms",
                  child: Row(
                    children: [
                      Icon(Icons.sms, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("SMS Reminder"),
                    ],
                  ),
                ),

                //new Request payment

                // Request Payment only for expired members
                if (isExpired)
                  const PopupMenuItem(
                    value: "payment",
                    child: Row(
                      children: [
                        Icon(Icons.payments, color: Colors.deepPurple),
                        SizedBox(width: 10),
                        Text("Request Payment"),
                      ],
                    ),
                  ),

              ],
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MemberDetailsPage(
                    member: members[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> callMember(String phone) async {
    final Uri uri = Uri.parse("tel:$phone");

    if (!await launchUrl(uri)) {
      throw Exception("Could not launch $uri");
    }
  }

  Future<void> sendWhatsApp(Member member) async {
    final message = generateReminderMessage(member);

    final Uri uri = Uri.parse(
      "whatsapp://send?phone=91${member.phone}&text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    else {
      print("WhatsApp is not installed");
    }
  }
  Future<void> sendSMS(Member member) async {
    final message = generateReminderMessage(member);

    final Uri uri = Uri.parse(
      "sms:${member.phone}?body=${Uri.encodeComponent(message)}",
    );

    await launchUrl(uri);
  }

  String generateReminderMessage(Member member) {
    int daysLeft = member.endDate.difference(DateTime.now()).inDays;

    if (daysLeft < 0) {
      return """
🏋️ Hello ${member.name},

Your gym membership expired ${daysLeft.abs()} day(s) ago.

We'd love to have you back! Please renew your membership to continue enjoying our gym facilities.

Thank you,
Gym Management
""";
    } else if (daysLeft == 0) {
      return """
🏋️ Hello ${member.name},

Your gym membership expires today.

Please renew your membership today to avoid any interruption.

Thank you,
Gym Management
""";
    } else if (daysLeft == 1) {
      return """
🏋️ Hello ${member.name},

Your gym membership will expire tomorrow.

Please renew your membership to continue your fitness journey.

Thank you,
Gym Management
""";
    } else {
      return """
🏋️ Hello ${member.name},

Your gym membership will expire in $daysLeft days.

Please renew your membership before the expiry date to continue enjoying our gym facilities.

Thank you,
Gym Management
""";
    }
  }
}