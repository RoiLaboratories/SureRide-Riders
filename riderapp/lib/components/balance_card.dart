import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '₦1,200.00',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0A84FF),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Wallet Balance',
                style: TextStyle(
                  color: Color(0xFF0A84FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 6),
              Icon(
                Icons.remove_red_eye_outlined,
                size: 18,
                color: Color(0xFF0A84FF),
              )
            ],
          )
        ],
      ),
    );
  }
}
