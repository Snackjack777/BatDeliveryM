import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lotto/pages/profileuser.dart';
import 'package:lotto/pages/sender.dart';

class UserReceiverPages extends StatefulWidget {
  const UserReceiverPages({super.key});

  @override
  State<UserReceiverPages> createState() => _UserReceiverPagesState();
}

class _UserReceiverPagesState extends State<UserReceiverPages> with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  late TabController _tabController; // Add TabController


  final storageF = GetStorage();
  var db = FirebaseFirestore.instance;
  final MapController mapController = MapController();
  final double zoomIncrement = 1.0;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String? _firebaseImageUrl;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? pic;
  double? latitude;
  double? longitude;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> receiverall = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); 
    initializeDB();
  }

    Future<void> initializeDB() async {
    await loadData();
    await readAllreceiver();
    await _loadFirebaseImage() ;
  }

  Future<void> loadData() async {
    userId = storageF.read('userId');
    name = storageF.read('name');
    email = storageF.read('email');
    phone = storageF.read('phone');
    pic = storageF.read('pic');
    // log('$name');

    // ตรวจสอบค่าที่อ่านมาจาก storage ว่าไม่เป็น null
    final latitudeString = storageF.read('latitude');
    final longitudeString = storageF.read('longitude');

    // แปลงค่า latitude และ longitude เป็น double หากไม่เป็น null
    // if (latitudeString != null && longitudeString != null) {
    //   try {
    //     latitude = double.parse(latitudeString);
    //     longitude = double.parse(longitudeString);
    //     if (latitude != null && longitude != null) {
    //       setState(() {
    //         point1 = LatLng(latitude!, longitude!);
    //       });
    //     }
    //   } catch (e) {
    //     log('Error parsing latitude or longitude: $e');
    //     point1 = null;
    //   }
    // } else {
    //   log('Latitude or longitude is null');
    //   point1 = null;
    // }
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileuserPages()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Senderpages()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserReceiverPages()),
        );
        break;
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
                  Tab(text: 'ของที่ต้องรับ'), // "Search" in Thai
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
                    Column(
                      children: [

                        Expanded(
                            child: ListView.builder(
                          itemCount: receiverall.length,
                          itemBuilder: (context, index) {
                            var receiver = receiverall[index];
                            return Card(
                              margin: EdgeInsets.all(10),
                              child: ListTile(
                                title: Text('Receiver : ${index+1}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ผู้ส่ง : ${receiver['sendername']}'),
                                    Text('โทรศัพทร์ผู้รับ : ${receiver['phone']}'),
                                    Text('สถานะ : ${receiver['status']}'),
                                     Text('รายละเอียด : ${receiver['detail']}'),
                                     
                                    
                                  ],
                                ),
                                leading: Image.network(receiver['photosender']),
                              ),
                            );
                          },
                        )),
                      ],
                    ),
                    // Second tab: Map Page
                    const Center(
                      child: Text(
                        'แผนที่ Rider ที่กำลังมาส่ง', // "Map will be here" in Thai
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
              label: 'Sender',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/map.png',
                width: 30,
                height: 30,
              ),
              label: 'Receiver',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the TabController
    super.dispose();
  }


Future<void> readAllreceiver() async {
  var result =
      await db.collection('Order').where('receiver', isEqualTo: userId).get(); // ดึงข้อมูลจาก collection Order ที่ sender = userId
  List<Map<String, dynamic>> tempSenderList = [];
  
  for (var doc in result.docs) {
    String imageUrlr = '';
    var result2 = await db.collection('User').doc(doc['sender']).get(); // แก้ไขเป็นการดึง sender จาก Order แทน
    
    try {
      if (doc['photosender'] != null) {
        imageUrlr = await storage
            .ref('/order/${doc['photosender']}')
            .getDownloadURL();
      }
    } catch (e) {
      log('Failed to load image: $e');
    }

    // ดึงแค่ชื่อ name จาก result2
    String sendername = result2.data()?['name'] ?? 'Unknown'; // หาก name ไม่มีค่า จะแสดง 'Unknown'
    String senderphone = result2.data()?['phone'] ?? 'Unknown';
    
    tempSenderList.add({
      'createAt': doc['createAt'],
      'detail': doc['detail'],
      'photosender': imageUrlr,
      'sendername': sendername,
      'rider': doc['rider'],
      'status': doc['status'],
      'sender': doc['sender'], 
      'phone': senderphone, 
    });
  }

  setState(() {
    receiverall = tempSenderList;
  });
}






}
