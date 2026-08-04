import 'package:flutter/material.dart';
import 'package:gym_app/Auth/widgets/contact_card.dart';
import 'auth_service.dart';
import 'widgets/welcome_header.dart';
import 'widgets/feature_section.dart';
import 'widgets/google_signin_button.dart';
import 'widgets/footer_widget.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children:  [

              WelcomeHeader(),

              Transform.translate(
                offset: const Offset(0, -20),
                child: const FeatureSection(),
              ),

               SizedBox(height: 0),

              GoogleSignInButton(
                onPressed: () async {
                  try {
                    await authService.signInWithGoogle();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
              ),

              const SizedBox(height: 12),

              const ContactCard(),
              const SizedBox(height: 12),

              FooterWidget(),

              const SizedBox(height: 16),

              const SizedBox(height: 10),

              Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}