import 'package:flutter/material.dart';
import 'BookingPage.dart'; // Importing the BookingPage

class FlightDetailsPage extends StatelessWidget {
  final List<dynamic> row;

  FlightDetailsPage({required this.row});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 111, 30, 241),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 1, 73),
        leading: IconButton(
          icon: Icon(
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
            Text(
              'Flight Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingPage(row: row)),
                  );
                },
                child: Text('Book Flight'),
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
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
