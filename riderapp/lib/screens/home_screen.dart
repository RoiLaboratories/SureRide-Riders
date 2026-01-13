import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../components/home_modal_sheet.dart';
import '../components/home_top_bar.dart';
import '../components/location_permission_modal.dart';
import '../components/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng _currentLocation = const LatLng(6.5244, 3.3792);
  final MapController _mapController = MapController();
  bool _showLocationModal = true;
  bool _isLoadingLocation = false;
  // ignore: unused_field
  final bool _isMapLoading = false;

  @override
  void initState() {
    super.initState();
    // Don't auto-get location on web
    WidgetsBinding.instance.addPostFrameCallback((ctx) {
      setState(() {
        _showLocationModal = true;
      });
    });
  }

  Future<void> _getDeviceLocation() async {
    try {
      // Skip for web platform or if already loading
      if (_isLoadingLocation) return;
      
      setState(() {
        _isLoadingLocation = true;
      });

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation, 14);
      
    } catch (e) {
      print('Error getting device location: $e');
      // Keep default location
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location services'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isLoadingLocation = false;
          _showLocationModal = false;
        });
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied. Please enable in settings.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Permission granted, get current location
        await _getDeviceLocation();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
        _showLocationModal = false;
      });
    }
  }

  Widget _buildMapLocationIcon() {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.lightBlue.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Map
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 14,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                maxZoom: 18,
                minZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                    'https://api.maptiler.com/maps/dataviz-light/{z}/{x}/{y}.png?key=UY3s7vp83IS8KCNXj05u',
                  userAgentPackageName: 'com.example.app',
                  tileDimension: 512,
                  zoomOffset: -1,
                ),
                
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      width: 60,
                      height: 60,
                      child: _buildMapLocationIcon(),
                    ),
                  ],
                ),
                
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
          ),

          // Top Bar
          const Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: HomeTopBar(),
          ),

          // Home Modal Sheet - Positioned higher
          Positioned(
            left: 0,
            right: 0,
            bottom: 40, // Space for floating nav bar
            child: HomeModalSheet(),
          ),

          // Location Permission Modal
          if (_showLocationModal)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: BottomNavBar(), 
          ),

            
          if (_showLocationModal)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LocationPermissionModal(
                      loading: _isLoadingLocation,
                      onAllow: _requestLocationPermission,
                      onLater: () {
                        setState(() {
                          _showLocationModal = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}