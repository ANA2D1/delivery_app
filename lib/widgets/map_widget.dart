import 'package:delivery_app/models/location_model.dart' as locationModel;
import 'package:delivery_app/models/shop_model.dart';
import 'package:delivery_app/repository/location_repo.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MapWidget extends StatefulWidget {
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller;
  _MapCoordinates _mapCoordinates;
  CameraPosition _initialLocation;

  // final CameraPosition _initialLocation = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(13.0278660, 77.6327798),
  //     // tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  @override
  void initState() {
    _mapCoordinates = _MapCoordinates();
    super.initState();
  }

  @override
  void dispose() {
    _mapCoordinates.dispose();
    if (_controller != null) {
      _controller.dispose();
    }

    super.dispose();
  }

  Size size;
  // final Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final loc = Provider.of<LocationRepo>(context)
        .locationCoordinates; // final loc = RepositoryProvider.of<LocationRepo>(context).locationData;
    _initialLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(loc.coordinates.latitude, loc.coordinates.longitude),
        // tilt: 59.440717697143555,
        zoom: 15);
    return new Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            onCameraMove: _onCameraMove,
            onMapCreated: _onCameracreated,
            myLocationEnabled: true,
            compassEnabled: true,
            // markers: _markers,
            initialCameraPosition: _initialLocation,
            mapToolbarEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Center(
            child: Icon(
              Icons.location_on,
              size: 50,
            ),
          ),
          Positioned(
            bottom: 15,
            // left: 0,
            child: Container(
              height: 60,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              // width: size.width - 30,
              child: StreamBuilder<locationModel.LocationModel>(
                  initialData: loc,
                  stream: _mapCoordinates._address,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && !snapshot.hasError) {
                      final location = snapshot.data;
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: size.width * 0.7),
                            child: Text(
                              location.addressLine,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                Navigator.pop(context, location);
                              })
                        ],
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CircularProgressIndicator(),
                          Text("Please wait ....")
                        ],
                      );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    _mapCoordinates._cameraPositions.add(position);
  }

  void _onCameracreated(GoogleMapController controller) {
    _controller = controller;
  }
}

class _MapCoordinates {
  final _cameraPositions = BehaviorSubject<CameraPosition>();
  final _address = BehaviorSubject<locationModel.LocationModel>();
  get cameraPosition => _cameraPositions.sink;
  get address => _address.stream;
  _MapCoordinates() {
    _cameraPositions
        .debounce((_) => TimerStream(true, Duration(seconds: 1)))
        .listen((position) async {
      try {
        final coordinates = new Coordinates(
            position.target.latitude, position.target.longitude);
        final addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        final first = addresses.first;
        print(first.toMap());
        this._address.add(locationModel.LocationModel.fromJson(first.toMap()));
      } catch (e) {}
    });
  }
  void dispose() {
    _cameraPositions.close();
    _address.close();
  }
}
