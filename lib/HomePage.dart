import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flightsense/CSV2.dart';
import 'package:flightsense/Listview.dart';
import 'package:flightsense/Threads.dart';
import 'package:flightsense/UserProfilePage.dart';
import 'package:flightsense/loginscreen.dart';
import 'package:flightsense/SearchPage.dart';

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
    const Icon(Icons.chat),
    const Icon(Icons.search),
    const Icon(Icons.flight),
    const Icon(Icons.logout), // Add settings icon
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
              profileImageUrl: 'assets/images/user.png',
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
          MaterialPageRoute(
              builder: (context) => Threads()), // Navigate to SearchPage
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchPage()), // Navigate to SearchPage
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CSVFlight()), // Navigate to CSVFlight
        );
        break;
      case 5:
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
      default:
        // Handle settings or other items here (optional)
        print('Selected item: $index'); // Print selected item for debugging
    }
  }

  late Future<String> _usernameFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = _fetchUsername();
  }

  Future<String> _fetchUsername() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
          return data['username'];
        } else {
          return 'User not found';
        }
      } else {
        return 'User not logged in';
      }
    } catch (e) {
      return 'Error fetching username: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade200,
      key: _scaffoldKey, // Assigning the GlobalKey to Scaffold
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0), // Set the preferred height
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade900,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            height: 300,
            child: Padding(
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  Spacer(),
                  FutureBuilder<String>(
                    future: _usernameFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return Row(
                          children: [
                            Text(
                              '${snapshot.data}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return UserProfilePage(
                                        profileImageUrl:
                                            'assets/images/user.png',
                                        name: '',
                                        phoneNumber: '',
                                        email: '',
                                        instagramUsername: '',
                                        dateOfBirth: '',
                                      );
                                    },
                                  ),
                                ),
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage('assets/images/user.png'),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text('Error fetching username');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
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
                title: const Text('Threads'),
                onTap: () => _onItemTapped(2),
              ),
              ListTile(
                selected: _selectedIndex == 3,
                leading: _navigationItems[3],
                title: const Text('Search'),
                onTap: () => _onItemTapped(3), // Handle settings tap (optional)
              ),
              ListTile(
                selected: _selectedIndex == 4,
                leading: _navigationItems[4],
                title: const Text('Flights'),
                onTap: () => _onItemTapped(4), // Handle settings tap (optional)
              ),
              ListTile(
                selected: _selectedIndex == 5,
                leading: _navigationItems[5],
                title: const Text('Sign Out'),
                onTap: () => _onItemTapped(5), // Handle settings tap (optional)
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade900,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text('From',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('To',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.send, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Date',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MyListView();
                          },
                        ),
                      );
                    },
                    child: Center(
                      child: Container(
                        height: 55,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 26, 148, 255),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
