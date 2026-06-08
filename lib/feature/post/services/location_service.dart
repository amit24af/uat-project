import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../domain/entities/post_location.dart';

class LocationService {
  final String _apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';

  Future<PostLocation> getMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Lokacijski servis nije uključen.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Dozvola za lokaciju odbijena.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Dozvola za lokaciju trajno odbijena. Omogući je u postavkama.");
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=${position.latitude},${position.longitude}'
          '&key=$_apiKey',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    String displayName = 'Nepoznata lokacija';
    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      displayName = data['results'][0]['formatted_address'];
    }

    return PostLocation(
      displayName: displayName,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<List<PostLocation>> searchLocations(String query) async {
    if (query.trim().length < 2) return [];

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(query)}'
          '&key=$_apiKey',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['status'] != 'OK') return [];

    final predictions = data['predictions'] as List;
    final List<PostLocation> locations = [];

    for (final p in predictions.take(5)) {
      final placeId = p['place_id'];
      final description = p['description'];
      final coords = await _getCoordinatesFromPlaceId(placeId);
      if (coords != null) {
        locations.add(PostLocation(
          displayName: description,
          latitude: coords[0],
          longitude: coords[1],
        ));
      }
    }

    return locations;
  }

  Future<List<double>?> _getCoordinatesFromPlaceId(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=geometry'
          '&key=$_apiKey',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final loc = data['result']['geometry']['location'];
      return [loc['lat'].toDouble(), loc['lng'].toDouble()];
    }
    return null;
  }
}