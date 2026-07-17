import 'package:flutter/material.dart';
import '../modal/member.dart';
import '../services/firestore_service.dart';

class AddMemberPage extends StatefulWidget {
  final Member? member;

  const AddMemberPage({
    super.key,
    this.member,
  });

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController planController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  DateTime? selectedStartDate;
  final TextEditingController endDateController = TextEditingController();
  DateTime? selectedEndDate;
  bool isActive = true;

  @override
  void initState() {
    super.initState();

    if (widget.member != null) {
      nameController.text = widget.member!.name;
      phoneController.text = widget.member!.phone;
      ageController.text = widget.member!.age;
      planController.text = widget.member!.plan;
      feeController.text = widget.member!.fee;

      selectedStartDate = widget.member!.startDate;
      selectedEndDate = widget.member!.endDate;

      startDateController.text =
      "${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}";

      endDateController.text =
      "${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}";

      isActive = widget.member!.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Member"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Mobile Number",
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Age",
                prefixIcon: const Icon(Icons.cake),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: planController,
              decoration: InputDecoration(
                labelText: "Membership Plan",
                prefixIcon: const Icon(Icons.card_membership),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: feeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Fee Amount",
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: startDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Start Date",
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2035),
                );

                if (pickedDate != null) {
                  selectedStartDate = pickedDate;

                  startDateController.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
            ),

            const SizedBox(height: 30),

            TextField(
              controller: endDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "End Date",
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2035),
                );

                if (pickedDate != null) {
                  selectedEndDate = pickedDate;

                  endDateController.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
            ),
            const SizedBox(height: 30),

            SwitchListTile(
              title: const Text("Active"),
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = value;
                });
              },
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),

                onPressed: () async {

                  // Check if all fields are filled
                  if (nameController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      ageController.text.isEmpty ||
                      planController.text.isEmpty ||
                      feeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );
                    return;
                  }

                  // Check if dates are selected
                  if (selectedStartDate == null || selectedEndDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select both Start Date and End Date"),
                      ),
                    );
                    return;
                  }

                  if (widget.member == null) {

                    // ADD MEMBER
                    Member member = Member(
                      name: nameController.text,
                      phone: phoneController.text,
                      age: ageController.text,
                      plan: planController.text,
                      fee: feeController.text,
                      startDate: selectedStartDate!,
                      endDate: selectedEndDate!,
                      isActive: isActive,
                    );

                    await firestoreService.addMember(member);

                  } else {

                    // UPDATE MEMBER
                    Member member = Member(
                      id: widget.member!.id,
                      name: nameController.text,
                      phone: phoneController.text,
                      age: ageController.text,
                      plan: planController.text,
                      fee: feeController.text,
                      startDate: selectedStartDate!,
                      endDate: selectedEndDate!,
                      isActive: isActive,
                    );

                    await firestoreService.updateMember(member);
                  }

                  Navigator.pop(context);
                },
                child: const Text(
                  "Save Member",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}