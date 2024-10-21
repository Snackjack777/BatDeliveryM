import 'package:flutter/material.dart';
import 'package:lotto/pages/receiver.dart';
import 'package:lotto/pages/sender.dart';

class ProfileuserPages extends StatefulWidget {
  const ProfileuserPages({super.key});

  @override
  State<ProfileuserPages> createState() => _ProfileuserPagesState();
}

class _ProfileuserPagesState extends State<ProfileuserPages> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileuserPages()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Senderpages()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ReceiverPages()),
    );
        break;

      // เพิ่มกรณีอื่นๆ สำหรับการนำทางไปยังหน้าอื่นๆ ที่นี่
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 143, 56, 158),
        appBar: AppBar(
          title: const Text('โปรไฟล์ผู้ใช้'),
          backgroundColor: Colors.purple,
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
                  icon: const Icon(Icons.camera_alt, size: 40),
                  onPressed: () {
                    // เพิ่มการเปลี่ยนรูปโปรไฟล์
                  },
                ),
              ),
              const SizedBox(height: 20),

              // คอนเทนเนอร์สีขาวครอบฟอร์มโปรไฟล์
              Container(
                padding: const EdgeInsets.all(16),
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
                child: const ProfileForm(),
              ),
              const Spacer(),
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
      ),
    );
  }
}

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            const SizedBox(width: 10),
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
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'อีเมล',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'ที่อยู่',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // ฟังก์ชันแก้ไขรหัสผ่าน
            },
            child: const Text(
              'แก้ไขรหัสผ่าน',
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ),
      ],
    );
  }
}
