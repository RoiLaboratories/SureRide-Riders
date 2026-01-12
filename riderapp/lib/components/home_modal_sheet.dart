import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/location_manager.dart';
import 'recent_location_item.dart';

class HomeModalSheet extends StatefulWidget {
  const HomeModalSheet({super.key});

  @override
  State<HomeModalSheet> createState() => _HomeModalSheetState();
}

class _HomeModalSheetState extends State<HomeModalSheet> {
  List<Map<String, dynamic>> recentLocations = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentLocations();
    // Add listener to LocationManager
    LocationManager().addListener(_onLocationsUpdated);
  }

  void _onLocationsUpdated() {
    // Refresh locations when notified by LocationManager
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      _loadRecentLocations();
    }
  }

  Future<void> _loadRecentLocations() async {
    try {
      // Use LocationManager to load locations
      final loadedLocations = await LocationManager().getRecentLocations();
      
      setState(() {
        recentLocations = loadedLocations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading recent locations: $e');
      setState(() {
        recentLocations = [];
        _isLoading = false;
      });
    }
  }

  void _refreshLocations() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    _loadRecentLocations();
  }

  void _clearAllLocations() async {
    try {
      await LocationManager().clearAllLocations();
      // No need to call _loadRecentLocations() because LocationManager will notify listeners
    } catch (e) {
      print('Error clearing locations: $e');
    }
  }

  @override
  void dispose() {
    // Remove listener from LocationManager
    LocationManager().removeListener(_onLocationsUpdated);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasRecents = recentLocations.isNotEmpty && !_isLoading;

    if (!hasRecents && !_isLoading) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _floatingSearchBar(),
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.25,
      maxChildSize: 0.65,
      snap: true,
      snapSizes: const [0.25, 0.65],
      builder: (context, scrollController) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            children: [
              // DRAGGABLE HANDLE
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: _searchBar(),
              ),
              
              // Recent Locations Header with actions
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Locations',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        if (recentLocations.isNotEmpty && !_isLoading)
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red[400],
                              size: 22,
                            ),
                            onPressed: _clearAllLocations,
                            tooltip: 'Clear all',
                          ),
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.blue,
                            size: 22,
                          ),
                          onPressed: _refreshLocations,
                          tooltip: 'Refresh',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Loading indicator or list
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                )
              else if (recentLocations.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_history,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No recent destinations',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your recent ride destinations will appear here',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recentLocations.length,
                    itemBuilder: (context, index) {
                      final item = recentLocations[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RecentLocationItem(
                          name: item['name'] ?? 'Destination',
                          address: item['address'] ?? '',
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/route',
                              arguments: {
                                'prefilledDestination': item['address'],
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Floating search bar
  Widget _floatingSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: _searchBar(),
    );
  }

  // Search bar
  Widget _searchBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/route'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current location",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Where to?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.near_me,
                    size: 18,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Now",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}