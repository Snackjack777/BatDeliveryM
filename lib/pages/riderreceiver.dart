import 'package:flutter/material.dart';
import 'package:lotto/pages/profilerider.dart';
import 'package:lotto/pages/ridermain.dart';


class RiderReceiverPages extends StatefulWidget {
  const RiderReceiverPages({super.key});

  @override
  State<RiderReceiverPages> createState() => _RiderReceiverPagesState();
}

class _RiderReceiverPagesState extends State<RiderReceiverPages> with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
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
                    Column(
                      children: [

                        Expanded(
                          child: ListView(
                            // Placeholder for search results
                            children: const [
                              ListTile(title: Text('Rider 1')), // "Result 1" in Thai
                              ListTile(title: Text('Rider 2')), // "Result 2" in Thai
                              ListTile(title: Text('Rider 3')), // "Result 3" in Thai
                            ],
                          ),
                        ),
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
}
