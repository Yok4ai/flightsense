import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/UserProfilePage.dart';
import 'package:flightsense/loginscreen.dart';
import 'package:flightsense/SearchPage.dart'; // Import SearchPage.dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // Create a variable to track the selected navigation item
  int _selectedIndex = 0;

  // List of navigation items
  final List<Widget> _navigationItems = [
    const Icon(Icons.home),
    const Icon(Icons.account_circle),
    const Icon(Icons.search),
    const Icon(Icons.settings), // Add settings icon
  ];

  // GlobalKey to access the ScaffoldState for opening the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected page based on index
    switch (index) {
      case 0:
        // Home page is already displayed, no need for navigation
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              profileImageUrl: 'assets/images/gojo.png',
              name: 'Shuvo',
              phoneNumber: '01866946299',
              email: 'shuvo.sss1906@gmail.com',
              instagramUsername: '__Shruv',
              dateOfBirth: '19/06/2000',
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()), // Navigate to SearchPage
        );
        break;
      default:
        // Handle settings or other items here (optional)
        print('Selected item: $index'); // Print selected item for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assigning the GlobalKey to Scaffold
      appBar: AppBar(
        title: const Text('FlightSense'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(), // Open drawer on menu tap
        ),
        backgroundColor: Colors.blue, // Specify the desired color
      ),
      drawer: Drawer(
        child: Material(
          // Wrap with Material for proper elevation
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'FlightSense',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                selected: _selectedIndex == 0,
                leading: _navigationItems[0],
                title: const Text('Home'),
                onTap: () => _onItemTapped(0),
              ),
              ListTile(
                selected: _selectedIndex == 1,
                leading: _navigationItems[1],
                title: const Text('User Profile'),
                onTap: () => _onItemTapped(1),
              ),
              ListTile(
                selected: _selectedIndex == 2,
                leading: _navigationItems[2],
                title: const Text('Search'),
                onTap: () => _onItemTapped(2),
              ),
              ListTile(
                selected: _selectedIndex == 3,
                leading: _navigationItems[3],
                title: const Text('Settings'),
                onTap: () => _onItemTapped(3), // Handle settings tap (optional)
              ),
            ],
          ),
        ),
      ),
      body: Center(
        // Replace with your actual home page content
        child: _selectedIndex == 0 ? Text('Signed In as: ${user.email!}') : const Text('Content for other pages'),
      ),
    );
  }
}
