import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flightsense/pricetracker/notificationservice.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class PriceTracker extends StatefulWidget {
  @override
  PriceTrackerState createState() => PriceTrackerState();
}

class PriceTrackerState extends State<PriceTracker> {
  List<String> _prices = [];
  bool _isLoading = false;

  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _destinationCityController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _flightClassController = TextEditingController();
  final TextEditingController _targetPriceController = TextEditingController();

@override
void initState() {
  super.initState();
  _initializeNotifications();
  _loadUserInput(); // Load user input first
  FlightService().startPeriodicPriceCheck(); // Start price checks after
}

  @override
  void dispose() {
    _departureCityController.dispose();
    _destinationCityController.dispose();
    _departureDateController.dispose();
    _returnDateController.dispose();
    _flightClassController.dispose();
    _targetPriceController.dispose();
    super.dispose();
  }

  

  Future<void> _initializeNotifications() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        return;
      }
    }

    await FlightService().initializeNotifications();
  }

  Future<void> _loadUserInput() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _departureCityController.text = prefs.getString('departure_city') ?? '';
      _destinationCityController.text = prefs.getString('destination_city') ?? '';
      _departureDateController.text = prefs.getString('departure_date') ?? '';
      _returnDateController.text = prefs.getString('return_date') ?? '';
      _flightClassController.text = prefs.getString('flight_class') ?? '';
      _targetPriceController.text = prefs.getDouble('target_price')?.toString() ?? '';
    });
  }

  Future<void> startPeriodicPriceCheck() async {
  Timer.periodic(const Duration(seconds: 10), (timer) => _fetchPriceAndSetAlert());
}

  Future<void> _fetchPriceAndSetAlert() async {
    setState(() {
      _isLoading = true;
      _prices.clear();
    });
    await FlightService().fetchPriceAndSetAlert();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveAndFetchPrices() async {
    final departureCity = _departureCityController.text;
    final destinationCity = _destinationCityController.text;
    final departureDate = _departureDateController.text;
    final returnDate = _returnDateController.text;
    final flightClass = _flightClassController.text;
    final targetPrice = double.tryParse(_targetPriceController.text) ?? 0.0;

    await saveUserInput(
      departureCity: departureCity,
      destinationCity: destinationCity,
      departureDate: departureDate,
      returnDate: returnDate,
      flightClass: flightClass,
      targetPrice: targetPrice,
    );

    await _fetchPriceAndSetAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Display'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _departureCityController,
              decoration: InputDecoration(labelText: 'Departure City'),
            ),
            TextField(
              controller: _destinationCityController,
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
TextField(
controller: _flightClassController,
decoration: InputDecoration(labelText: 'Flight Class'),
),
TextField(
controller: _targetPriceController,
decoration: InputDecoration(labelText: 'Target Price'),
keyboardType: TextInputType.numberWithOptions(decimal: true),
),
SizedBox(height: 20),
_isLoading
? CircularProgressIndicator()
: ElevatedButton(
onPressed: _saveAndFetchPrices,
child: Text('Track Price'),
),
SizedBox(height: 20),
Expanded(
child: ListView.builder(
itemCount: _prices.length,
itemBuilder: (BuildContext context, int index) {
return ListTile(
title: Text(_prices[index]),
);
},
),
),
],
),
),
);
}

Future<void> saveUserInput({
required String departureCity,
required String destinationCity,
required String departureDate,
required String returnDate,
required String flightClass,
required double targetPrice,
}) async {
final SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('departure_city', departureCity);
await prefs.setString('destination_city', destinationCity);
await prefs.setString('departure_date', departureDate);
await prefs.setString('return_date', returnDate);
await prefs.setString('flight_class', flightClass);
await prefs.setDouble('target_price', targetPrice);
}
}