import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../modal/member.dart';
import '../../services/firestore_service.dart';

class BulkMessagingPage extends StatefulWidget {
  const BulkMessagingPage({super.key});

  @override
  State<BulkMessagingPage> createState() => _BulkMessagingPageState();
}

class _BulkMessagingPageState extends State<BulkMessagingPage> {

  final TextEditingController messageController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  final Set<String> selectedMemberIds = {};
  List<Member> members = [];

  bool selectAll = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Bulk Messaging"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Send announcements, offers or reminders to your members.",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 20),

            CheckboxListTile(
              value: selectAll,
              title: Text(
                "Select All Members (${selectedMemberIds.length} selected)",
              ),
              onChanged: (value) {
                setState(() {
                  selectAll = value ?? false;
                  selectedMemberIds.clear();
                  if (selectAll) {
                    for (final member in members) {
                      if (member.id != null) {
                        selectedMemberIds.add(member.id!);
                      }
                    }
                  }
                });
              },
            ),

            const Divider(),

            Expanded(
              child: StreamBuilder<List<Member>>(
                stream: firestoreService.getMembers(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No members found."),
                    );
                  }

                  members = snapshot.data!;

                  return ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return CheckboxListTile(
                        value: selectedMemberIds.contains(member.id),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedMemberIds.add(member.id!);
                            } else {
                              selectedMemberIds.remove(member.id);
                            }
                            selectAll = selectedMemberIds.length == members.length;
                          });
                        },
                        title: Text(member.name),
                        subtitle: Text(member.phone),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: sendBulkSms,
                    child: const Text("SMS"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("WhatsApp"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Share"),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),

    );
  }

  //get all phone number
  List<String> getSelectedPhoneNumbers() {

    return members
        .where((member) =>
        selectedMemberIds.contains(member.id))
        .map((member) => member.phone)
        .where((phone) => phone.isNotEmpty)
        .toList();

  }

  //validation

  bool validateBulkMessage() {

    if (selectedMemberIds.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select at least one member.",
          ),
        ),
      );

      return false;
    }

    if (messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a message.",
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> sendBulkSms() async {

    if (!validateBulkMessage()) return;
    final phones = getSelectedPhoneNumbers();
    if (phones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No valid phone numbers found."),
        ),
      );

      return;
    }

    final phoneNumbers = phones.join(",");

    final message = Uri.encodeComponent(
      messageController.text,
    );

    final Uri smsUri = Uri.parse(
      "sms:$phoneNumbers?body=$message",
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open SMS app."),
        ),
      );

    }

  }
}