import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewShowPage extends StatefulWidget {
  const ReviewShowPage({super.key});

  @override
  _ReviewShowPageState createState() => _ReviewShowPageState();
}

class _ReviewShowPageState extends State<ReviewShowPage> {
  late Future<List<String>> _airlines;
  late Map<String, List<DocumentSnapshot>> _reviews;

  @override
  void initState() {
    super.initState();
    _airlines = Future.value([]); // Initialize _airlines to an empty list
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('reviews').get();
    List<DocumentSnapshot> documents = snapshot.docs;

    Map<String, List<DocumentSnapshot>> reviews = {};

    for (var review in documents) {
      String airline = review['airline'];
      if (!reviews.containsKey(airline)) {
        reviews[airline] = [];
      }
      reviews[airline]!.add(review);
    }

    List<String> airlines = reviews.keys.toList()
      ..sort(); // Sort airlines alphabetically

    setState(() {
      _reviews = reviews;
      _airlines = Future.value(airlines);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: FutureBuilder<List<String>>(
        future: _airlines,
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
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No reviews found.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              String airline = snapshot.data![index];
              return ListTile(
                title: Text(airline),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AirlineReviewsPage(reviews: _reviews[airline]!),
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

class AirlineReviewsPage extends StatelessWidget {
  final List<DocumentSnapshot> reviews;

  const AirlineReviewsPage({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airline Reviews'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          var review = reviews[index];
          return ListTile(
            title: Text('Airline: ${review['airline']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From: ${review['from']}'),
                Text('To: ${review['to']}'),
                Text('Price: ${review['price']}'),
                Text('User: ${review['userEmail']}'),
                Text('Review: ${review['review']}'),
                Text('Rating: ${review['rating']}'),
                Text('Date: ${_formatDate(review['timestamp'])}'),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
