import 'package:flutter_riverpod/legacy.dart';
import '../utils/location_manager.dart';

/// Location state = list of recent locations
final locationProvider =
    StateNotifierProvider<LocationNotifier, List<Map<String, dynamic>>>(
  (ref) => LocationNotifier(),
);

class LocationNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  LocationNotifier() : super([]) {
    _init();
  }

  final LocationManager _manager = LocationManager();

  Future<void> _init() async {
    state = await _manager.getRecentLocations();

    // Bridge LocationManager → Riverpod
    _manager.addListener(_refresh);
  }

  Future<void> _refresh() async {
    state = await _manager.getRecentLocations();
  }

  /// Public API (optional helpers)
  Future<void> addLocation(String name, String address) async {
    await _manager.addRecentLocation(name, address);
  }

  Future<void> removeLocation(String address) async {
    await _manager.removeLocation(address);
  }

  Future<void> clearAll() async {
    await _manager.clearAllLocations();
  }

  @override
  void dispose() {
    _manager.removeListener(_refresh);
    super.dispose();
  }
}
