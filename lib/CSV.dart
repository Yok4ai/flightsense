import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class CSVPage extends StatefulWidget {
  const CSVPage({super.key});

  //comment

  @override
  _CSVPageState createState() => _CSVPageState();
}

class _CSVPageState extends State<CSVPage> {
  List<List<dynamic>> csvData = [];

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    final String csvString = await rootBundle.loadString('assets/data.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
    setState(() {
      csvData = rowsAsListOfValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Data'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: csvData.length,
          itemBuilder: (BuildContext context, int index) {
            List<dynamic> row = csvData[index];
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID ${index + 1}'),
                  const SizedBox(height: 5),
                  Text('Name: ${row[1]}'),
                  Text('From: ${row[2]}'),
                  Text('To: ${row[3]}'),
                  Text('Price: ${row[4]}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}