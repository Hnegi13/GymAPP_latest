import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Auth/auth_service.dart';
import '../../services/mpin_service.dart';
import 'create_mpin_page.dart';

class EnterMpinPage extends StatefulWidget {
  final VoidCallback onVerified;

  const EnterMpinPage({
    super.key,
    required this.onVerified,
  });

  @override
  State<EnterMpinPage> createState() => _EnterMpinPageState();
}

class _EnterMpinPageState extends State<EnterMpinPage> {
  final MpinService _mpinService = MpinService();
  final AuthService _authService = AuthService();

  final user = FirebaseAuth.instance.currentUser;
  late final email = user?.email ?? '';

  final TextEditingController _mpinController =
  TextEditingController();

  bool _obscureMpin = true;
  bool _isChecking = false;

  @override
  void dispose() {
    _mpinController.dispose();
    super.dispose();
  }

  Future<void> _verifyMpin() async {
    final mpin = _mpinController.text.trim();

    if (mpin.length != 6) {
      _showMessage("Please enter your 6-digit MPIN.");
      return;
    }

    setState(() {
      _isChecking = true;
    });

    final isValid = await _mpinService.verifyMpin(mpin);

    if (!mounted) return;

    setState(() {
      _isChecking = false;
    });

    if (isValid) {
      widget.onVerified();
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        appBar: AppBar(
          title: const Text("Enter MPIN"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goToLogin,
          ),
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
                        "Welcome back!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        email,
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
                          onPressed:
                          _isChecking
                              ? null
                              : _verifyMpin,

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.deepPurple,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                30,
                              ),
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

                      const SizedBox(height: 15),

                      TextButton(
                        onPressed: _forgotMpin,

                        child: const Text(
                          "Forgot MPIN?",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 15,
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
      ),
    );
  }

  Future<void> _goToLogin() async {
    await _authService.signOut();
  }

  Future<void> _forgotMpin() async {
    try {
      await _authService.reauthenticateWithGoogle();

      if (!mounted) return;

      await _mpinService.deleteMpin();

      if (!mounted) return;

      final mpinCreated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => const CreateMpinPage(),
        ),
      );

      if (!mounted) return;

      if (mpinCreated == true) {
        widget.onVerified();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Google verification was not completed.",
          ),
        ),
      );
    }
  }
}