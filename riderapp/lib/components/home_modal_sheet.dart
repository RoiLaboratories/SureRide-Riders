import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recent_location_item.dart';

class HomeModalSheet extends StatefulWidget {
  const HomeModalSheet({super.key});

  @override
  State<HomeModalSheet> createState() => _HomeModalSheetState();
}

class _HomeModalSheetState extends State<HomeModalSheet> {
  final List<Map<String, String>> recentLocations = [
    {'name': 'Work', 'address': 'Victoria Island, Lagos'},
    {'name': 'Home', 'address': 'Lekki Phase 1, Lagos'},
    {'name': 'Gym', 'address': 'Ikoyi, Lagos'},
    {'name': 'Mall', 'address': 'Ikeja, Lagos'},
  ];

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.25,
      maxChildSize: 0.65,
      snap: true,
      snapSizes: const [0.25, 0.65],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Draggable Handle
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
              
              // Search Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/route');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Where are you going today?',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Recent Locations Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Locations',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Recent Locations List
              if (_isExpanded || recentLocations.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: recentLocations.length,
                    itemBuilder: (context, index) {
                      return RecentLocationItem(
                        name: recentLocations[index]['name']!,
                        address: recentLocations[index]['address']!,
                      );
                    },
                  ),
                ),
              
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}