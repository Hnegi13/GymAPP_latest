import 'package:flutter/material.dart';
import '../modal/member.dart';
import '../services/firestore_service.dart';

class RenewMembershipPage extends StatefulWidget {
  final Member member;

  const RenewMembershipPage({
    super.key,
    required this.member,
  });

  @override
  State<RenewMembershipPage> createState() =>
      _RenewMembershipPageState();
}

class _RenewMembershipPageState extends State<RenewMembershipPage> {
  final FirestoreService firestoreService = FirestoreService();
  int selectedMonths = 1;

  DateTime getNewExpiryDate() {
    return DateTime(
      widget.member.endDate.year,
      widget.member.endDate.month + selectedMonths,
      widget.member.endDate.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Renew Membership"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
            widget.member.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Current Plan : ${widget.member.plan}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            Text(
              "Current Expiry : ${widget.member.endDate.day}/${widget.member.endDate.month}/${widget.member.endDate.year}",

            ),
          const SizedBox(height: 30),

              const Text(
                "Renewal Duration",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),


              const SizedBox(height: 15),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [

                  ChoiceChip(
                    label: const Text("1 Month"),
                    selected: selectedMonths == 1,
                    onSelected: (_) {
                      setState(() {
                        selectedMonths = 1;
                      });
                    },
                  ),

                  ChoiceChip(
                    label: const Text("2 Months"),
                    selected: selectedMonths == 2,
                    onSelected: (_) {
                      setState(() {
                        selectedMonths = 2;
                      });
                    },
                  ),

                  ChoiceChip(
                    label: const Text("3 Months"),
                    selected: selectedMonths == 3,
                    onSelected: (_) {
                      setState(() {
                        selectedMonths = 3;
                      });
                    },
                  ),

                  ChoiceChip(
                    label: const Text("6 Months"),
                    selected: selectedMonths == 6,
                    onSelected: (_) {
                      setState(() {
                        selectedMonths = 6;
                      });
                    },
                  ),

                  ChoiceChip(
                    label: const Text("12 Months"),
                    selected: selectedMonths == 12,
                    onSelected: (_) {
                      setState(() {
                        selectedMonths = 12;
                      });
                    },
                  ),

                ],
              ),
            const SizedBox(height: 30),

            const Text(
              "New Expiry Date",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {

                  await firestoreService.renewMembership(
                    id: widget.member.id!,
                    newEndDate: getNewExpiryDate(),
                    plan: widget.member.plan,
                    fee: widget.member.fee,
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  "Renew Membership",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "${getNewExpiryDate().day}/${getNewExpiryDate().month}/${getNewExpiryDate().year}",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}