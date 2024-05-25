import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PriceDisplayPage extends StatefulWidget {
  @override
  _PriceDisplayPageState createState() => _PriceDisplayPageState();
}

class _PriceDisplayPageState extends State<PriceDisplayPage> {
  String priceResult = '';

  final airlineController = TextEditingController();
  final sourceController = TextEditingController();
  final destinationController = TextEditingController();
  final stopsController = TextEditingController();
  final infoController = TextEditingController();
  final dateController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final arrivalHourController = TextEditingController();
  final arrivalMinController = TextEditingController();
  final deptHourController = TextEditingController();
  final deptMinController = TextEditingController();
  final durationHourController = TextEditingController();

  Future<void> fetchDataAndDisplayResult() async {
    var url = Uri.parse('http://10.0.2.2:5000/predict');  // Update with your Flask server URL
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'Airline': airlineController.text,
      'Source': sourceController.text,
      'Destination': destinationController.text,
      'Total_Stops': stopsController.text,
      'Additional_Info': infoController.text,
      'Date': dateController.text,
      'Month': monthController.text,
      'Year': yearController.text,
      'Arrival_hour': arrivalHourController.text,
      'Arrival_min': arrivalMinController.text,
      'Dept_hour': deptHourController.text,
      'Dept_min': deptMinController.text,
      'duration_hour': durationHourController.text
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var price = data['price'];
        setState(() {
          priceResult = 'Price: $price';
        });
        // Show dialog with the predicted price
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Predicted Price'),
              content: Text('predicted $priceResult'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          priceResult = 'Failed with status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        priceResult = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    airlineController.dispose();
    sourceController.dispose();
    destinationController.dispose();
    stopsController.dispose();
    infoController.dispose();
    dateController.dispose();
    monthController.dispose();
    yearController.dispose();
    arrivalHourController.dispose();
    arrivalMinController.dispose();
    deptHourController.dispose();
    deptMinController.dispose();
    durationHourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Display Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: airlineController,
              decoration: InputDecoration(labelText: 'Airline'),
            ),
            TextField(
              controller: sourceController,
              decoration: InputDecoration(labelText: 'Source'),
            ),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            TextField(
              controller: stopsController,
              decoration: InputDecoration(labelText: 'Total Stops'),
            ),
            TextField(
              controller: infoController,
              decoration: InputDecoration(labelText: 'Additional Info'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: monthController,
              decoration: InputDecoration(labelText: 'Month'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: yearController,
              decoration: InputDecoration(labelText: 'Year'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: arrivalHourController,
              decoration: InputDecoration(labelText: 'Arrival Hour'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: arrivalMinController,
              decoration: InputDecoration(labelText: 'Arrival Minute'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: deptHourController,
              decoration: InputDecoration(labelText: 'Departure Hour'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: deptMinController,
              decoration: InputDecoration(labelText: 'Departure Minute'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationHourController,
              decoration: InputDecoration(labelText: 'Duration Hour'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchDataAndDisplayResult,
              child: Text('Predict Price'),
            ),
            SizedBox(height: 20),
            Text(
              priceResult,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PriceDisplayPage(),
  ));
}
