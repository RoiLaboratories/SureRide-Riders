import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class RideModal extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const RideModal({
    super.key,
    required this.scrollController,
  });

  @override
  ConsumerState<RideModal> createState() => _RideModalState();
}

class _RideModalState extends ConsumerState<RideModal> {
  int selectedRide = 0; 
  int selectedPayment = 0; 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 25),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _dragHandle(),
          const SizedBox(height: 12),

          /// MAIN CONTENT
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildRideOptions(),
                const SizedBox(height: 20),
                _buildPaymentOptions(),
              ],
            ),
          ),

          /// CONTINUE BUTTON
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// DRAG HANDLE
  Widget _dragHandle() => Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  /// ================= RIDE OPTIONS SECTION =================
  Widget _buildRideOptions() {
    return Column(
      children: [
        _rideCard(
          index: 0,
          title: "Regular",
          subtitle: "Mid-size Cars",
          time: "11 mins",
          seats: "4",
          price: "₦3,500",
          oldPrice: "₦4,500",
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _rideCard(
          index: 1,
          title: "VIP",
          subtitle: "Modern Car Models",
          time: "5 mins",
          seats: "2",
          price: "₦7,500",
          oldPrice: "₦9,500",
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _rideCard({
    required int index,
    required String title,
    required String subtitle,
    required String time,
    required String seats,
    required String price,
    required String oldPrice,
    required Color color,
  }) {
    final isSelected = selectedRide == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedRide = index);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Car image placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                index == 0
                 ? 'images/regular.png'
                 : 'images/vip.png',
                width: 60,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 12),

            /// Ride info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text("$time • ",
                          style: const TextStyle(fontSize: 12)),
                      Icon(Icons.person, size: 14, color: Colors.grey),
                      Text(" $seats",
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            /// Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  oldPrice,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= PAYMENT OPTIONS SECTION =================
  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Options",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),

        _paymentTile(
          index: 0,
          imagePath: "images/cash.png",
          title: "Cash",
          subtitle: "Pay with cash",
        ),

        _paymentTile(
          index: 1,
          imagePath: "images/wallet2.png",
          title: "Sureride Wallet",
          subtitle: "Bal: ₦3,000   + Top up wallet",
        ),

        _paymentTile(
          index: 2,
          imagePath: "images/card.png",
          title: "Bank Card",
          subtitle: "5678-2272-2837-2839   + Add debit card",
        ),
      ],
    );
  }

  Widget _paymentTile({
    required int index,
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        imagePath,
        width: 28,
        height: 28,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
      ),
      trailing: Radio<int>(
        value: index,
        groupValue: selectedPayment,
        onChanged: (value) {
          setState(() => selectedPayment = value!);
        },
        activeColor: Colors.blue,
      ),
    );
  }
}
