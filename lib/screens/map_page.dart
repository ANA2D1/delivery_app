import 'package:delivery_app/models/location_model.dart';
import 'package:delivery_app/utils/utils.dart';
import 'package:delivery_app/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PickAndDropMap extends StatefulWidget {
  @override
  _PickAndDropMapState createState() => _PickAndDropMapState();
}

class _PickAndDropMapState extends State<PickAndDropMap> {
  LocationModel _pickLoc;
  LocationModel _dropLoc;
  double distance;

  @override
  Widget build(BuildContext context) {
    if (_pickLoc != null && _dropLoc != null) {
      distance = Utils.getDistance(
          startLat: _pickLoc.coordinates.latitude,
          startLong: _pickLoc.coordinates.longitude,
          endLat: _dropLoc.coordinates.latitude,
          endLong: _dropLoc.coordinates.longitude);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Map Page"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: 50,
                // alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => MapWidget()))
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          _pickLoc = value;
                        });
                      }
                    });
                  },
                  leading: Text("Pick"),
                  title: Text(
                    _pickLoc != null
                        ? "${_pickLoc.addressLine}"
                        : "Pickup location",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: 50,
                // alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: ListTile(
                  onTap: _pickLoc != null
                      ? () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => MapWidget()))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                _dropLoc = value;
                              });
                            }
                          });
                        }
                      : null,
                  leading: Text("Drop"),
                  title: Text(
                    _dropLoc != null
                        ? "${_dropLoc.addressLine}"
                        : "Drop up location",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: 50,
                // alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(distance != null
                      ? "$distance km"
                      : "Please select pick and drop location"),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: _dropLoc == null
                        ? null
                        : () => Navigator.pop(
                            context, [_pickLoc, _dropLoc, distance]),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
//  Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (_) => MapWidget()))
//                 .then((value) {
//               if (value != null) {
//                 print(value.addressLine);
//               }
//             });
