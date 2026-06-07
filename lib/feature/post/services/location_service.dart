import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../domain/entities/post_location.dart';

class LocationService {


  Future<PostLocation> getMyLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final displayName = await _getDisplayName(
      position.latitude,
      position.longitude,
    );

    return PostLocation(
      displayName: displayName,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }


  Future<PostLocation> getLocationFromAddress(String address) async {
    final locations = await locationFromAddress(address);
    if (locations.isEmpty) throw Exception("Location not found.");
    return PostLocation(
      displayName: address,
      latitude: locations.first.latitude,
      longitude: locations.first.longitude,
    );
  }


  Future<String> _getDisplayName(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return [place.locality, place.country]
            .where((e) => e != null && e.isNotEmpty)
            .join(", ");
      }
    } catch (_) {}

    return "${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
  }
}