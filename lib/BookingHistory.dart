import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/RateReviewPage.dart'; // Import the RateReviewPage

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  late Future<QuerySnapshot> bookingData;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await Firebase.initializeApp();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? userEmail = user?.email;

    setState(() {
      // Query Firestore to get bookings associated with the current user's email
      bookingData = FirebaseFirestore.instance
          .collection('bookings')
          .where('user_email', isEqualTo: userEmail)
          .get();
    });
  }

  String _formatTimestamp(Timestamp timestamp) {
  var date = timestamp.toDate();
  return '${date.day}/${date.month}/${date.year} ${_formatTime(date.hour, date.minute)}';
}

String _formatTime(int hour, int minute) {
  String hourStr = hour.toString().padLeft(2, '0');
  String minuteStr = minute.toString().padLeft(2, '0');
  return '$hourStr:$minuteStr';
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: bookingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No bookings found.'),
            );
          }



 return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    var booking = snapshot.data!.docs[index];
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('code', isEqualTo: booking['code'])
          .where('payment_status', isEqualTo: 'Paid')
          // .where('user_email', isEqualTo: booking['user_email'])
          .snapshots(),
      builder: (context, bookingSnapshot) {
        if (bookingSnapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (bookingSnapshot.hasError) {
          return Center(
            child: Text('Error: ${bookingSnapshot.error}'),
          );
        }
        if (bookingSnapshot.data == null ||
            bookingSnapshot.data!.docs.isEmpty) {
          // If no documents match the query, display disabled ListTile
          return ListTile(
            title: Text(
              booking['airline'],
              style: const TextStyle(color: Colors.grey), // Gray out the text
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'From: ${booking['from']} To: ${booking['to']}',
                  style: const TextStyle(color: Colors.grey), // Gray out the text
                ),
                Text(
                  'Flight Code: ${booking['code']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // Gray out the text
                  ),
                ),
                Text(
                  'Booked on: ${_formatTimestamp(booking['timestamp'])}', // Display timestamp
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey, // Gray out the text
                  ),
                ),
              ],
            ),
            trailing: const IconButton(
              icon: Icon(Icons.rate_review),
              onPressed: null, // Disable onPressed
            ),
          );
        }
        // If documents match the query, allow review
        var bookingData = bookingSnapshot.data!.docs[0];
        return ListTile(
          title: Text(booking['airline']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From: ${booking['from']} To: ${booking['to']}',
              ),
              Text(
                'Flight Code: ${booking['code']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Booked on: ${_formatTimestamp(booking['timestamp'])}', // Display timestamp
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.rate_review),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RateReviewPage(
                    bookingId: booking.id,
                    airline: booking['airline'],
                    from: booking['from'],
                    to: booking['to'],
                    price: booking['price'],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  },
);

        },
      ),
    );
  }
}
