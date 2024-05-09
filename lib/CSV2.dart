import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'FlightDetails.dart';

class CSVFlight extends StatefulWidget {
  const CSVFlight({super.key});

  @override
  CSVFlightState createState() => CSVFlightState();
}

class CSVFlightState extends State<CSVFlight> {
  List<List<dynamic>> csvData = [];
  List<List<dynamic>> filteredData = [];
  final TextEditingController _airlineSearchController = TextEditingController();
  final TextEditingController _fromSearchController = TextEditingController();
  final TextEditingController _toSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    final String csvString = await rootBundle.loadString('assets/economy.csv');
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvString);
    setState(() {
      csvData = rowsAsListOfValues;
      filteredData = csvData; // Initialize filteredData with all data
    });
  }

  void _searchAirline(String searchTerm) {
    setState(() {
      filteredData = csvData
          .where((row) => row[1].toString().contains(searchTerm))
          .toList();
    });
  }

  void _searchFrom(String searchTerm) {
    setState(() {
      filteredData = csvData
          .where((row) => row[3].toString().contains(searchTerm))
          .toList();
    });
  }

  void _searchTo(String searchTerm) {
    setState(() {
      filteredData = csvData
          .where((row) => row[7].toString().contains(searchTerm))
          .toList();
    });
  }

  void _searchCombined() {
    String airlineSearchTerm = _airlineSearchController.text;
    String fromSearchTerm = _fromSearchController.text;
    String toSearchTerm = _toSearchController.text;

    setState(() {
      filteredData = csvData
          .where((row) =>
              row[1].toString().contains(airlineSearchTerm) &&
              row[3].toString().contains(fromSearchTerm) &&
              row[7].toString().contains(toSearchTerm))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flights'),
      ),
      backgroundColor: const Color.fromARGB(255, 61, 31, 121),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _airlineSearchController,
              decoration: InputDecoration(
                hintText: 'Search Airline',
                hintStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _searchAirline(_airlineSearchController.text);
                  },
                ),
              ),
              style: const TextStyle(color: Colors.white), // Setting text color
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _fromSearchController,
              decoration: InputDecoration(
                hintText: 'Search From',
                hintStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _searchFrom(_fromSearchController.text);
                  },
                ),
              ),
              style: const TextStyle(color: Colors.white), // Setting text color
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _toSearchController,
              decoration: InputDecoration(
                hintText: 'Search To',
                hintStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _searchTo(_toSearchController.text);
                  },
                ),
              ),
              style: const TextStyle(color: Colors.white), // Setting text color
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _searchCombined,
              child: const Text('Search Combined'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                List<dynamic> row = filteredData[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightDetailsPage(row: row),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 74, 8, 128),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID ${index + 1}',
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 5),
                        Text('Airline: ${row[1]}',
                            style: const TextStyle(color: Colors.white)),
                        Text('Code: ${row[2]}',
                            style: const TextStyle(color: Colors.white)),
                        Text('From: ${row[3]}',
                            style: const TextStyle(color: Colors.white)),
                        Text('To: ${row[7]}',
                            style: const TextStyle(color: Colors.white)),
                        Text('Class: ${row[8]}',
                            style: const TextStyle(color: Colors.white)),
                        Text('Price: ${row[11]}',
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
