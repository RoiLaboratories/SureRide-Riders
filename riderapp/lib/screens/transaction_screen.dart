import 'package:flutter/material.dart';
import '../components/transaction_tile.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            TransactionTile(
              title: 'Payment to Ahmed',
              time: '2:30 PM · Fri, 21 Jun 2025',
              amount: '-₦435.54',
              amountColor: Colors.red,
              iconBg: Color(0xFFEFF3F6),
              icon: Icons.person,
            ),
            TransactionTile(
              title: 'Wallet Top Up',
              time: '2:30 PM · Fri, 21 Jun 2025',
              amount: '+₦435.54',
              amountColor: Colors.green,
              iconBg: Color(0xFFDFF5E1),
              icon: Icons.arrow_downward,
            ),
            TransactionTile(
              title: 'Transfer to Osi',
              time: '2:30 PM · Fri, 21 Jun 2025',
              amount: '-₦435.54',
              amountColor: Colors.red,
              iconBg: Color(0xFFFBE4E2),
              icon: Icons.arrow_upward,
            ),
          ],
        ),
      ),
    );
  }
}
