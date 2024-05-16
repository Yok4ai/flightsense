import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  String _currentLocation = 'Unknown';

  String getCurrentLocation() {
    _getLocationPermission().then((permission) {
      if (permission == LocationPermission.denied) {
        _currentLocation = 'Location permission denied.';
      } else {
        try {
          Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).then((Position position) async {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );

            if (placemarks != null && placemarks.isNotEmpty) {
              Placemark place = placemarks[0];
              _currentLocation =
                  "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
            } else {
              _currentLocation = 'No location data available.';
            }
          }).catchError((e) {
            _currentLocation = 'Error getting location: $e';
          });
        } catch (e) {
          _currentLocation = 'Error getting location: $e';
        }
      }
    });
    return _currentLocation;
  }

  Future<LocationPermission> _getLocationPermission() async {
    final PermissionStatus permissionStatus =
        await Permission.location.request();
    return permissionStatus == PermissionStatus.granted
        ? LocationPermission.always
        : LocationPermission.denied;
  }
}
