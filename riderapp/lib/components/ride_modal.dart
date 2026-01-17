import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class RideModal extends ConsumerStatefulWidget {
  final String fromLocation; // dynamic from map
  final String? toLocation;
  final ScrollController scrollController;

  const RideModal({
    super.key,
    required this.fromLocation,
    this.toLocation,
    required this.scrollController,
  });

  @override
  ConsumerState<RideModal> createState() => _RideModalState();
}

class _RideModalState extends ConsumerState<RideModal> {
  bool _searchExpanded = false;

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationProvider);

    return Stack(
      children: [
        /// Modal content
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80), // leave space for button
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                _dragHandle(),
                const SizedBox(height: 12),
                _searchExpanded
                    ? _buildExpandedContent(locations)
                    : _buildInitialContent(),
              ],
            ),
          ),
        ),

        /// Confirm Order Button (sticks to bottom)
        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: SizedBox(
            height: 52,
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
                'Confirm Order',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dragHandle() => Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(153),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  Widget _buildInitialContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Select Pick Up Location',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Location + Search Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.fromLocation, // dynamic from map
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _searchExpanded = true),
                child: Image.asset(
                  'images/search_icon.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Price info
          Row(
            children: [
              Text(
                'Mid Car -',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '#3500',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );

  Widget _buildExpandedContent(List locations) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search your pick up location',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // From location row (dynamic from map)
          Row(
            children: [
              Image.asset('images/search_icon.png', width: 24, height: 24),
              const SizedBox(width: 8),
              Text(
                widget.fromLocation,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            'Recent Locations',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          if (locations.isEmpty)
            const Center(
              child: Text(
                'No recent locations',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...locations.map((location) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(39),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location['name'] ?? '',
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(location['address'] ?? '',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              );
            }),
        ],
      );
}
