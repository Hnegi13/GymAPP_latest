import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../modal/member.dart';
import '../../services/firestore_service.dart';
import '../../services/subscription_guard_service.dart';

class ExportMembersPage extends StatefulWidget {
  const ExportMembersPage({super.key});

  @override
  State<ExportMembersPage> createState() => _ExportMembersPageState();
}

class _ExportMembersPageState extends State<ExportMembersPage> {

  final FirestoreService firestoreService = FirestoreService();
  final SubscriptionGuardService subscriptionGuard = SubscriptionGuardService();


  int selectedExportType = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Export Members"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Export Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            buildExportOption(
              title: "All Members",
              subtitle: "Export complete member list",
              value: 0,
              icon: Icons.groups,
            ),

            buildExportOption(
              title: "Active Members",
              subtitle: "Only active members",
              value: 1,
              icon: Icons.check_circle_outline,
            ),

            buildExportOption(
              title: "Expired Members",
              subtitle: "Only expired members",
              value: 2,
              icon: Icons.cancel_outlined,
            ),

            buildExportOption(
              title: "Expiring in Next 7 Days",
              subtitle: "Upcoming renewals",
              value: 3,
              icon: Icons.schedule,
            ),

            const SizedBox(height: 25),

            const Text(
              "Transfer",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(

              child: ListTile(

                leading: const Icon(Icons.swap_horiz),

                title: const Text(
                  "Transfer to Another Account",
                ),

                trailing: Text(
                  "Coming Soon",
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ),

            ),

            const SizedBox(height: 35),

            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                onPressed: exportMembers,

                child: const Text(
                  "Export & Share",
                ),

              ),

            ),

          ],
        ),
      ),
    );
  }

  Widget buildExportOption({

    required String title,
    required String subtitle,
    required int value,
    required IconData icon,

  }) {

    return Card(

      margin: const EdgeInsets.only(bottom: 12),

      child: RadioListTile(

        value: value,

        groupValue: selectedExportType,

        onChanged: (value) {

          setState(() {

            selectedExportType = value!;

          });

        },

        secondary: Icon(icon),

        title: Text(title),

        subtitle: Text(subtitle),

      ),

    );

  }

  Future<void> exportMembers() async {

    if (!await SubscriptionGuardService.checkSubscriptionAccess(
      context,
      featureName: "Export Members",
    )) {
      return;
    }



    final members = await getFilteredMembers();

    if (members.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No members found."),
        ),
      );

      return;

    }

    await generateExcelReport(members);

  }

  Future<List<Member>> getFilteredMembers() async {

    switch (selectedExportType) {

      case 1:
        return await firestoreService.getActiveMembers();

      case 2:
        return await firestoreService.getExpiredMembers();

      case 3:
        return await firestoreService.getExpiringMembers();

      default:
        return await firestoreService.getMembers().first;

    }

  }

  Future<void> generateExcelReport(
      List<Member> members,
      ) async {

    var excel = Excel.createExcel();

    Sheet sheet = excel['Members'];

    sheet.appendRow([

      TextCellValue("Name"),
      TextCellValue("Phone"),
      TextCellValue("Plan"),
      TextCellValue("Fee"),
      TextCellValue("Joining Date"),
      TextCellValue("Expiry Date"),
      TextCellValue("Status"),

    ]);

    for (final member in members) {

      sheet.appendRow([

        TextCellValue(member.name),

        TextCellValue(member.phone),

        TextCellValue(member.plan),

        TextCellValue(member.fee),

        TextCellValue(
          member.startDate.toString().split(" ").first,
        ),

        TextCellValue(
          member.endDate.toString().split(" ").first,
        ),

        TextCellValue(
          member.endDate.isAfter(DateTime.now())
              ? "Active"
              : "Expired",
        ),

      ]);

    }

    await saveAndShareExcel(excel);

  }
  Future<void> saveAndShareExcel(
      Excel excel,
      ) async {

    final bytes = excel.encode();

    if (bytes == null) return;

    final directory =
    await getTemporaryDirectory();

    final file = File(
      "${directory.path}/Gym_Manager_Pro_Members.xlsx",
    );

    await file.writeAsBytes(bytes);

    print(file.path);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Gym Manager Pro - Member Report",
    );

  }


}