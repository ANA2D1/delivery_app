import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/offer_model.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/repository/offer_repo.dart';
import 'package:delivery_app/repository/user_repo.dart';
import 'package:delivery_app/utils/constants.dart';
import 'package:delivery_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_google_maps/flutter_google_maps.dart';
// import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationPage extends StatefulWidget {
  final OrderModel orderModel;
  final double d1;
  final d2;
  MapLocationPage({this.orderModel, this.d1, this.d2});
  @override
  _MapLocationPageState createState() => _MapLocationPageState();
}

class _MapLocationPageState extends State<MapLocationPage> {
  GoogleMapController _controller;
  CameraPosition _initialLocation;
  Set<Marker> _markers;
  bool loading = true;
  bool showMap;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // StreamSubscription _subscription;
  double _price;
  // OrderModel orderModel;
  @override
  void initState() {
    // _subscription = Firestore.instance
    //     .collection("Orders")
    //     .document(widget.orderModel.id)
    //     .snapshots()
    //     .listen((event) {
    //   if (event.exists) {
    //     orderModel = OrderModel.fromJson(event.documentID, event.data);

    //   }
    // });
    checkIfexist(context);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  checkIfexist(context) {
    // final user = RepositoryProvider.of<UserRepo>(context).user;
    Firestore.instance
        .collection("Offers")
        .where("order_id", isEqualTo: widget.orderModel.id)
        .where("partner_id", isEqualTo: Constants.partnerId)
        .getDocuments()
        .then((snap) {
      if (snap.documents.isNotEmpty) {
        showMap = false;
      } else {
        showMap = true;
        final order = widget.orderModel;

        _initialLocation = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(order.pickupLocation.coordinates.latitude,
                order.pickupLocation.coordinates.longitude),
            // tilt: 59.440717697143555,
            zoom: 15.151926040649414);
        _markers = {
          Marker(
            markerId: MarkerId('Pick up'),
            position: LatLng(order.pickupLocation.coordinates.latitude,
                order.pickupLocation.coordinates.longitude),
            infoWindow: InfoWindow(title: 'Pick up'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueCyan,
            ),
          ),
          Marker(
            markerId: MarkerId('Drop'),
            position: LatLng(order.dropLocation.coordinates.latitude,
                order.dropLocation.coordinates.longitude),
            infoWindow: InfoWindow(title: 'Drop'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        };
      }
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      key: _scaffoldKey,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : widget.orderModel.status == OrderStatus.assigned &&
                  widget.orderModel.partnerId != Constants.partnerId
              ? Center(
                  child: Text("Order assigned to someone else!"),
                )
              : showMap
                  ? Column(
                      children: [
                        // Expanded(child: _buildGoogleMap()),
                        Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Pick up ${widget.d1}"),
                                  VerticalDivider(),
                                  Text("Drop up ${widget.d2}"),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (str) {
                                    _price = double.parse(str);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Delivery cost",
                                      suffixIcon: IconButton(
                                          icon: Icon(Icons.arrow_forward),
                                          onPressed: () async {
                                            if (_price != null && _price > 0) {
                                              // final partner =
                                              //     RepositoryProvider.of<UserRepo>(context)
                                              //         .user;
                                              final offer = OfferModel(
                                                  customerId:
                                                      widget.orderModel.userId,
                                                  orderId: widget.orderModel.id,
                                                  partnerId: "partner id",
                                                  price: _price,
                                                  status: OfferStatus.sent);
                                              await RepositoryProvider.of<
                                                      OfferRepo>(context)
                                                  .create(offer);
                                              setState(() {
                                                showMap = false;
                                              });
                                            }
                                          })),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : _chatWidget(context),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: _onCameracreated,
      myLocationEnabled: true,
      compassEnabled: true,
      markers: _markers,
      initialCameraPosition: _initialLocation,
      mapToolbarEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  void _onCameracreated(GoogleMapController controller) {
    _controller = controller;
  }

  _chatWidget(BuildContext context) {
    return Center(
      child: Text("chats"),
    );
  }
}
