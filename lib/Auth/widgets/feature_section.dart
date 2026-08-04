import 'package:flutter/material.dart';

class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: _FeatureItem(
              Icons.groups_rounded,
              "Member",
              "Management",
            ),
          ),
          _Divider(),

          Expanded(
            child: _FeatureItem(
              Icons.calendar_month_rounded,
              "Attendance",
              "Tracking",
            ),
          ),
          _Divider(),

          Expanded(
            child: _FeatureItem(
              Icons.account_balance_wallet_rounded,
              "Payment",
              "Management",
            ),
          ),
          _Divider(),

          Expanded(
            child: _FeatureItem(
              Icons.notifications_active_rounded,
              "Expiry",
              "Alerts",
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: VerticalDivider(
        color: Colors.grey.shade300,
        thickness: 1,
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title1;
  final String title2;

  const _FeatureItem(
      this.icon,
      this.title1,
      this.title2,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Color(0xff6C3EF4),
          size: 24,
        ),

        SizedBox(height: 4),

        Text(
          title1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),

        Text(
          title2,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}