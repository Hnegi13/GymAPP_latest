import 'package:flutter/material.dart';
import '../../services/mpin_service.dart';

class CreateMpinPage extends StatefulWidget {
  const CreateMpinPage({super.key});

  @override
  State<CreateMpinPage> createState() => _CreateMpinPageState();
}

class _CreateMpinPageState extends State<CreateMpinPage> {
  final MpinService _mpinService = MpinService();

  final TextEditingController _mpinController =
  TextEditingController();

  final TextEditingController _confirmMpinController =
  TextEditingController();

  bool _obscureMpin = true;
  bool _obscureConfirmMpin = true;

  @override
  void dispose() {
    _mpinController.dispose();
    _confirmMpinController.dispose();
    super.dispose();
  }

  Future<void> _saveMpin() async {
    final mpin = _mpinController.text.trim();
    final confirmMpin = _confirmMpinController.text.trim();

    if (mpin.length != 6 || confirmMpin.length != 6) {
      _showMessage("MPIN must be 6 digits.");
      return;
    }

    if (mpin != confirmMpin) {
      _showMessage("MPINs do not match.");
      return;
    }

    await _mpinService.saveMpin(mpin);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create MPIN"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              const Icon(
                Icons.lock_outline,
                size: 70,
                color: Colors.deepPurple,
              ),

              const SizedBox(height: 20),

              const Text(
                "Create your MPIN",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Your MPIN will be securely stored on this device "
                    "and will be used to unlock Gym Manager Pro.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              TextField(
                controller: _mpinController,
                keyboardType: TextInputType.number,
                obscureText: _obscureMpin,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: "Create 6-digit MPIN",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureMpin
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureMpin = !_obscureMpin;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: _confirmMpinController,
                keyboardType: TextInputType.number,
                obscureText: _obscureConfirmMpin,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: "Confirm MPIN",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmMpin
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmMpin =
                        !_obscureConfirmMpin;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMpin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}