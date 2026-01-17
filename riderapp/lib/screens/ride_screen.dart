import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../components/ride_modal.dart';
import '../components/ride_top_bar.dart';
import '../providers/location_provider.dart';

class RideScreen extends ConsumerStatefulWidget {
  final String? selectedDestination;

  const RideScreen({
    super.key,
    this.selectedDestination,
    required Map<dynamic, dynamic> rideData,
  });

  @override
  ConsumerState<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends ConsumerState<RideScreen> {
  LatLng? _currentLatLng;
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    // Get initial location from provider
    final locations = ref.read(locationProvider);
    if (locations.isNotEmpty &&
        locations.first['lat'] != null &&
        locations.first['lng'] != null) {
      _currentLatLng = LatLng(
        double.parse(locations.first['lat'].toString()),
        double.parse(locations.first['lng'].toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationProvider);

    // fromLocation: first recent location, fallback to 'Your Location'
    final String fromLocation = locations.isNotEmpty
        ? locations.first['name'] ?? 'Your Location'
        : 'Your Location';

    final String? toLocation = widget.selectedDestination;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLatLng!,
                initialZoom: 15,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                    'https://api.maptiler.com/maps/dataviz-light/{z}/{x}/{y}.png?key=UY3s7vp83IS8KCNXj05u',
                  tileDimension: 512,
                  zoomOffset: -1,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point:_currentLatLng!,
                      width: 40,
                      height: 60,
                      alignment: Alignment.topCenter,
                      child: _buildLocationMarker(),
                    ),
                  ],
                ),
              ],
            ),

            // Top bar with from/to locations
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
              minChildSize: 0.35,
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
  Widget _buildLocationMarker() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        'images/location_pointer.png',
        width: 54,
        height: 54,
      ),
    );
  }
}
