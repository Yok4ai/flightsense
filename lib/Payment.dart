import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flightsense/BookingHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PaymentPage extends StatefulWidget {
  final double paymentAmount;
  final String flightCode;

  const PaymentPage({super.key, required this.paymentAmount, required this.flightCode});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> { 
  late Sslcommerz sslcommerz;

  @override
  void initState() {
    super.initState();
    sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash",
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: "fligh66295d63f242a",
        store_passwd: "fligh66295d63f242a@ssl",
        total_amount: widget.paymentAmount, // Use the payment amount passed from BookingPage
        tran_id: _generateUniqueTransactionId(),
      ),
    );
  }
  bool _isLoading = false;

void _showPaymentCompleteDialog() {
  // Update Firestore payment_status here
  FirebaseFirestore.instance.collection('bookings')
    .where('code', isEqualTo: widget.flightCode) // Use the received flight code
    .get()
    .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // Update the payment_status field for the found document
        doc.reference.update({'payment_status': 'Paid'});
      }
    })
    .catchError((error) => print("Failed to update payment status: $error"));

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Payment Complete'),
        content: const Text('Thank you for your payment!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingHistoryPage(),
                ),
              );
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}


String _generateUniqueTransactionId() {
  // Generate a unique transaction ID using a timestamp 
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  return timestamp;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 97, 3, 250),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                'Payment Amount: \$${widget.paymentAmount.toStringAsFixed(2)}', // Display the payment amount
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
      ElevatedButton(
           onPressed: () {
           setState(() {
          _isLoading = true;
              });
            _initiatePayment();
            },
  child: _isLoading
      ? const SpinKitDualRing(
          color: Color.fromARGB(255, 131, 6, 247),
          size: 30,
        )
          : const Text('Pay Now'),
          ),
          ],
        ),
      ),
    );
  }


void _initiatePayment() async {
  try {
    SSLCTransactionInfoModel result = await sslcommerz.payNow();

    if (result.status!.toLowerCase() == "failed") {
      // Handle payment failure
    } else {
      // Show the payment complete dialog
      _showPaymentCompleteDialog();
    }
  } catch (error) {
    // Handle errors that occurred during payment process
  }
}



  }

