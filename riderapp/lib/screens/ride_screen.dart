import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/ride_modal.dart';
import '../components/ride_top_bar.dart';
import '../providers/location_provider.dart';

class RideScreen extends ConsumerStatefulWidget {
  /// Optionally pass a destination if selected from the route screen
  final String? selectedDestination;

  const RideScreen({super.key, this.selectedDestination, required Map<dynamic, dynamic> rideData});

  @override
  ConsumerState<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends ConsumerState<RideScreen> {

  @override
  Widget build(BuildContext context) {
    // Get the current user location from provider
    final locations = ref.watch(locationProvider);

    // fromLocation: first recent location, fallback to 'Your Location'
    final String fromLocation = locations.isNotEmpty
        ? locations.first['name'] ?? 'Your Location'
        : 'Your Location';

    // toLocation: selected destination passed from previous screen
    final String? toLocation = widget.selectedDestination;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content (map placeholder)
            Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: Text(
                  'Map goes here',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),

            // Top bar with from and to locations
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: RideTopBar(
                fromLocation: fromLocation,
                toLocation: toLocation,
              ),
            ),

            // Bottom draggable modal
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return RideModal(
                  fromLocation: fromLocation,
                  toLocation: toLocation,
                  scrollController: scrollController,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}