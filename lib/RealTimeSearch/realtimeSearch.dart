import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RealtimeSearchPage extends StatefulWidget {
  const RealtimeSearchPage({super.key});

  @override
  _RealtimeSearchPageState createState() => _RealtimeSearchPageState();
}

class _RealtimeSearchPageState extends State<RealtimeSearchPage> {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _departureDateController =
      TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  bool _isEconomy = true; // Default to Economy class
  List<Map<String, dynamic>> _flightData = []; // Store retrieved flight data
  bool _showSearchOptions = true; // Control whether to show search options

  String selectedAirline = 'All Airlines';
  List<Map<String, dynamic>> _filteredFlightData = [];
  @override
  void initState() {
    super.initState();
    // Call getAirlines function to populate airlines list
    getAirlines(_flightData);
  }



  Future<void> _realtimeSearch() async {
    setState(() {
      _flightData.clear(); // Reset flight data
      _showSearchOptions = true; // Show search options
    });

    String departure = _departureController.text;
    String destination = _destinationController.text;
    String departureDate = _departureDateController.text;
    String returnDate = _returnDateController.text;
    String classType = _isEconomy ? 'economy' : 'premium';

    // Construct the request body
    Map<String, dynamic> requestData = {
      'departure_city': departure,
      'destination_city': destination,
      'departure_date': departureDate,
      'return_date': returnDate,
      'flight_class': classType,
    };

    try {
      // Send POST request to your Flask scraper endpoint
      var url = Uri.parse('http://10.0.2.2:5000/search-flights');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Handle success
        var data = jsonDecode(response.body);
        setState(() {
          _flightData = List<Map<String, dynamic>>.from(data['flights']);
          _showSearchOptions =
              false; // Hide search options when results are shown
        });

        _applyAirlineFilter();

      } else {
        // Handle error
        print(
            'Failed to retrieve flight data. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle error
      print('Error occurred while searching flights: $e');
    }
  }

  // void _sortByLowestPrice() {
  //   setState(() {
  //     _flightData.sort((a, b) {
  //       // Extract numeric values from price strings
  //       int priceA =
  //           int.tryParse(a['price'].replaceAll(RegExp('[^0-9]'), '')) ?? 0;
  //       int priceB =
  //           int.tryParse(b['price'].replaceAll(RegExp('[^0-9]'), '')) ?? 0;
  //       return priceA.compareTo(priceB);
  //     });
  //   });
  // }

  // void _sortByHighestPrice() {
  //   setState(() {
  //     _flightData.sort((a, b) {
  //       // Extract numeric values from price strings
  //       int priceA =
  //           int.tryParse(a['price'].replaceAll(RegExp('[^0-9]'), '')) ?? 0;
  //       int priceB =
  //           int.tryParse(b['price'].replaceAll(RegExp('[^0-9]'), '')) ?? 0;
  //       return priceB.compareTo(priceA);
  //     });
  //   });
  // }

  // bool _durationAscending = true;
  // void _sortByTime() {
  //   setState(() {
  //     _flightData.sort((a, b) {
  //       // Split duration strings at the dash '–' to extract departure time and handle day indicator
  //       List<String> departurePartsA =
  //           a['duration'].split('–')[0].trim().split(' ');
  //       List<String> departurePartsB =
  //           b['duration'].split('–')[0].trim().split(' ');

  //       // Extract departure time and AM/PM indicator
  //       List<String> timePartsA = departurePartsA[0].split(':');
  //       List<String> timePartsB = departurePartsB[0].split(':');

  //       int hourA = int.parse(timePartsA[0]);
  //       int minuteA = int.parse(timePartsA[1]);
  //       bool isPMA = departurePartsA.length > 1 &&
  //           departurePartsA[1].toLowerCase() == 'pm';
  //       int dayIndicatorA = departurePartsA.length > 2
  //           ? int.parse(
  //               departurePartsA[2].substring(0, departurePartsA[2].length - 2))
  //           : 0;

  //       int hourB = int.parse(timePartsB[0]);
  //       int minuteB = int.parse(timePartsB[1]);
  //       bool isPMB = departurePartsB.length > 1 &&
  //           departurePartsB[1].toLowerCase() == 'pm';
  //       int dayIndicatorB = departurePartsB.length > 2
  //           ? int.parse(
  //               departurePartsB[2].substring(0, departurePartsB[2].length - 2))
  //           : 0;

  //       // Adjust hour if it's PM
  //       if (isPMA && hourA != 12) hourA += 12;
  //       if (isPMB && hourB != 12) hourB += 12;

  //       // Adjust day indicator if next day is indicated
  //       hourA += dayIndicatorA * 24;
  //       hourB += dayIndicatorB * 24;

  //       // Compare time
  //       if (_durationAscending) {
  //         if (hourA == hourB) {
  //           return minuteA.compareTo(minuteB);
  //         } else {
  //           return hourA.compareTo(hourB);
  //         }
  //       } else {
  //         if (hourB == hourA) {
  //           return minuteB.compareTo(minuteA);
  //         } else {
  //           return hourB.compareTo(hourA);
  //         }
  //       }
  //     });

  //     // Toggle sort order for next click
  //     _durationAscending = !_durationAscending;
  //   });
  // }

  void _sortByLowestPrice() {
  setState(() {
    _filteredFlightData.sort((a, b) {
      int priceA = int.tryParse(a['price'].replaceAll(RegExp('[^0-9]'), '')) ?? 0;
      int priceB = int.tryParse(b['price'].replaceAll(RegExp('[^0-9]'), '')) ?? 0;
      return priceA.compareTo(priceB);
    });
  });
}

void _sortByHighestPrice() {
  setState(() {
    _filteredFlightData.sort((a, b) {
      int priceA = int.tryParse(a['price'].replaceAll(RegExp('[^0-9]'), '')) ?? 0;
      int priceB = int.tryParse(b['price'].replaceAll(RegExp('[^0-9]'), '')) ?? 0;
      return priceB.compareTo(priceA);
    });
  });
}

bool _durationAscending = true;

void _sortByTime() {
  setState(() {
    _filteredFlightData.sort((a, b) {
      List<String> departurePartsA = a['duration'].split('–')[0].trim().split(' ');
      List<String> departurePartsB = b['duration'].split('–')[0].trim().split(' ');

      List<String> timePartsA = departurePartsA[0].split(':');
      List<String> timePartsB = departurePartsB[0].split(':');

      int hourA = int.parse(timePartsA[0]);
      int minuteA = int.parse(timePartsA[1]);
      bool isPMA = departurePartsA.length > 1 && departurePartsA[1].toLowerCase() == 'pm';
      int dayIndicatorA = departurePartsA.length > 2 ? int.parse(departurePartsA[2].substring(0, departurePartsA[2].length - 2)) : 0;

      int hourB = int.parse(timePartsB[0]);
      int minuteB = int.parse(timePartsB[1]);
      bool isPMB = departurePartsB.length > 1 && departurePartsB[1].toLowerCase() == 'pm';
      int dayIndicatorB = departurePartsB.length > 2 ? int.parse(departurePartsB[2].substring(0, departurePartsB[2].length - 2)) : 0;

      if (isPMA && hourA != 12) hourA += 12;
      if (isPMB && hourB != 12) hourB += 12;

      hourA += dayIndicatorA * 24;
      hourB += dayIndicatorB * 24;

      if (_durationAscending) {
        if (hourA == hourB) {
          return minuteA.compareTo(minuteB);
        } else {
          return hourA.compareTo(hourB);
        }
      } else {
        if (hourB == hourA) {
          return minuteB.compareTo(minuteA);
        } else {
          return hourB.compareTo(hourA);
        }
      }
    });

    // Toggle sort order for next click
    _durationAscending = !_durationAscending;
  });
}




  Future<void> getAirlines(List<Map<String, dynamic>> flightData) async {
    try {
      // Extract airlines from flight data
      List<String> airlines = [];
      flightData.forEach((flight) {
        airlines.add(flight['airline']);
      });

      // Print airlines in console
      print('Airlines: $airlines');
    } catch (e) {
      print('Error occurred while getting airlines: $e');
    }
  }

// this function creates the dropdown filter
Widget _buildAirlineDropdown() {
  // Extract unique airline names
  Set uniqueAirlines = _flightData.map((flight) => flight['airline']).toSet();

  return DropdownButtonFormField<String>(
    value: selectedAirline,
    items: [
      DropdownMenuItem<String>(
        value: 'All Airlines',
        child: Text('All Airlines'),
      ),
      ...uniqueAirlines.map((airline) {
        return DropdownMenuItem<String>(
          value: airline,
          child: Text(airline),
        );
      }),
    ],
    onChanged: (String? value) {
      if (value != null) {
        setState(() {
          selectedAirline = value;
        });
      }
    },
  );
}


  // Add this method to apply airline filter
void _applyAirlineFilter() {
  setState(() {
    if (selectedAirline != 'All Airlines') {
      print('Filtering flights for $selectedAirline');
      _filteredFlightData = _flightData
          .where((flight) => flight['airline'] == selectedAirline)
          .toList();
    } else {
      print('Showing all flights');
      _filteredFlightData = List.from(_flightData);
    }
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Realtime Search'),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [

                _buildAirlineDropdown(),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _departureController,
                        decoration:
                            const InputDecoration(labelText: 'Departure City'),
                      ),
                      TextField(
                        controller: _destinationController,
                        decoration: const InputDecoration(
                            labelText: 'Destination City'),
                      ),
                      TextField(
                        controller: _departureDateController,
                        decoration: const InputDecoration(
                            labelText: 'Departure Date (YYYY-MM-DD)'),
                      ),
                      TextField(
                        controller: _returnDateController,
                        decoration: const InputDecoration(
                            labelText: 'Return Date (YYYY-MM-DD)'),
                      ),
                      Row(
                        children: [
                          const Text('Economy Class'),
                          Switch(
                            value: _isEconomy,
                            onChanged: (value) {
                              setState(() {
                                _isEconomy = value;
                              });
                            },
                          ),
                          const Text('Premium Class'),
                        ],
                      ),
                      // Sort buttons
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _sortByLowestPrice,
                              child: Text('Sort by Lowest Price'),
                            ),
                            ElevatedButton(
                              onPressed: _sortByHighestPrice,
                              child: Text('Sort by Highest Price'),
                            ),
                            ElevatedButton(
                              onPressed: _sortByTime,
                              child: Text('Sort by Time'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20.0),
                     ElevatedButton(
                        onPressed: () {
                          _realtimeSearch();
                          // Reset the dropdown filter to "All Airlines"
                          setState(() {
                            selectedAirline = 'All Airlines';
                          });
                        },
                        child: const Text('Search Flights'),
                      ),

                      ElevatedButton(
                      onPressed: _applyAirlineFilter, // Apply airline filter when button is pressed
                      child: const Text('Apply Airline Filter'),
                    ),

                    ],
                  ),
                ),
                _showSearchOptions
                    ? const SizedBox() // If search options are shown, show an empty SizedBox
                    : Expanded(
                        child: _flightData.isEmpty
                            ? const Center(
                                child: Text('No flight data available'))
                            // : ListView.builder(
                            //     shrinkWrap: true,
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     itemCount: _flightData.length,
                            //     itemBuilder: (context, index) {
                            //       final flight = _flightData[index];
                            //       return ListTile(
                            //         title: Text(flight['airline']),
                            //         subtitle: Text(
                            //             '${flight['city']} - ${flight['duration']}'),
                            //         trailing: Text('${flight['price']}'),
                            //       );
                                : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _filteredFlightData.length,
                                itemBuilder: (context, index) {
                                  final flight = _filteredFlightData[index];
                                  return ListTile(
                                    title: Text(flight['airline']),
                                    subtitle: Text('${flight['city']} - ${flight['duration']}'),
                                    trailing: Text('${flight['price']}'),
                                  );
                                },
                              ),


                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RealtimeSearchPage(),
  ));
}
