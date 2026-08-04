import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../modal/gym.dart';
import '../dashboard/profile_page.dart';

class HeaderWidget extends StatelessWidget {

  final Gym gym;

  const HeaderWidget({
    super.key,
    required this.gym,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6D5DF6),
            Color(0xFF4E33E8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  gym.gymName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ProfilePage(),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white24,
                                  child: Text(
                                    gym.ownerName.isNotEmpty
                                        ? gym.ownerName[0].toUpperCase()
                                        : "G",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 2),

                           Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: Wrap(
                              spacing: 20,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      gym.location,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.white70,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      DateFormat('dd MMM').format(DateTime.now()),
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),

                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}