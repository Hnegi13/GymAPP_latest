import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_session.dart';
import '../home/home_page.dart';


class AdminMpinPage extends StatefulWidget {
  final String adminEmail;
  final String adminName;

  const AdminMpinPage({
    super.key,
    required this.adminEmail,
    required this.adminName,
  });

  @override
  State<AdminMpinPage> createState() => _AdminMpinPageState();
}

class _AdminMpinPageState extends State<AdminMpinPage> {
  final TextEditingController _mpinController =
  TextEditingController();

  bool _obscureMpin = true;
  bool _isChecking = false;

  @override
  void dispose() {
    _mpinController.dispose();
    super.dispose();
  }

  Future<void> _verifyAdminMpin() async {
    final enteredMpin = _mpinController.text.trim();

    if (enteredMpin.length != 6) {
      _showMessage("Please enter your 6-digit MPIN.");
      return;
    }

    setState(() {
      _isChecking = true;
    });

    String correctMpin;

    if (widget.adminEmail ==
        AppConstants.demoAdmin1Email) {
      correctMpin = AppConstants.demoAdmin1Mpin;
    } else if (widget.adminEmail ==
        AppConstants.demoAdmin2Email) {
      correctMpin = AppConstants.demoAdmin2Mpin;
    } else {
      correctMpin = "";
    }

    if (!mounted) return;

    setState(() {
      _isChecking = false;
    });

    if (enteredMpin == correctMpin) {
      // Start demo session using the selected admin's gym ID.
      if (widget.adminEmail == AppConstants.demoAdmin1Email) {
        AppSession.startDemoSession(
          gymId: AppConstants.demoAdmin1GymId,
        );
      } else if (widget.adminEmail == AppConstants.demoAdmin2Email) {
        AppSession.startDemoSession(
          gymId: AppConstants.demoAdmin2GymId,
        );
      } else {
        _showMessage("Invalid demo account.");
        return;
      }

      if (!mounted) return;

      // For now, just confirm the session was created.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      _mpinController.clear();
      _showMessage("Incorrect MPIN. Please try again.");
    }
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
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: const Text("Enter MPIN"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,

              padding: const EdgeInsets.all(24),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Icon(
                      Icons.lock_outline,
                      size: 70,
                      color: Colors.deepPurple,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Welcome!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.adminName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      widget.adminEmail,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Enter your 6-digit MPIN to continue.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 35),

                    TextField(
                      controller: _mpinController,
                      keyboardType: TextInputType.number,
                      obscureText: _obscureMpin,
                      maxLength: 6,

                      decoration: InputDecoration(
                        labelText: "MPIN",

                        prefixIcon: const Icon(
                          Icons.lock,
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureMpin
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureMpin =
                              !_obscureMpin;
                            });
                          },
                        ),

                        border:
                        const OutlineInputBorder(),

                        counterText: null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: _isChecking
                            ? null
                            : _verifyAdminMpin,

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.deepPurple,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                        ),

                        child: _isChecking
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child:
                          CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
                          "Unlock",
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
            );
          },
        ),
      ),
    );
  }
}