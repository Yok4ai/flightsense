import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// Importing the BookingHistoryPage
import 'Payment.dart';

class BookingPage extends StatelessWidget {
  final List<dynamic> row;

  const BookingPage({super.key, required this.row});

      String generateBookingID() {
      final Random random = Random();
      return '${random.nextInt(10000000)}';
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 111, 30, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flight Details',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            _buildFlightDetailsCard(),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveBookingToFirebase(row, context);
                },
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightDetailsCard() {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Airline', '${row[1]}'),
            _buildDetailRow('Code', '${row[2]}'),
            _buildDetailRow('From', '${row[3]}'),
            _buildDetailRow('Departure', '${row[4]}'),
            _buildDetailRow('Stops', '${row[5]}'),
            _buildDetailRow('Arrival', '${row[6]}'),
            _buildDetailRow('To', '${row[7]}'),
            _buildDetailRow('Class', '${row[8]}'),
            _buildDetailRow('Duration', '${row[9]}'),
            _buildDetailRow('Price', '${row[11]}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBookingToFirebase(
      List<dynamic> bookingData, BuildContext context) async {
    await Firebase.initializeApp();
    final CollectionReference bookings =
        FirebaseFirestore.instance.collection('bookings');
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Get the currently logged-in user's email
    final User? user = auth.currentUser;
    final String? userEmail = user?.email;

    await bookings.add({
      'airline': bookingData[1],
      'code': bookingData[2],
      'from': bookingData[3],
      'departure': bookingData[4],
      'stops': bookingData[5],
      'arrival': bookingData[6],
      'to': bookingData[7],
      'class': bookingData[8],
      'duration': bookingData[9],
      'price': bookingData[11],
      'user_email': userEmail, // Add the user's email to the booking data
      'timestamp': DateTime.now(),
      'payment_status': 'Pending',
    });

    // // Navigate to BookingHistoryPage after saving booking
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const BookingHistoryPage()),
    // );

      Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        paymentAmount: row[11].toDouble(),
                        flightCode: row[2], // Pass the flight code as a parameter
                      ),
                    ),
                  );

  }
}
