import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lotto/pages/login.dart';
import 'package:latlong2/latlong.dart';

import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isUser = true;

  // Controllers to get text from fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressOrLicenseController =
      TextEditingController();

  LatLng? currentLocation;
  LatLng? tappedLocation;
  final MapController mapController = MapController();
  final double zoomIncrement = 1.0;
  var db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile; 

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image; // อัปเดตตัวแปรภาพ
    });
  }

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        mapController.move(
            currentLocation!, 17.0); // Move map center to current location
      });
    } catch (e) {
      log("Error getting location: $e");
      _showErrorSnackbar("Unable to get current location.");
    }
  }

  // Helper function to check if email is valid
  bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 63, 194),
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 174, 63, 194),
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 250,
                width: 250,
                fit: BoxFit.contain,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Switch for User and Rider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ผู้ใช้',
                              style: TextStyle(color: Colors.purple),
                            ),
                            customSwitch(
                              value: isUser,
                              onChanged: (value) {
                                setState(() {
                                  isUser = value;
                                  addressOrLicenseController
                                      .clear(); // ล้างข้อมูลเมื่อสลับ
                                });
                              },
                            ),
                            const Text(
                              'ไรเดอร์',
                              style: TextStyle(color: Colors.purple),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 75, // ขนาดของวงกลม
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _imageFile != null
                                ? FileImage(File(_imageFile!.path))
                                : null,
                            child: _imageFile == null
                                ? const Icon(Icons.camera_alt,
                                    size: 50, color: Colors.purple)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'ชื่อ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: phoneController,
                          keyboardType:
                              TextInputType.phone, // Set type for phone input
                          decoration: InputDecoration(
                            labelText: 'โทรศัพท์',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                10), // Limit to 10 characters
                          ],
                        ),

                        const SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType
                              .emailAddress, // Set type for email input
                          decoration: InputDecoration(
                            labelText: 'อีเมล์',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true, // Hide text for password
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true, // Hide text for confirm password
                          decoration: InputDecoration(
                            labelText: 'ยืนยันรหัสผ่าน',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        !isUser
                            ? SizedBox(
                                width: double
                                    .infinity, // หรือกำหนดขนาดตามต้องการ เช่น 300.0
                                height: 300.0, // กำหนดความสูงตามที่ต้องการ
                                child:
                                    Map(), // ใส่ Map() ไว้ใน SizedBox เพื่อควบคุมขนาด
                              )
                            : TextField(
                                controller: addressOrLicenseController,
                                decoration: InputDecoration(
                                  labelText: 'ป้ายทะเบียนรถ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 20),
                        // Buttons in Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPages()),
                                );
                                setState(() {
                                  // ล้างข้อมูลทุกช่อง
                                  nameController.clear(); // ล้างชื่อ
                                  phoneController.clear(); // ล้างโทรศัพท์
                                  emailController.clear(); // ล้างอีเมล์
                                  passwordController.clear(); // ล้างรหัสผ่าน
                                  confirmPasswordController
                                      .clear(); // ล้างยืนยันรหัสผ่าน
                                  addressOrLicenseController
                                      .clear(); // ล้างที่อยู่หรือป้ายทะเบียนรถ
                                });
                              },
                              child: const Text(
                                'กลับหน้า Login',
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                register(); // Call register function
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }


void register() async {
  if (!_validateInputs()) return;

  final XFile? image = _imageFile;
  if (image == null) return;

  String email = emailController.text;
  if (await _isEmailAlreadyUsed(db.collection('User'), email)) {
    return; 
  }
    if (await _isEmailAlreadyUsed(db.collection('Rider'), email)) {
    return; 
  }

  String picnamest = await _uploadImage(image);
  if (picnamest.isEmpty) return; 

  if (!isUser) {
    await _registerUser(picnamest);
  } else {
    await _registerRider( picnamest) ;
  }

  _clearInputs();
}

bool _validateInputs() {
  String name = nameController.text;
  String phone = phoneController.text;
  String email = emailController.text;
  String password = passwordController.text;
  String confirmPassword = confirmPasswordController.text;

  if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    showMessage('กรุณากรอกข้อมูลให้ครบทุกช่อง');
    return false;
  }

  if (!isValidEmail(email)) {
    showMessage('รูปแบบอีเมล์ไม่ถูกต้อง');
    return false;
  }

  if (password != confirmPassword) {
    showMessage('รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน');
    return false;
  }

  return true;
}

Future<String> _uploadImage(XFile image) async {
  String picnamest = '';
  try {
    String newFileName = await getNextFileName();
    await storage.ref('uploads/$newFileName').putFile(File(image.path));
    print('File uploaded successfully: $newFileName');
    picnamest = newFileName;
    Get.snackbar("Upload Success", "File uploaded successfully: $newFileName");
  } catch (e) {
    print('Error occurred while uploading: $e');
    Get.snackbar("Error", "Failed to upload file: $e");
  }
  return picnamest;
}

Future<void> _registerUser(String picnamest) async {
  var inboxRef = db.collection('User');


  try {
    String newDocId = await _getNextUserId(inboxRef, 'User');
    var data = {
      'pic': picnamest,
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'pass': passwordController.text,
      'latitude': tappedLocation?.latitude,
      'longitude': tappedLocation?.longitude,
      'createAt': DateTime.now(),
    };

    await inboxRef.doc(newDocId).set(data);
    log('Document $newDocId added successfully');
    Get.snackbar("Success", "Document $newDocId added successfully");
  } catch (e) {
    log('Failed to add document: $e');
    Get.snackbar("Error", "Failed to add document");
  }
}

Future<void> _registerRider(String picnamest) async {
  var inboxRef = db.collection('Rider');


  try {
    String newDocId = await _getNextUserId(inboxRef, 'Rider');
    var data = {
      'pic': picnamest,
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'pass': passwordController.text,
      'Carregistration': addressOrLicenseController.text,
      'createAt': DateTime.now(),
    };

    await inboxRef.doc(newDocId).set(data);
    log('Document $newDocId added successfully');
    Get.snackbar("Success", "Document $newDocId added successfully");
  } catch (e) {
    log('Failed to add document: $e');
    Get.snackbar("Error", "Failed to add document");
  }
}

Future<bool> _isEmailAlreadyUsed(CollectionReference inboxRef, String email) async {
  var emailQuerySnapshot = await inboxRef.where('email', isEqualTo: email).get();
  if (emailQuerySnapshot.docs.isNotEmpty) {
    log('Email already exists');
    Get.snackbar("Error", "อีเมลนี้ถูกใช้แล้ว กรุณาใช้อีเมลอื่น");
    return true;
  }
  return false;
}

Future<String> _getNextUserId(CollectionReference inboxRef, String docType) async {
  var querySnapshot = await inboxRef.orderBy(FieldPath.documentId, descending: true).limit(1).get();
  int nextDocNumber = 1;
  if (querySnapshot.docs.isNotEmpty) {
    var lastDocId = querySnapshot.docs.first.id;
    var lastDocNumber = int.parse(lastDocId.split('-').last);
    nextDocNumber = lastDocNumber + 1;
  }
  return '$docType-$nextDocNumber'; // ใช้ docType เพื่อกำหนดชื่อเอกสาร
}




void _clearInputs() {
  nameController.clear();
  phoneController.clear();
  emailController.clear();
  passwordController.clear();
  confirmPasswordController.clear();
  addressOrLicenseController.clear();
}


  Future<void> uploadFile() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return; 

    try {
      String newFileName = await getNextFileName();
      await storage.ref('uploads/$newFileName').putFile(File(image.path));
      print('File uploaded successfully: $newFileName');

      // แจ้งเตือนชื่อไฟล์ที่อัปโหลด
      Get.snackbar("Upload Success", "File uploaded successfully: $newFileName");
    } catch (e) {
      print('Error occurred while uploading: $e');
      Get.snackbar("Error", "Failed to upload file: $e");
    }
  }


    Future<String> getNextFileName() async {
    final ListResult result = await storage.ref('uploads').listAll();
    int maxNumber = 0;

    for (var ref in result.items) {
      final name = ref.name;
      final match = RegExp(r'pic-(\d+)').firstMatch(name);
      if (match != null) {
        int number = int.parse(match.group(1)!);
        if (number > maxNumber) {
          maxNumber = number;
        }
      }
    }

    return 'pic-${maxNumber + 1}';
  }






  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget customSwitch(
      {required bool value, required ValueChanged<bool> onChanged}) {
    return GestureDetector(
      onTap: () {
        onChanged(!value); // เปลี่ยนสถานะเมื่อกด
      },
      child: Container(
        width: 80, // ความกว้างของสวิตช์
        height: 30, // ความสูงของสวิตช์
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? Colors.purple : Colors.grey, // สีเปลี่ยนตามสถานะ
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              left: value ? 40.0 : 0.0, // เคลื่อนที่ตามสถานะ
              right: value ? 0.0 : 40.0,
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Map() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกที่อยู่'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: currentLocation ?? LatLng(16.2467, 103.2521),
          zoom: 17.0,
          onTap: (tapPosition, point) {
            setState(() {
              tappedLocation = point;
            });
            log('Tapped location: Latitude ${point.latitude}, Longitude ${point.longitude}');
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (currentLocation != null)
            _buildMarker(currentLocation!, Colors.red),
          if (tappedLocation != null)
            _buildMarker(tappedLocation!, Colors.blue),
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

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _zoomIn() {
    final currentZoom = mapController.zoom;
    mapController.move(currentLocation ?? LatLng(16.2467, 103.2521),
        currentZoom + zoomIncrement);
  }

  void _zoomOut() {
    final currentZoom = mapController.zoom;
    if (currentZoom > 1) {
      // Ensure the zoom level does not go below 1
      mapController.move(currentLocation ?? LatLng(16.2467, 103.2521),
          currentZoom - zoomIncrement);
    }
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
