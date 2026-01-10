import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../components/home_modal_sheet.dart';
import '../components/home_top_bar.dart';
import '../components/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LatLng _currentLocation = const LatLng(6.5244, 3.3792);
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Map using flutter_map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation, // Changed from 'center'
              initialZoom: 14, // Changed from 'zoom'
              interactionOptions: const InteractionOptions( // Changed from 'interactiveFlags'
                flags: InteractiveFlag.all,
              ),
              maxZoom: 18,
              minZoom: 10,
            ),
            children: [
              // OpenStreetMap Tile Layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                subdomains: const ['a', 'b', 'c'],
              ),
              
              // Current Location Marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                ],
              ),
              
              // Attribution
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => {},
                  ),
                ],
              ),
            ],
          ),

          // Top Bar with User Avatar and Location
          const Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: HomeTopBar(),
          ),

          // Bottom Modal Sheet - Now wrapped properly
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: HomeModalSheet(),
            ),
          ),
        ],
      ),

      // Floating Bottom Navigation Bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}