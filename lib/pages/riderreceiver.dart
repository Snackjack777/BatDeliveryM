import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:lotto/pages/profilerider.dart';
import 'package:lotto/pages/ridermain.dart';

class RiderReceiverPages extends StatefulWidget {
  const RiderReceiverPages({super.key});

  @override
  State<RiderReceiverPages> createState() => _RiderReceiverPagesState();
}

class _RiderReceiverPagesState extends State<RiderReceiverPages>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  late TabController _tabController;

  Position? currentPosition;
  final storageF = GetStorage();
  var db = FirebaseFirestore.instance;
  final MapController mapController = MapController();
  final double zoomIncrement = 1.0;
  final double minZoom = 1.0;
  final double maxZoom = 18.0;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String? _firebaseImageUrl;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? pic;
  double? latitude;
  double? longitude;

  List<Map<String, dynamic>> orderrider = [];
  XFile? selectedImage;

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the TabController
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    initializeDB();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileriderPages()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RiderMainPages()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RiderReceiverPages()),
        );
        break;
    }
  }

  Future<void> initializeDB() async {
    await loadData();
    await _loadFirebaseImage();
    await readOderRider();

    // currentPosition = LatLng(16.251206403638957, 103.23923616148686);
  }

  Future<void> loadData() async {
    userId = storageF.read('userId');
    name = storageF.read('name');
    email = storageF.read('email');
    phone = storageF.read('phone');
    pic = storageF.read('pic');
  }

  Future<void> _loadFirebaseImage() async {
    try {
      if (pic != null) {
        String imageUrl = await storage.ref('/uploads/$pic').getDownloadURL();
        setState(() {
          _firebaseImageUrl = imageUrl;
        });
      }
    } catch (e) {
      print('Failed to load image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 143, 56, 158),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow position
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // TabBar for selecting between Search and Map
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'รายละเอียดงาน'), // "Search" in Thai
                  Tab(text: 'แผนที่'), // "Map" in Thai
                ],
                labelColor: Colors.purple, // Selected tab color
                unselectedLabelColor: Colors.black, // Unselected tab color
                indicatorColor: Colors.purple, // Tab indicator color
              ),
              const SizedBox(height: 10), // Space between TabBar and TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // First tab: Search Page
                    Column(children: [
                      Expanded(
                        child: orderrider.isEmpty
                            ? Center(
                                child: Text(
                                  'ไม่มีข้อมูลงานในขณะนี้',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              )
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();
                                      selectedImage = await picker.pickImage(
                                          source: ImageSource.camera);
                                      if (selectedImage != null) {
                                        setState(() {
                                          this.selectedImage =
                                              selectedImage; // แก้ไขให้ใช้ `this.selectedImage`
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 250,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: selectedImage == null
                                          ? const Center(
                                              child: Text('ใส่ภาพการส่ง'))
                                          : Image.file(
                                              File(selectedImage!.path),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    // ใช้ Expanded เพื่อให้ ListView ใช้พื้นที่ที่เหลือ
                                    child: ListView.builder(
                                      itemCount: orderrider.length,
                                      itemBuilder: (context, index) {
                                        var order = orderrider[index];
                                        return Card(
                                          margin: EdgeInsets.all(10),
                                          child: ListTile(
                                            title: Text('รายละเอียดงาน'),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'รหัสงาน : ${order['order_id']}'),
                                                Text(
                                                    'ผู้ส่ง : ${order['senderName']}'),
                                                Text(
                                                    'เบอร์ผู้ส่ง : ${order['senderphone']}'),
                                                Text(
                                                    'ผู้รับ : ${order['receiver']}'),
                                                Text(
                                                    'เบอร์ผู้รับ : ${order['phone']}'),
                                                Text(
                                                    'ไรเดอร์ : ${order['rider']}'),
                                                Text(
                                                    'สถานะ : ${order['status']}'),
                                                Text(
                                                    'รายละเอียด : ${order['detail']}'),
                                              ],
                                            ),
                                            leading: Image.network(
                                                order['photosender']),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  FilledButton(
                                    onPressed: () {
                                      if (orderrider.isNotEmpty) {
                                        submitwork(
                                          '${orderrider[0]['order_id']}',
                                          '${orderrider[0]['photosender_pic'] ?? ''}', 
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.green), 
                                    ),
                                    child: Text('ส่งงาน'),
                                  ),
                                ],
                              ),
                      ),
                    ]),
                    const Center(
                      child: Text(
                        'แผนที่ Rider ที่กำลังมาส่ง',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/pro2.png',
                width: 30,
                height: 30,
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/batone.png',
                width: 30,
                height: 30,
              ),
              label: 'Rider',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/map.png',
                width: 30,
                height: 30,
              ),
              label: 'Work',
            ),
          ],
        ),
      ),
    );
  }

  readOderRider() async {
    var filteredOrders =
        await db.collection('Order').where('rider', isEqualTo: userId).get();

    var result =
        filteredOrders.docs.where((doc) => doc['status'] != 'ส่งแล้ว').toList();
    List<Map<String, dynamic>> tempSenderList = [];
    List<LatLng> pointsadd = [];
    List<String> ridernumberadd = [];
    List<LatLng> riderPointsAdd = [];

    List<String> ridernamesadd = [];
    for (var doc in result) {
      double pointX = doc['pointX'] ?? 0.0;
      double pointY = doc['pointY'] ?? 0.0;

      if (pointX != 0.0 && pointY != 0.0) {
        riderPointsAdd.add(LatLng(pointX, pointY));
        ridernamesadd.add(doc['rider']);
      }

      String imageUrlr = '';
      var result2 = await db.collection('User').doc(doc['receiver']).get();
      var result3 = await db.collection('User').doc(doc['sender']).get();

      try {
        if (doc['photosender'] != null) {
          imageUrlr = await storage
              .ref('/order/${doc['photosender']}')
              .getDownloadURL();
        }
      } catch (e) {
        log('Failed to load image: $e');
        imageUrlr = '';
      }

      String receiverName = result2.data()?['name']?.toString() ?? 'Unknown';
      String receiverphone = result2.data()?['phone']?.toString() ?? 'Unknown';
      String? receiverpic = result2.data()?['pic']?.toString();

      String senderName = result3.data()?['name']?.toString() ?? 'Unknown';
      String senderphone = result3.data()?['phone']?.toString() ?? 'Unknown';
      String? senderpic = result3.data()?['pic']?.toString();

      double receiverlatitude = 0.0;
      double receiverlongitude = 0.0;

      try {
        receiverlatitude =
            double.parse(result2.data()?['latitude']?.toString() ?? '0.0');
        receiverlongitude =
            double.parse(result2.data()?['longitude']?.toString() ?? '0.0');
      } catch (e) {
        log('Error parsing coordinates: $e');
      }

      String receiverPicUrl = '';
      String senderPicUrl = '';
      if (receiverpic != null && receiverpic.isNotEmpty) {
        try {
          receiverPicUrl =
              await storage.ref('/uploads/$receiverpic').getDownloadURL();
          senderPicUrl =
              await storage.ref('/uploads/$senderpic').getDownloadURL();
        } catch (e) {
          log('Failed to load receiver pic: $e');
          receiverPicUrl = '';
        }
      }

      if (receiverlatitude != 0.0 && receiverlongitude != 0.0) {
        pointsadd.add(LatLng(receiverlatitude, receiverlongitude));
        ridernumberadd.add(receiverName);

        tempSenderList.add({
          'order_id': doc.id,
          'detail': doc['detail'] ?? '',
          'photosender': imageUrlr,
          'photosender_pic': doc['photosender'],
          'receiver': receiverName,
          'senderName': senderName,
          'senderphone': senderphone,
          'rider': doc['rider'] ?? '',
          'status': doc['status'] ?? '',
          'sender': doc['sender'] ?? '',
          'phone': receiverphone,
          'picR': receiverPicUrl,
          'picS': senderPicUrl,
          'latitude': receiverlatitude,
          'longitude': receiverlongitude,
        });
      }
    }

    setState(() {
      orderrider = tempSenderList;
      // points = pointsadd;
      // ridernumber = ridernumberadd;
      // riderPoints = riderPointsAdd;
      // ridernames = ridernamesadd;
    });
  }

  Future<void> submitwork(String order_id, String pic1) async {
    // log('Order : ${order_id}');
    // log('pic : ${pic1}');
    // log('work');
    if (selectedImage != null && order_id != null && pic1 != null) {
      log('pic');

      try {
      await storage.ref('order/$pic1').delete();
      String newFileName = await getNextFileName();
      await storage.ref('order/$newFileName').putFile(File(selectedImage!.path));
      await db
          .collection('Order')
          .doc(order_id)
          .update({'status': 'รอยืนยันการส่งงาน','photosender': newFileName});

      readOderRider();


      Get.snackbar("ส่งงานสำเร็จ", "โปรดรอผู้รับสินค้ายืนยันการส่งงาน");

    } catch (e) {
      log('Error occurred while deleting: $e');
      Get.snackbar("Error", "Failed to delete file: $e");
    }

    } else {
      log('nopic');
      Get.snackbar("ไม่มีรูปภาพ", "โปรดใส่รูปภาพเพื่อส่งงาน");
    }
  }

  Future<String> getNextFileName() async {
    final ListResult result = await storage.ref('order').listAll();
    int maxNumber = 0;

    for (var ref in result.items) {
      final name = ref.name;
      final match = RegExp(r'order-(\d+)').firstMatch(name);
      if (match != null) {
        int number = int.parse(match.group(1)!);
        if (number > maxNumber) {
          maxNumber = number;
        }
      }
    }

    return 'order-${maxNumber + 1}';
  }




}
