import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FlightService {
  static final FlightService _instance = FlightService._internal();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory FlightService() {
    return _instance;
  }

  FlightService._internal();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

    Future<void> startPeriodicPriceCheck() async {
    Timer.periodic(const Duration(seconds: 10), (timer) => fetchPriceAndSetAlert());
  }

  Future<void> fetchPriceAndSetAlert() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final departureCity = prefs.getString('departure_city') ?? '';
    final destinationCity = prefs.getString('destination_city') ?? '';
    final departureDate = prefs.getString('departure_date') ?? '';
    final returnDate = prefs.getString('return_date') ?? '';
    final flightClass = prefs.getString('flight_class') ?? '';
    final targetPrice = prefs.getDouble('target_price') ?? 0.0;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/search-flights'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'departure_city': departureCity,
          'destination_city': destinationCity,
          'departure_date': departureDate,
          'return_date': returnDate,
          'flight_class': flightClass,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('flights')) {
          final List<dynamic> flights = data['flights'];
          final List<String> prices = flights.map((flight) {
            final price = flight['price'];
            return double.parse(price.replaceAll('\$', '').replaceAll(',', '')).toStringAsFixed(2);
          }).toList();
          _setAlert(prices, targetPrice);
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _setAlert(List<String> prices, double targetPrice) async {
    for (var price in prices) {
      final double parsedPrice = double.parse(price);
      if (parsedPrice <= targetPrice) {
        _showNotification(price);
      }
    }
  }

  Future<void> _showNotification(String price) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'price_alert_channel',
      'Price Alerts',
      channelDescription: 'Notifications for flight price alerts',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Price Match Alert',
      'A flight is available for \$${price} which matches your target price!',
      platformChannelSpecifics,
    );
  }
}
