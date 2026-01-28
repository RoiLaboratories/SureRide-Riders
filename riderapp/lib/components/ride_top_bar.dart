import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RideTopBar extends StatelessWidget {
  final String fromLocation;
  final String? toLocation;

  const RideTopBar({
    super.key,
    required this.fromLocation,
    this.toLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Close button
        GestureDetector(
          onTap: () {
            // Navigate back to HomeScreen
            Navigator.of(context).pop();
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(64),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),

        const SizedBox(width: 12),

        /// Location / Destination container
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(39),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // From
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fromLocation, 
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Arrow separator
                const Icon(
                  Icons.arrow_right,
                  size: 16,
                  color: Colors.black87,
                ),

                // To
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: toLocation != null ? Colors.purple : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    toLocation ?? '•••',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: toLocation != null ? Colors.purple : Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
