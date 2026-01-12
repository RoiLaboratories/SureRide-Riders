import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RideScreen extends StatefulWidget {
  final Map<String, dynamic> rideData;

  const RideScreen({super.key, required this.rideData});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  LatLng _currentLocation = const LatLng(6.5244, 3.3792);
  LatLng _destinationLocation = const LatLng(6.5244, 3.3792);
  final MapController _mapController = MapController();
  bool _isLoading = false;
  String _selectedPaymentMethod = 'Cash';
  bool _showPaymentDropdown = false;
  
  // Car options with prices
  final List<Map<String, dynamic>> _carOptions = [
    {
      'name': 'Economy',
      'icon': Icons.directions_car,
      'price': '₦1,200',
      'eta': '5 min',
      'color': Colors.blue,
    },
    {
      'name': 'Comfort',
      'icon': Icons.airport_shuttle,
      'price': '₦1,800',
      'eta': '7 min',
      'color': Colors.green,
    },
    {
      'name': 'Premium',
      'icon': Icons.local_taxi,
      'price': '₦2,500',
      'eta': '10 min',
      'color': Colors.purple,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocations();
    _centerMapOnRoute();
  }

  void _initializeLocations() {
    // Simulated destination coordinates (you should use actual geocoding here)
    // In real app, convert address to coordinates
    _destinationLocation = const LatLng(6.5254, 3.3892); // Slightly different from start
  }

  void _centerMapOnRoute() {
    Future.delayed(const Duration(milliseconds: 500), () {
      // Calculate center between current and destination
      final centerLat = (_currentLocation.latitude + _destinationLocation.latitude) / 2;
      final centerLng = (_currentLocation.longitude + _destinationLocation.longitude) / 2;
      final centerPoint = LatLng(centerLat, centerLng);
      
      // Calculate zoom to show both points
      _mapController.move(centerPoint, 13);
    });
  }

  // Generate route points (simulated - in real app use routing API)
  List<LatLng> _generateRoutePoints() {
    final points = <LatLng>[];
    
    // Start point
    points.add(_currentLocation);
    
    // Generate intermediate points (simulated route)
    final steps = 20;
    final latStep = (_destinationLocation.latitude - _currentLocation.latitude) / steps;
    final lngStep = (_destinationLocation.longitude - _currentLocation.longitude) / steps;
    
    for (int i = 1; i < steps; i++) {
      points.add(LatLng(
        _currentLocation.latitude + (latStep * i),
        _currentLocation.longitude + (lngStep * i),
      ));
    }
    
    // End point
    points.add(_destinationLocation);
    
    return points;
  }

  Widget _buildCarOption(Map<String, dynamic> car) {
    return GestureDetector(
      onTap: () {
        // Handle car selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected ${car['name']} for ${car['price']}'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Car Icon with color
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: car['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                car['icon'] as IconData,
                color: car['color'],
                size: 28,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Car details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${car['eta']} away',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Price
            Text(
              car['price'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDropdown() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Selected payment method
          ListTile(
            onTap: () {
              setState(() {
                _showPaymentDropdown = !_showPaymentDropdown;
              });
            },
            leading: Icon(
              _selectedPaymentMethod == 'Cash' 
                ? Icons.money 
                : _selectedPaymentMethod == 'Wallet'
                  ? Icons.account_balance_wallet
                  : Icons.account_balance,
              color: Colors.blue,
            ),
            title: Text(
              'Pay with $_selectedPaymentMethod',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              _showPaymentDropdown ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey[600],
            ),
          ),
          
          // Dropdown options
          if (_showPaymentDropdown)
            Column(
              children: [
                const Divider(height: 0),
                _buildPaymentOption('Cash', Icons.money),
                _buildPaymentOption('Wallet', Icons.account_balance_wallet),
                _buildPaymentOption('Bank Transfer', Icons.account_balance),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    return ListTile(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
          _showPaymentDropdown = false;
        });
      },
      leading: Icon(
        icon,
        color: Colors.grey[600],
      ),
      title: Text(
        'Pay with $method',
        style: TextStyle(
          color: _selectedPaymentMethod == method ? Colors.blue : Colors.grey[700],
          fontWeight: _selectedPaymentMethod == method ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: _selectedPaymentMethod == method
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
    );
  }

  Widget _buildBookingModal() {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      snap: true,
      snapSizes: const [0.45, 0.8],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              
              // Ride summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Route summary
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 30,
                              color: Colors.grey[300],
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.rideData['currentLocation'] ?? 'Your location',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.rideData['destination'] ?? 'Destination',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Select car type
                    const Text(
                      'Select your ride',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Car options list
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    ..._carOptions.map(_buildCarOption).toList(),
                    
                    // Payment method dropdown
                    _buildPaymentDropdown(),
                    
                    // Book button
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle booking
                          setState(() {
                            _isLoading = true;
                          });
                          
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ride booked successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context); // Return to home
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Confirm Booking',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routePoints = _generateRoutePoints();
    
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
                // Map tiles
                TileLayer(
                  urlTemplate:
                    'https://api.maptiler.com/maps/dataviz-light/{z}/{x}/{y}.png?key=UY3s7vp83IS8KCNXj05u',
                  userAgentPackageName: 'com.example.app',
                  tileDimension: 512,
                  zoomOffset: -1,
                ),
                
                // Route line with gradient effect
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: Colors.blue,
                      strokeWidth: 6,
                      gradientColors: [
                        Colors.blue.withOpacity(0.8),
                        Colors.purple.withOpacity(0.8),
                      ],
                    ),
                  ],
                ),
                
                // Start location marker
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      width: 40,
                      height: 40,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    
                    // Destination marker with purple arrow
                    Marker(
                      point: _destinationLocation,
                      width: 50,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          
                          // Inner circle
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple,
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          
                          // Arrow indicator
                          Positioned(
                            top: -5,
                            child: Icon(
                              Icons.arrow_drop_up,
                              color: Colors.purple,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Bottom Booking Modal
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildBookingModal(),
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