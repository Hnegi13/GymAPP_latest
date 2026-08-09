import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screens/home/home_page.dart';
import '../modal/gym.dart';
import '../services/gym_service.dart';
import '../Screens/dashboard_v2_page.dart';
import '../modal/subscription.dart';
import '../utils/app_constants.dart';
import 'auth_service.dart';

class RegisterGymPage extends StatefulWidget {

  final bool isEditMode;

  const RegisterGymPage({
    super.key,
    this.isEditMode = false,
  });

  @override
  State<RegisterGymPage> createState() => _RegisterGymPageState();
}


class _RegisterGymPageState extends State<RegisterGymPage> {

  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final gymNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  final GymService gymService = GymService();

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode) {
      loadGymDetails();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.isEditMode
              ? "Edit Profile"
              : "Register Gym",
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,

        actions: widget.isEditMode
            ? null
            : [
          TextButton(
            onPressed: () async {
              await authService.signOut();
            },
            child: const Text(
              "Close",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  TextFormField(
                    controller: gymNameController,
                    decoration: InputDecoration(
                      label: requiredLabel("Gym Name"),
                      prefixIcon: const Icon(Icons.fitness_center),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Gym Name";
                      }
                      return null;
                    },
                  ),

            const SizedBox(height: 20),

                  TextFormField(
                    controller: ownerNameController,
                    decoration: InputDecoration(
                      label: requiredLabel("Owner Name"),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Owner Name";
                      }
                      return null;
                    },
                  ),

            const SizedBox(height: 20),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      label: requiredLabel("Mobile Number"),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Mobile Number";
                      }

                      final phone = value.trim();

                      if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
                        return "Enter a valid 10-digit mobile number";
                      }

                      return null;
                    },
                  ),

            const SizedBox(height: 20),

                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      label: requiredLabel("Location (City)"),
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter City";
                      }
                      return null;
                    },
                  ),

            const SizedBox(height: 20),

            TextField(
              controller: stateController,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: "State",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                prefixIcon: const Icon(Icons.map),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: countryController,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: "Country",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                prefixIcon: const Icon(Icons.public),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),

                onPressed: () async {

                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final user = FirebaseAuth.instance.currentUser!;

                  Subscription subscription = Subscription(
                    plan: AppConstants.freeTrialPlan,
                    memberLimit: AppConstants.freeMemberLimit,
                    isActive: true,
                    amountPaid: 0,
                    paymentStatus: "TRIAL",
                    startDate: DateTime.now(),
                    endDate: DateTime.now().add(Duration(days: AppConstants.freeTrialDays),),
                    status: "trial",
                  );


                  Gym gym = Gym(
                    id: user.uid,
                    gymName: gymNameController.text,
                    ownerName: ownerNameController.text,
                    location: locationController.text.trim(),
                    phone: phoneController.text,
                    email: user.email ?? "",
                    createdAt: DateTime.now(),
                    subscription: subscription,
                  );

                  await gymService.saveGym(gym);

                  if (!context.mounted) return;

                  if (widget.isEditMode) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile updated successfully."),
                      ),
                    );

                    Navigator.pop(context);

                  } else {

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );

                  }

                },

                child: Text(
                  widget.isEditMode
                      ? "Save Changes"
                      : "Continue",
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
      ),
    );
  }


  Future<void> loadGymDetails() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final gym = await gymService.getGym(uid);

    if (gym == null) return;

    gymNameController.text = gym.gymName;
    ownerNameController.text = gym.ownerName;
    phoneController.text = gym.phone;
    locationController.text = gym.location;

    if (mounted) {
      setState(() {});
    }
  }



  Widget requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}