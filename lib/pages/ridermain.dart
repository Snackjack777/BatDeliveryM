import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lotto/pages/profilerider.dart';
import 'package:lotto/pages/riderreceiver.dart';


class RiderMainPages extends StatefulWidget {
  const RiderMainPages({super.key});

  @override
  State<RiderMainPages> createState() => _RiderMainPagesState();
}

class _RiderMainPagesState extends State<RiderMainPages> {

  int _selectedIndex = 1;

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
    initializeDB();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileriderPages()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RiderMainPages()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RiderReceiverPages()),
        );
        break;
    }
  }


    Future<void> initializeDB() async {
    await loadData();
    await readAllOder();
    await _loadFirebaseImage() ;
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


Future<void> readAllOder() async {
  var result =
      await db.collection('Order').where('rider', isEqualTo: 'no').get(); 

  List<Map<String, dynamic>> tempSenderList = [];
  
  for (var doc in result.docs) {
    String imageUrlr = '';
    var result2 = await db.collection('User').doc(doc['sender']).get(); 
    
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
    String sendername = result2.data()?['name'] ?? 'Unknown'; 
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








  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.purple[100],
        appBar: AppBar(
          title: Text('รับงาน'),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    buildJobCard(context, 'นาย A'),
                    SizedBox(height: 10),
                    buildJobCard(context, 'นาย B'),
                  ],
                ),
              ),
              // Bottom Navigation Bar
   
            ],
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
              label: 'Receiver',
            ),
          ],
        ),
      ),
    
    
      
      ),
    );
  }

  // การ์ดแสดงงาน
  Widget buildJobCard(BuildContext context, String name) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 18)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple, // สีของปุ่ม
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              // เมื่อกดปุ่มจะแสดง AlertDialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('รายละเอียดงานของ $name'),
                    content: buildAlertDialogContent(),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('คุณปฏิเสธงาน')),
                          );
                        },
                        child: Text('ปฏิเสธ'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('คุณยอมรับงานแล้ว')),
                          );
                        },
                        child: Text('ยอมรับ'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('รายละเอียด'),
          ),
        ],
      ),
    );
  }

  // เนื้อหาภายใน AlertDialog
  Widget buildAlertDialogContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ช่องส่งจาก และไปยัง
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'ส่งจาก',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'ไปยัง',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // ช่องกรอกเบอร์ผู้ส่งและผู้รับ
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'เบอร์ผู้ส่ง',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'เบอร์ผู้รับ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // ช่องชื่อการส่ง
          TextField(
            decoration: InputDecoration(
              labelText: 'ชื่อการส่ง',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 10),
          // ช่องกรอกรายละเอียดการส่ง
          TextField(
            decoration: InputDecoration(
              labelText: 'รายละเอียดการส่ง',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          // ช่องใส่รูป
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(Icons.camera_alt, size: 50),
                SizedBox(height: 8),
                Text('อัพโหลดรูปภาพ'),
              ],
            ),
          ),
        ],
      ),
    );
  }










}


