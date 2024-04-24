import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RateReviewPage extends StatefulWidget {
  final String bookingId; // Added bookingId parameter
  final String airline; // Added airline parameter
  final String from; // Added from parameter
  final String to; // Added to parameter
  final int price; // Added price parameter

  RateReviewPage({
    required this.bookingId,
    required this.airline,
    required this.from,
    required this.to,
    required this.price,
  });

  @override
  _RateReviewPageState createState() => _RateReviewPageState();
}

class _RateReviewPageState extends State<RateReviewPage> {
  double _rating = 0;
  String _review = '';

  // Function to submit the review and rating to Firestore
  Future<void> _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle if user is not logged in
      return;
    }

    final userEmail = user.email;
    if (userEmail == null) {
      // Handle if user email is null
      return;
    }

    FirebaseFirestore.instance.collection('reviews').add({
      'bookingId': widget.bookingId,
      'airline': widget.airline, // Add airline
      'from': widget.from, // Add from
      'to': widget.to, // Add to
      'price': widget.price, // Add price
      'userEmail': userEmail, // Add userEmail
      'rating': _rating,
      'review': _review,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate your flight experience:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Rating stars
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 1;
                    });
                  },
                  color: _rating >= 1 ? Colors.orange : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 2;
                    });
                  },
                  color: _rating >= 2 ? Colors.orange : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 3;
                    });
                  },
                  color: _rating >= 3 ? Colors.orange : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 4;
                    });
                  },
                  color: _rating >= 4 ? Colors.orange : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 5;
                    });
                  },
                  color: _rating >= 5 ? Colors.orange : Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 20),
            // Review text field
            TextField(
              onChanged: (value) {
                setState(() {
                  _review = value;
                });
              },
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Submit button
            ElevatedButton(
              onPressed: () {
                _submitReview();
                // Optionally, you can show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Review Submitted'),
                      content: Text('Thank you for your feedback!'),
                      actions: <Widget>[
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
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
