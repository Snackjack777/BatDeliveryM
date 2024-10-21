import 'dart:developer';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class GPSandMapPage extends StatefulWidget {
  const GPSandMapPage({super.key});

  @override
  State<GPSandMapPage> createState() => _GPSandMapPageState();
}

class _GPSandMapPageState extends State<GPSandMapPage> {
  LatLng? currentLocation;
  LatLng? tappedLocation;
  final MapController mapController = MapController();
  final double zoomIncrement = 1.0;

  // Define custom points
  final LatLng point1 = LatLng(16.2467, 103.2521); // First custom point
  final LatLng point2 = LatLng(16.2475, 103.2535); // Second custom point

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        mapController.move(currentLocation!, 17.0); // Move map center to current location
      });
    } catch (e) {
      log("Error getting location: $e");
      _showErrorSnackbar("Unable to get current location.");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _zoomIn() {
    final currentZoom = mapController.zoom;
    mapController.move(currentLocation ?? LatLng(16.2467, 103.2521), currentZoom + zoomIncrement);
  }

  void _zoomOut() {
    final currentZoom = mapController.zoom;
    if (currentZoom > 1) { // Ensure the zoom level does not go below 1
      mapController.move(currentLocation ?? LatLng(16.2467, 103.2521), currentZoom - zoomIncrement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS and Map'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: currentLocation ?? LatLng(16.2467, 103.2521), // Default center if currentLocation is null
          zoom: 17.0,
          onTap: (tapPosition, point) {
            setState(() {
              tappedLocation = point; // Store tapped location
            });
            log('Tapped location: Latitude ${point.latitude}, Longitude ${point.longitude}'); // Log tapped location
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (currentLocation != null) _buildMarker(currentLocation!, Colors.red),
          if (tappedLocation != null) _buildMarker(tappedLocation!, Colors.blue),
          // Add custom markers
          _buildMarker(point1, Colors.green),
          _buildImageMarker(point2, 'assets/images/riderpic.png'), // Use image for point2
          // Add polyline to connect the points
          PolylineLayer(
            polylines: [
              Polyline(
                points: [point1, point2],
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _zoomIn,
            child: const Icon(Icons.add),
            tooltip: 'Zoom In',
          ),
          const SizedBox(height: 10), // Spacing between buttons
          FloatingActionButton(
            onPressed: _zoomOut,
            child: const Icon(Icons.remove),
            tooltip: 'Zoom Out',
          ),
        ],
      ),
    );
  }

  MarkerLayer _buildMarker(LatLng point, Color color) {
    return MarkerLayer(
      markers: [
        Marker(
          point: point,
          builder: (ctx) => Icon(
            Icons.location_on,
            color: color,
            size: 40,
          ),
        ),
      ],
    );
  }

  MarkerLayer _buildImageMarker(LatLng point, String assetImage) {
    return MarkerLayer(
      markers: [
        Marker(
          point: point,
          builder: (ctx) => Image.asset(
            assetImage,
            width: 40, // Adjust width as necessary
            height: 40, // Adjust height as necessary
          ),
        ),
      ],
    );
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
