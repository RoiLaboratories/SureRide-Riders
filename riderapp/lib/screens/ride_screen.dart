import 'package:flutter/material.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  bool showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Rides', style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _Tabs(
            showUpcoming: showUpcoming,
            onChanged: (val) => setState(() => showUpcoming = val),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: showUpcoming ? const UpcomingRides() : const PastRides(),
          ),
        ],
      ),
    );
  }
}

// ================== tabs.dart ==================
class _Tabs extends StatelessWidget {
  final bool showUpcoming;
  final ValueChanged<bool> onChanged;

  const _Tabs({required this.showUpcoming, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _tab('Upcoming Rides', showUpcoming, () => onChanged(true)),
          _tab('Past', !showUpcoming, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _tab(String title, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1F7BFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================== upcoming_rides.dart ==================
class UpcomingRides extends StatelessWidget {
  const UpcomingRides({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        RideTile(
          date: 'Sun, 31 Aug 2025',
          route: 'Lagos Street, Benin City',
          price: '₦1,500.00',
          trailingIcon: Icons.close,
        ),
      ],
    );
  }
}

// ================== past_rides.dart ==================
class PastRides extends StatelessWidget {
  const PastRides({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        RideTile(
          date: 'Sun, 31 Aug 2025',
          route: 'Lagos Street, Benin City',
          price: '₦1,500.00',
          status: 'Completed',
          statusColor: Colors.green,
        ),
        RideTile(
          date: 'Sun, 31 Aug 2025',
          route: 'Lagos Street, Benin City',
          price: '₦1,500.00',
          status: 'Cancelled',
          statusColor: Colors.red,
        ),
      ],
    );
  }
}

// ================== ride_tile.dart ==================
class RideTile extends StatelessWidget {
  final String date;
  final String route;
  final String price;
  final String? status;
  final Color? statusColor;
  final IconData? trailingIcon;

  const RideTile({
    super.key,
    required this.date,
    required this.route,
    required this.price,
    this.status,
    this.statusColor,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(width: 8),
                    if (status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor!.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(status!, style: TextStyle(fontSize: 10, color: statusColor)),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(route, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: Color(0xFF1F7BFF), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (trailingIcon != null)
            Icon(trailingIcon, color: Colors.black38),
          if (status != null)
            const Icon(Icons.refresh, color: Colors.black38),
        ],
      ),
    );
  }
}

// ================== ride_completed_screen.dart ==================
class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ride Completed', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('Map Preview')),
            ),
            const SizedBox(height: 16),
            _location('Lagos Street, Benin City', Colors.blue),
            _location('Ring Road Bus Terminal, Benin City', Colors.purple),
            const Divider(height: 32),
            const Text('Payment', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _row('Cash Payment', '₦1,500.00'),
            const SizedBox(height: 8),
            _row('Total', '₦1,500.00', highlight: true),
            const Spacer(),
            Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(child: Text('Rebook', style: TextStyle(color: Colors.black54))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _location(String text, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _row(String left, String right, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: TextStyle(color: highlight ? Colors.black : Colors.black54)),
        Text(right, style: TextStyle(color: highlight ? const Color(0xFF1F7BFF) : Colors.black)),
      ],
    );
  }
}

