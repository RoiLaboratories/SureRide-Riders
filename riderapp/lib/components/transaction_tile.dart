import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String time;
  final String amount;
  final Color amountColor;
  final Color iconBg;
  final IconData icon;

  const TransactionTile({
    super.key,
    required this.title,
    required this.time,
    required this.amount,
    required this.amountColor,
    required this.iconBg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconBg,
            child: Icon(icon, color: amountColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
