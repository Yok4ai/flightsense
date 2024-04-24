import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/RateReviewPage.dart'; // Import the RateReviewPage

class BookingHistoryPage extends StatefulWidget {
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
    final String? userEmail = user != null ? user.email : null;

    setState(() {
      // Query Firestore to get bookings associated with the current user's email
      bookingData = FirebaseFirestore.instance
          .collection('bookings')
          .where('user_email', isEqualTo: userEmail)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: bookingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No bookings found.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data!.docs[index];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(booking.id)
                    .get(),
                builder: (context, bookingSnapshot) {
                  if (bookingSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (bookingSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${bookingSnapshot.error}'),
                    );
                  }
                  if (!bookingSnapshot.hasData) {
                    return Center(
                      child: Text('Booking data not found.'),
                    );
                  }
                  var bookingData = bookingSnapshot.data!;
                  return ListTile(
                    title: Text(bookingData['airline']),
                    subtitle: Text(
                        'From: ${bookingData['from']} To: ${bookingData['to']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.rate_review),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RateReviewPage(
                              bookingId: booking.id,
                              airline: bookingData['airline'],
                              from: bookingData['from'],
                              to: bookingData['to'],
                              price: bookingData['price'],
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
