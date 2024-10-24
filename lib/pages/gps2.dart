import 'dart:developer';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class GPSandMap2Page extends StatefulWidget {
  const GPSandMap2Page({super.key});

  @override
  State<GPSandMap2Page> createState() => _GPSandMap2PageState();
}

class _GPSandMap2PageState extends State<GPSandMap2Page> {
  LatLng? currentLocation;
  final MapController mapController = MapController();
  final double zoomIncrement = 1.0;

  final LatLng point1 = LatLng(16.2467, 103.2521);

  final List<LatLng> points = [
    // LatLng(16.2475, 103.2535),
    // LatLng(16.2480, 103.2540),
    // LatLng(16.2490, 103.2550),
    LatLng(16.2440, 103.2550),
    LatLng(16.2410, 103.2550),
    LatLng(16.2420, 103.2510),
  ];

  final List<String> ridernumber = [
    'Rider 2651',
    'Rider 5643',
    'Rider 1116',
    // 'Rider 6698',
    // 'Rider 9999',
    // 'Rider 6211',
  ];

  @override
  void initState() {
    super.initState();
    // Uncomment the following line to get the current location on init
    // _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        mapController.move(currentLocation!, 17.0);
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
    mapController.move(currentLocation ?? point1, currentZoom + zoomIncrement);
  }

  void _zoomOut() {
    final currentZoom = mapController.zoom;
    if (currentZoom > 1) {
      mapController.move(
          currentLocation ?? point1, currentZoom - zoomIncrement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS and Map2'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: currentLocation ?? point1,
          zoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          // Add polylines to connect all points to point1 before the markers
          PolylineLayer(
            polylines: _buildPolylines(),
          ),
          // Build markers using the new method, with point1 as a green marker
          _buildMarker(point1, Colors.green), // Green marker for point1
          ..._buildMarkers(), // Build markers for other points
          if (currentLocation != null)
            _buildImageMarker(
                currentLocation!, 'assets/images/riderpic.png', '616'),
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
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _zoomOut,
            child: const Icon(Icons.remove),
            tooltip: 'Zoom Out',
          ),
        ],
      ),
    );
  }

  // Create a single marker for point1
  MarkerLayer _buildMarker(LatLng point, Color color) {
    return MarkerLayer(
      markers: [
        Marker(
            point: point,
            width: 50,
            height: 50,
            builder: (ctx) => ClipOval(
                  child: Container(
                    width: 46, // ขนาดที่ใหญ่กว่ารูปภาพเพื่อแสดงขอบ
                    height: 46, // ขนาดที่ใหญ่กว่ารูปภาพเพื่อแสดงขอบ
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0), // สีพื้นหลังขอบ
                      shape: BoxShape.circle, // รูปทรงกลม
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0), // สีของขอบ
                        width: 3, // ความกว้างของขอบ 3 px
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/poto333.jpg',
                        width: 40, // ขนาดรูปภาพ
                        height: 40, // ขนาดรูปภาพ
                        fit: BoxFit.cover, // ทำให้ภาพเติมเต็มในวงกลม
                      ),
                    ),
                  ),
                )),
      ],
    );
  }

  List<MarkerLayer> _buildMarkers() {
    return points.asMap().entries.map((entry) {
      int index = entry.key;
      LatLng point = entry.value;
      String riderNumber = ridernumber[
          index]; // Get the rider number for the corresponding point
      return _buildImageMarker(
          point, 'assets/images/riderpic.png', riderNumber);
    }).toList();
  }

  MarkerLayer _buildImageMarker(
      LatLng point, String assetImage, String riderNumber) {
    return MarkerLayer(
      markers: [
        Marker(
          point: point,
          height: 100,
          builder: (ctx) => SizedBox(
            width: 40,
            height: 100,
            child: Column(
              children: [
                Container(
                  width: 40,
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // กำหนดสีพื้นหลัง
                  child: Center(
                    // จัดให้ข้อความอยู่กลาง
                    child: Text(
                      riderNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.bold, // ทำให้ข้อความหนา
                      ),
                      textAlign: TextAlign.center, // จัดข้อความให้กลาง
                    ),
                  ),
                ),
                Image.asset(
                  assetImage,
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Polyline> _buildPolylines() {
    List<Polyline> polylines = [];
    for (LatLng point in points) {
      polylines.add(Polyline(
        points: [point1, point], // Connect each point to point1
        color: Colors.blue,
        strokeWidth: 4.0,
      ));
    }
    if (currentLocation != null) {
      polylines.add(Polyline(
        points: [
          point1,
          currentLocation!
        ], // Connect current location to point1
        color: Colors.blue,
        strokeWidth: 4.0,
      ));
    }
    return polylines;
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
