import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PriceDisplayPage extends StatefulWidget {
  @override
  _PriceDisplayPageState createState() => _PriceDisplayPageState();
}

class _PriceDisplayPageState extends State<PriceDisplayPage> {
  String priceResult = '';

  @override
  void initState() {
    super.initState();
    fetchDataAndDisplayResult();
  }

  Future<void> fetchDataAndDisplayResult() async {
    var url = Uri.parse('http://10.0.2.2:5000/predict');
    // Update with your Flask server URL
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'Airline': 'SpiceJet',
      'Source': 'Kolkata',
      'Destination': 'Cochin',
      'Total_Stops': '0 stops',
      'Additional_Info': 'No_info',
      'Date': '15',
      'Month': '10',
      'Year': '2019',
      'Arrival_hour': '2',
      'Arrival_min': '1',
      'Dept_hour': '22',
      'Dept_min': '22',
      'duration_hour': '2'
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // Successful response, parse and display output
        var data = jsonDecode(response.body);
        var price = data['price'];
        setState(() {
          priceResult = 'Price: $price';
        });
      } else {
        // Handle error response
        setState(() {
          priceResult = 'Failed with status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      // Handle network or server errors
      setState(() {
        priceResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Display Page'),
      ),
      body: Center(
        child: Text(
          priceResult,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
