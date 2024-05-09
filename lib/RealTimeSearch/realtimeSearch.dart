import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RealtimeSearchPage extends StatefulWidget {
  @override
  _RealtimeSearchPageState createState() => _RealtimeSearchPageState();
}

class _RealtimeSearchPageState extends State<RealtimeSearchPage> {
  TextEditingController _departureController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _departureDateController = TextEditingController();
  TextEditingController _returnDateController = TextEditingController();
  bool _isEconomy = true; // Default to Economy class
  List<Map<String, dynamic>> _flightData = []; // Store retrieved flight data
  bool _showSearchOptions = true; // Control whether to show search options

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
      // Send POST request to your Flask endpoint
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
          _showSearchOptions = false; // Hide search options when results are shown
        });
      } else {
        // Handle error
        print('Failed to retrieve flight data. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle error
      print('Error occurred while searching flights: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Realtime Search'),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _departureController,
                        decoration: InputDecoration(labelText: 'Departure City'),
                      ),
                      TextField(
                        controller: _destinationController,
                        decoration: InputDecoration(labelText: 'Destination City'),
                      ),
                      TextField(
                        controller: _departureDateController,
                        decoration: InputDecoration(labelText: 'Departure Date (YYYY-MM-DD)'),
                      ),
                      TextField(
                        controller: _returnDateController,
                        decoration: InputDecoration(labelText: 'Return Date (YYYY-MM-DD)'),
                      ),
                      Row(
                        children: [
                          Text('Economy Class'),
                          Switch(
                            value: _isEconomy,
                            onChanged: (value) {
                              setState(() {
                                _isEconomy = value;
                              });
                            },
                          ),
                          Text('Premium Class'),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _realtimeSearch,
                        child: Text('Search Flights'),
                      ),
                    ],
                  ),
                ),
                _showSearchOptions
                    ? SizedBox() // If search options are shown, show an empty SizedBox
                    : Expanded(
                        child: _flightData.isEmpty
                            ? Center(child: Text('No flight data available'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _flightData.length,
                                itemBuilder: (context, index) {
                                  final flight = _flightData[index];
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
  runApp(MaterialApp(
    home: RealtimeSearchPage(),
  ));
}
