import 'package:flutter/material.dart';
import 'package:lotto/pages/profileuser.dart';
import 'package:lotto/pages/receiver.dart';

class Senderpages extends StatefulWidget {
  const Senderpages({super.key});

  @override
  State<Senderpages> createState() => _SenderpagesState();
}

class _SenderpagesState extends State<Senderpages> with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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
    }
  }

  void _showDialog() {
    final TextEditingController fromController = TextEditingController();
    final TextEditingController toController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ข้อมูลการส่ง'), // "Delivery Information" in Thai
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: fromController,
                  decoration: const InputDecoration(labelText: 'ส่งจาก'), // "From" in Thai
                ),
                TextField(
                  controller: toController,
                  decoration: const InputDecoration(labelText: 'ไปยัง'), // "To" in Thai
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'ชื่อการส่ง'), 
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'เบอร์ผู้รับ'), 
                ),
                TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียด',
                    hintText: 'รายละเอียดเพิ่มเติม', 
                  ),
                  maxLines: 3, 
                ),
                const SizedBox(height: 10),
                const Text('ที่ใส่ภาพ รอไรเดอร์มารับสินค้า'), 
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(child: Text('ที่ใส่ภาพ')), 
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle the submission logic here
                Navigator.of(context).pop();
              },
              child: const Text('ส่ง'), // "Send" in Thai
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('ยกเลิก'), // "Cancel" in Thai
            ),
          ],
        );
      },
    );
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
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'ค้นหาผู้รับ'), // "Search" in Thai
                  Tab(text: 'แผนที่การส่ง'), // "Map" in Thai
                ],
                labelColor: Colors.purple,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.purple,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 201, 201, 201),
                            labelText: 'ค้นหา',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            children: [
                              if (searchQuery.isEmpty) ...[
                                ListTile(
                                  title: const Text('ผลลัพธ์ 1'),
                                  onTap: _showDialog, // Show dialog on tap
                                ),
                                ListTile(
                                  title: const Text('ผลลัพธ์ 2'),
                                  onTap: _showDialog, // Show dialog on tap
                                ),
                                ListTile(
                                  title: const Text('ผลลัพธ์ 3'),
                                  onTap: _showDialog, // Show dialog on tap
                                ),
                              ] else ...[
                                ListTile(
                                  title: Text('ผลลัพธ์ ที่ค้นหา: $searchQuery'),
                                  onTap: _showDialog, // Show dialog on tap
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'แผนที่จะไปที่นี่', // "Map will be here" in Thai
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
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
