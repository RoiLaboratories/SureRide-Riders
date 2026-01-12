import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 70, // Increased height
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(35), // More rounded
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // This makes the row only as wide as needed
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Home Tab
            _buildNavItem(
              index: 0,
              icon: _selectedIndex == 0 
                  ? Icons.home_rounded 
                  : Icons.home_outlined,
              label: 'Home',
            ),
            
            const SizedBox(width: 20), // Reduced spacing between icons
            
            // Ride Tab
            _buildNavItem(
              index: 1,
              icon: _selectedIndex == 1 
                  ? Icons.directions_car_rounded 
                  : Icons.directions_car_outlined,
              label: 'Ride',
            ),
            
            const SizedBox(width: 20), // Reduced spacing between icons
            
            // Wallet Tab
            _buildNavItem(
              index: 2,
              icon: _selectedIndex == 2 
                  ? Icons.account_balance_wallet_rounded 
                  : Icons.account_balance_wallet_outlined,
              label: 'Wallet',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), 
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
              size: 28, // Increased icon size
            ),
            if (isSelected) ...[
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}