import 'package:delivery_app/models/location_model.dart' as locationModel;
import 'package:delivery_app/models/shop_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

class LocationRepo extends ChangeNotifier {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  // LocationData _locationData;
  locationModel.LocationModel _locationCoordinates;
  // BehaviorSubject<LocationData> _locationStream;
  // Stream<LocationData> get location$ => this._locationStream.stream;
  locationModel.LocationModel get locationCoordinates =>
      this._locationCoordinates;
  LocationRepo() {
    location.onLocationChanged.listen((event) {
      _getAddress(event);
    });
    init();
  }
  _getAddress(LocationData event) async {
    final coordinates = new Coordinates(event.latitude, event.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final first = addresses.first;
    _locationCoordinates = locationModel.LocationModel.fromJson(first.toMap());

    notifyListeners();
  }

  void init() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    _getAddress(_locationData);
    notifyListeners();
    // if (_locationData != null) _locationStream.add(_locationData);
  }
}
