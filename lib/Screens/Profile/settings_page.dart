import 'package:flutter/material.dart';
import '../../services/settings_service.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final SettingsService _settingsService = SettingsService();
  bool _isResetting = false;


  Future<void> _resetAllData() async {

    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset All Data"),
          content: const Text(
            "This will permanently delete:\n\n"
                "• All Members\n"
                "• Attendance Records\n"
                "• Payments\n\n"
                "Your Gym Profile and Subscription will remain.\n\n"
                "Do you want to continue?",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) {
      return;
    }

    setState(() {
      _isResetting = true;
    });

    try {

      await _settingsService.resetAllData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All gym data has been reset successfully."),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to reset data.\n$e"),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          _isResetting = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text(
            "Danger Zone",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              enabled: !_isResetting,

              leading: const Icon(
                Icons.restart_alt,
                color: Colors.orange,
              ),

              title: const Text("Reset All Data"),

              subtitle: const Text(
                "Delete members, attendance and payments",
              ),

              trailing: _isResetting
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                ),
              )
                  : const Icon(Icons.chevron_right),

              onTap: _isResetting
                  ? null
                  : _resetAllData,
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              title: const Text("Delete Gym Account"),
              subtitle: const Text(
                "Permanently delete your gym account",
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 30),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            "Preferences",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text("Notification Settings"),
              subtitle: const Text("Coming Soon"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text("Theme"),
              subtitle: const Text("Coming Soon"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}