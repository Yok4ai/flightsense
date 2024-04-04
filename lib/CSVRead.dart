import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';





class CSVRead extends StatefulWidget {
  const CSVRead({Key? key}) : super(key: key);

  @override
  _CSVReadState createState() => _CSVReadState();
}

class _CSVReadState extends State<CSVRead> {
  List<List<dynamic>> _data = [];

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/data.csv");
    List<List<dynamic>> listData =
    const CsvToListConverter().convert(_rawData);

    int _currentIndex = 0;


    setState(() {
      _data = listData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlightSense"),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {

          return Card(
            margin: const EdgeInsets.all(3),
            color: index == 0 ? Colors.amber : Colors.white,
            child: ListTile(
              //  leading: Text(_data[index][0].toString()),
              //  title: Text(_data[index][1].toString()),
              // trailing: Text(_data[index][2].toString()),
              // subtitle: Text(_data[index][3].toString()),
              // title: Text(_data[index].join(', ')),
              // title: Text(_data[index].join(', ').substring(0, 1000)),
                title: Text('ID: ${_data[index][0]}'),
                subtitle: Text(
              'From: ${_data[index][1]}, To: ${_data[index][2]}, Price: ${_data[index][3]}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: _loadCSV),
      // Display the contents from the CSV file
    );
  }
}