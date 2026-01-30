import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../components/ride_modal.dart';
import '../components/ride_top_bar.dart';

class BookRideScreen extends StatefulWidget {
  final String? selectedDestination;

  const BookRideScreen({
    super.key,
    this.selectedDestination,
  });

  @override
  State<BookRideScreen> createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<BookRideScreen> {
  late final MapController _mapController;

  // Hard-coded locations
  final LatLng _fromLatLng = const LatLng(6.5244, 3.3792); // Lagos Island
  final LatLng _toLatLng   = const LatLng(6.4654, 3.4064); // Ikeja

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _fromLatLng,
                initialZoom: 13,
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
                    // FROM marker
                    Marker(
                      point: _fromLatLng,
                      width: 40,
                      height: 60,
                      alignment: Alignment.topCenter,
                      child: _buildLocationMarker(),
                    ),

                    // TO marker
                    Marker(
                      point: _toLatLng,
                      width: 40,
                      height: 60,
                      alignment: Alignment.topCenter,
                      child: _buildDestinationMarker(),
                    ),
                  ],
                ),
              ],
            ),

            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: RideTopBar(
                fromLocation: 'Lagos Island',
                toLocation: widget.selectedDestination ?? 'Ikeja',
              ),
            ),

            DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.65,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return RideModal(scrollController: scrollController);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationMarker() {
    return Image.asset(
      'images/location_pointer.png',
      width: 54,
      height: 54,
    );
  }

  Widget _buildDestinationMarker() {
    return Image.asset(
      'images/destination_pointer.png',
      width: 54,
      height: 54,
    );
  }
}
