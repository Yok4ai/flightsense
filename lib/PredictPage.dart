import 'package:flutter/material.dart';

class PredictionPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Price Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Airline'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Journey'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Source'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Destination'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Route'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Departure Time'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Arrival Time'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Total Stops'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Additional Info'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Perform prediction here
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Predicted Price'),
                        content: Text('The predicted price is \$1500'),
                        actions: [
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
                child: Text('Predict Price'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
