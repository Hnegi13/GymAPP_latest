import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modal/gym.dart';
import '../services/gym_service.dart';
import '../Screens/dashboard_page.dart';
import '../modal/subscription.dart';
import '../utils/app_constants.dart';

class RegisterGymPage extends StatefulWidget {
  const RegisterGymPage({super.key});

  @override
  State<RegisterGymPage> createState() => _RegisterGymPageState();
}

class _RegisterGymPageState extends State<RegisterGymPage> {

  final gymNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();

  final GymService gymService = GymService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Register Gym"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: gymNameController,
              decoration: const InputDecoration(
                labelText: "Gym Name",
                prefixIcon: Icon(Icons.fitness_center),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                labelText: "Owner Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                prefixIcon: Icon(Icons.phone),
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

                  final user =
                  FirebaseAuth.instance.currentUser!;

                  Subscription subscription = Subscription(
                    plan: AppConstants.freePlan,
                    memberLimit: AppConstants.freeMemberLimit,
                    isActive: true,
                    amountPaid: 0,
                    paymentStatus: "FREE",
                    startDate: DateTime.now(),
                    endDate: DateTime.now(),
                  );


                  Gym gym = Gym(
                    id: user.uid,
                    gymName: gymNameController.text,
                    ownerName: ownerNameController.text,
                    phone: phoneController.text,
                    email: user.email ?? "",
                    createdAt: DateTime.now(),
                    subscription: subscription,
                  );

                  await gymService.saveGym(gym);

                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DashboardPage(),
                      ),
                    );
                  }

                },

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
    );
  }
}