import 'dart:async';
import 'package:flightsense/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  final Set<Marker> _markers = <Marker>{};
  final Set<Polygon> _polygons = <Polygon>{};
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 13.4746,
  );

  @override
  void initState() {
    super.initState();

    _setMarkers(LatLng(37.42796133580664, -122.085749699962),
        LatLng(37.42796133580664, -122.085749699962));
  }

  void _setMarkers(LatLng originPoint, LatLng destinationPoint) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('origin_marker'),
          position: originPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen), // Green marker for origin
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('destination_marker'),
          position: destinationPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed), // Red marker for destination
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 5,
        color: Color.fromARGB(255, 47, 33, 243),
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _originController,
                          decoration:
                              const InputDecoration(hintText: ' Origin'),
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _destinationController,
                          decoration:
                              const InputDecoration(hintText: ' Destination'),
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    var directions = await LocationService().getDirections(
                      _originController.text,
                      _destinationController.text,
                    );
                    if (directions.isNotEmpty) {
                      _goToPlace(
                        directions['start_location']['lat'],
                        directions['start_location']['lng'],
                        directions['end_location']['lat'],
                        directions['end_location']['lng'],
                        directions['bounds_ne'],
                        directions['bounds_sw'],
                      );

                      _setPolyline(directions['polyline_decoded']);
                    } else {
                      // Handle case when directions list is empty
                      print('No directions found.');
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                polygons: _polygons,
                polylines: _polylines,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: (point) {
                  setState(() {
                    polygonLatLngs.add(point);
                    _setPolygon();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> _goToPlace(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;

    // Set camera position to fit both origin and destination markers
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
      northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
    );

    LatLng center = LatLng(
      (originLat + destLat) / 2,
      (originLng + destLng) / 2,
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        100, // padding value in pixels
      ),
    );

    _setMarkers(LatLng(originLat, originLng), LatLng(destLat, destLng));
  }
}
