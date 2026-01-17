import 'package:flutter/material.dart';
import '../components/balance_card.dart';
import '../components/transaction_tile.dart';
import '../components/wallet_action_button.dart';
import '../screens/transaction_screen.dart';
import 'package:flutter/services.dart';


class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Header
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Wallet',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Paystack–Titan 98291029281',
                      style: TextStyle(
                        color: Color(0xFF0A84FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          const ClipboardData(text: '98291029281'),
                        );

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 2), 
                        child: Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: Color(0xFF0A84FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

              const SizedBox(height: 24),

              /// Balance Card
              const BalanceCard(),

              const SizedBox(height: 28),

              /// Action Buttons
              Row(
                children: [
                  Expanded(
                    child: WalletActionButton(
                      title: 'Top Up',
                      color: Color(0xFF0A84FF),
                      arrowAsset: 'images/top_up.png',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WalletActionButton(
                      title: 'Transfer',
                      color: Color(0xFFC800FF),
                      arrowAsset: 'images/transfer.png',
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => TransactionScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF0A84FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Transactions Preview
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}
