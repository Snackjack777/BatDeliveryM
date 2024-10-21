import 'package:flutter/material.dart';
import 'package:lotto/pages/login.dart';
import 'package:lotto/pages/ridermain.dart';
import 'package:lotto/pages/riderreceiver.dart';

class ProfileriderPages extends StatefulWidget {
  const ProfileriderPages({super.key});

  @override
  State<ProfileriderPages> createState() => _ProfileriderPagesState();
}

class _ProfileriderPagesState extends State<ProfileriderPages> {

  int _selectedIndex = 0;


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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 143, 56, 158),
        appBar: AppBar(
          title: Text('โปรไฟล์ผู้ใช้'),
          backgroundColor: const Color.fromARGB(255, 218, 179, 224),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // รูปโปรไฟล์
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: IconButton(
                  icon: Icon(Icons.camera_alt, size: 40),
                  onPressed: () {
                    // เพิ่มการเปลี่ยนรูปโปรไฟล์
                  },
                ),
              ),
              SizedBox(height: 20),

              // คอนเทนเนอร์สีขาวครอบฟอร์มโปรไฟล์
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ProfileForm(),
              ),
            
              SizedBox(height: 20),
              FilledButton(onPressed: (){
                Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPages()),
        );
              }, child: const Text('ออกจากระบบ')),
            
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
}

class ProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ชื่อ และ หมายเลขโทรศัพท์
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'ชื่อ',
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
                  labelText: 'หมายเลขโทรศัพท์',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // อีเมล
        TextField(
          decoration: InputDecoration(
            labelText: 'อีเมล',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(height: 10),

        // ที่อยู่
        TextField(
          decoration: InputDecoration(
            labelText: 'ป้ายทะเบียน',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(height: 10),

        // แก้ไขรหัสผ่าน
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // ฟังก์ชันแก้ไขรหัสผ่าน
            },
            child: Text(
              'แก้ไขรหัสผ่าน',
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ),
      ],
    );
  }
}
