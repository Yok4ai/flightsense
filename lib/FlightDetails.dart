import 'package:flutter/material.dart';
import 'BookingPage.dart'; // Importing the BookingPage

class FlightDetailsPage extends StatelessWidget {
  final List<dynamic> row;

  const FlightDetailsPage({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 111, 30, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 1, 73),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flight Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
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
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingPage(row: row)),
                  );
                },
                child: const Text('Book Flight'),
              ),
            ),
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
}
