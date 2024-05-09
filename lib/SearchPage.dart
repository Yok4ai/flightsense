import 'package:flutter/material.dart';

void main() {
  runApp(const SearchPage());
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white, // Set background color to white
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 126, 220), // Set app bar background color to blue
          toolbarHeight: 170.0, // Adjust the height of the app bar
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Search Your Flight", // Set app bar title
                  style: TextStyle(
                    color: Color.fromARGB(255, 254, 253,
                        253), // Set app bar title text color to black
                    fontSize: 40.0, // Set app bar title text size
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const SizedBox(
                      width: 16.0), // Add some padding to align with the text
                  OutlinedButton(
                    onPressed: () {
                      // Handle round-trip button press
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Colors
                              .white), // Adjust button side color for visibility on blue background
                    ),
                    child: const Text(
                      "One Way",
                      style: TextStyle(
                          color:
                              Colors.white), // Set button text color to white
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // Handle round-trip button press
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Colors
                              .white), // Adjust button side color for visibility on blue background
                    ),
                    child: const Text(
                      "Roundtrip",
                      style: TextStyle(
                          color:
                              Colors.white), // Set button text color to white
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // Handle multi-city button press
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Colors
                              .white), // Adjust button side color for visibility on blue background
                    ),
                    child: const Text(
                      "Multi-City",
                      style: TextStyle(
                          color:
                              Colors.white), // Set button text color to white
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 150.0), // Add padding at the bottom
          child: Center(
            child: SingleChildScrollView(
              // Allow scrolling if content overflows
              child: Column(
                children: [
                  const SizedBox(
                    height: 10, // Height of the AppBar
                  ),
                  Container(
                    width: 400, // Adjust width as needed
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: const Color.fromRGBO(245, 253, 255, 1),
                      borderRadius: BorderRadius.circular(
                          20.0), // Set border radius for curved edges
                    ),
                    child: SingleChildScrollView(
                      // Allow scrolling if content overflows
                      child: Column(
                        children: [
                          // Row for origin and destination input fields
                          Padding(
                            padding: const EdgeInsets.all(
                                16.0), // Add padding around input fields
                            child: Row(
                              children: [
                                Flexible(
                                  // Make origin field flexible to fill available space
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText:
                                          "From", // Set label text for origin field
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Set border style
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        10.0), // Add spacing between input fields
                                Flexible(
                                  // Make destination field flexible to fill available space
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText:
                                          "To", // Set label text for destination field
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Set border style
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Row for departure date picker
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Text(
                                  "Departure",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  // Make departure date field flexible to fill available space
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText:
                                          "Select Date", // Set label text for departure date
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Row for number of adults and children (if applicable)
                          Column(
                            children: [
                              const SizedBox(width: 10.0),
                              // Row for number of adults and children (if applicable)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Text field for Adults
                                  Flexible(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "No. Of Adults",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  // Text field for Children
                                  Flexible(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "No. of Children",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Add space between the rows
                              const SizedBox(height: 20),

                              // Row for seat classes
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      // Handle Economy button press
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                    child: const Text(
                                      "Economy",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      // Handle Business button press
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                    child: const Text(
                                      "Business",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      // Handle First Class button press
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                    child: const Text(
                                      "First Class",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ), // <- Closing the Column widget here
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height:
                        20.0, // Add space between the buttons and the "Search Flight" button
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Search Flight button press
                    },
                    child: const Text("Search Flight"),
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
