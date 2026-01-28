import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../components/home_top_bar.dart';
import '../components/home_modal_sheet.dart';
import '../components/bottom_nav_bar.dart';
import '../components/location_permission_modal.dart';
import '../screens/ride_screen.dart';
import '../screens/wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final MapController _mapController = MapController();

  int _currentIndex = 0;
  bool _locationLoading = false;

  final LatLng _currentLocation = const LatLng(6.5244, 3.3792);

  // ---------------- INIT ----------------

  @override
  void initState() {
    super.initState();

    /// Show location modal AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((ctx) {
      _showLocationPermissionModal();
    });
  }

  // ---------------- LOCATION MODAL ----------------

  void _showLocationPermissionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, 
      barrierColor: Colors.lightBlue.withValues(alpha: 12), 
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter, 
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: LocationPermissionModal(
              loading: _locationLoading,
              onAllow: _requestLocationPermission,
              onLater: () => Navigator.pop(context),
            ),
          ),
        );
      },
    );
  }


  Future<void> _requestLocationPermission() async {
    setState(() => _locationLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _locationLoading = false);
      Navigator.pop(context);
    }
  }

  // ---------------- TAB HANDLING ----------------

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAIN CONTENT (MAP + OTHER TABS)
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildHomeMap(),
              RideScreen(),
              WalletScreen(),
            ],
          ),

          /// TOP BAR
          if (_currentIndex != 2 && _currentIndex != 1) // hide in Wallet
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: HomeTopBar(),
          ),

          /// HOME DRAGGABLE SHEET (ONLY HOME TAB)
          if (_currentIndex == 0)
            Positioned(
             left: 16,
              right: 16,
              bottom: 70,
              top: 150,
              child: DraggableScrollableSheet(
                initialChildSize: 0.35,
                minChildSize: 0.35,
                maxChildSize: 0.85,
                snap: true,
                snapSizes: const [0.35, 0.65],
                builder: (context, scrollController) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 90),
                    child: HomeModalSheet(
                      scrollController: scrollController,
                    ),
                  );
                },
              ),
            ),

          /// BOTTOM NAV BAR
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: BottomNavBar(
              currentIndex: _currentIndex,
              onTabChanged: _onTabChanged,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- MAP ----------------

  Widget _buildHomeMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation,
        initialZoom: 15,
        interactionOptions: const InteractionOptions(
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
              point: _currentLocation,
              width: 40,
              height: 60,
              alignment: Alignment.topCenter,
              child: _buildLocationMarker(),
            ),
          ],
        ),
      ],
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
