import 'package:flutter/material.dart';

void main() {
  runApp(SearchPage());
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white, // Set background color to white
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
              255, 1, 66, 119), // Set app bar background color to blue
          toolbarHeight: 170.0, // Adjust the height of the app bar
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Search Your Flight", // Set app bar title
                  style: TextStyle(
                    color: const Color.fromARGB(255, 254, 253,
                        253), // Set app bar title text color to black
                    fontSize: 40.0, // Set app bar title text size
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  SizedBox(
                      width: 16.0), // Add some padding to align with the text
                  OutlinedButton(
                    onPressed: () {
                      // Handle round-trip button press
                    },
                    child: Text(
                      "One Way",
                      style: TextStyle(
                          color:
                              Colors.white), // Set button text color to white
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Colors
                              .white), // Adjust button side color for visibility on blue background
                    ),
                  ),
                  Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // Handle round-trip button press
                    },
                    child: Text(
                      "Roundtrip",
                      style: TextStyle(
                          color:
                              Colors.white), // Set button text color to white
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Colors
                              .white), // Adjust button side color for visibility on blue background
                    ),
                  ),
                  Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // Handle multi-city button press
                    },
                    child: Text(
                      "Multi-City",
                      style: TextStyle(
                          color:
                              Colors.white), // Set button text color to white
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Colors
                              .white), // Adjust button side color for visibility on blue background
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 150.0), // Add padding at the bottom
          child: Center(
            child: SingleChildScrollView(
              // Allow scrolling if content overflows
              child: Column(
                children: [
                  SizedBox(
                    height: 10, // Height of the AppBar
                  ),
                  Container(
                    width: 400, // Adjust width as needed
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: Color.fromRGBO(245, 253, 255, 1),
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
                                SizedBox(
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
                                Text(
                                  "Departure",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(width: 10.0),
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
                              SizedBox(width: 10.0),
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
                                  SizedBox(width: 10.0),
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
                              SizedBox(height: 20),

                              // Row for seat classes
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      // Handle Economy button press
                                    },
                                    child: Text(
                                      "Economy",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      // Handle Business button press
                                    },
                                    child: Text(
                                      "Business",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      // Handle First Class button press
                                    },
                                    child: Text(
                                      "First Class",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.black, width: 1.0),
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
                  SizedBox(
                    height:
                        20.0, // Add space between the buttons and the "Search Flight" button
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Search Flight button press
                    },
                    child: Text("Search Flight"),
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
