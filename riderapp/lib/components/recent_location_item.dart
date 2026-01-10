import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentLocationItem extends StatelessWidget {
  final String name;
  final String address;

  const RecentLocationItem({
    super.key,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.location_on,
          color: Colors.black,
          size: 20,
        ),
      ),
      title: Text(
        name,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        address,
        style: GoogleFonts.poppins(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      onTap: () {
        // Handle location selection
      },
    );
  }
}