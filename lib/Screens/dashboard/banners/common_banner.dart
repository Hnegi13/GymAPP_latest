import 'package:flutter/material.dart';

class CommonBanner extends StatelessWidget {
  final IconData statusIcon;

  final Color statusIconColor;

  final Color backgroundColor;

  final Color borderColor;

  final String title;

  final String subtitle;

  final String buttonText;

  final VoidCallback onPressed;

  const CommonBanner({
    super.key,
    required this.statusIcon,
    required this.statusIconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [

          /// Fixed Brand Icon
          Icon(
            Icons.workspace_premium,
            color: Colors.deepPurple,
            size: 24,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Icon(
                      statusIcon,
                      size: 18,
                      color: statusIconColor,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),

          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(90, 36),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(25),
              ),
            ),
            child: Text(buttonText),
          ),

        ],
      ),
    );
  }
}