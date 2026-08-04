import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 11,
      child: Stack(
        fit: StackFit.expand,
        children: [

          // Background
          Image.asset(
            "lib/assets/images/gym_background.png",
            fit: BoxFit.cover,
            alignment: const Alignment(0.8, 0),
          ),

          // White overlay
          Container(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white,
                  Color(0xF7FFFFFF),
                  Color(0xCCFFFFFF),
                  Colors.transparent,
                ],
                stops: [0.0, 0.22, 0.42, 0.75],
              ),
            ),
          ),

          //logo
          Positioned(
            top: MediaQuery.of(context).padding.top + 55,
            left: 24,
            child: Image.asset(
              "lib/assets/images/app_logo.png",
              width: 115,
            ),
          ),

          //App Name
          Positioned(
            top: MediaQuery.of(context).padding.top + 190,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Gym Manager",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                    height: 1.0,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Pro",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C3EF4),
                  ),
                ),
              ],
            ),
          ),


          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x55FFFFFF),
                    Color(0xCCFFFFFF),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}