import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/location_model.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/repository/location_repo.dart';
import 'package:delivery_app/repository/offer_repo.dart';
import 'package:delivery_app/repository/user_repo.dart';
import 'package:delivery_app/screens/partner_pages/map_location_page.dart';
import 'package:delivery_app/utils/enums.dart';
import 'package:delivery_app/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PartnerOrderList extends StatefulWidget {
  @override
  _PartnerOrderListState createState() => _PartnerOrderListState();
}

class _PartnerOrderListState extends State<PartnerOrderList> {
  StreamSubscription _streamSubscription;
  List<OrderModel> orders;
  LocationModel loc;
  bool loading = false;
  @override
  void initState() {
    setState(() {
      loading = true;
    });
    _streamSubscription = Firestore.instance
        .collection("Orders")
        .where("status", isEqualTo: OrderStatus.subitted.index)
        .snapshots()
        .listen((snap) {
      print("decument changes");
      if (snap.documents.isNotEmpty) {
        orders = snap.documents
            .map((e) => OrderModel.fromJson(e.documentID, e.data))
            .toList();
      }
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loc = Provider.of<LocationRepo>(context).locationCoordinates;
    return Scaffold(
      appBar: AppBar(
        title: Text("You are on duty"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : orders != null
              ? ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, i) {
                    double d1, d2;

                    d1 = Utils.getDistance(
                        startLat: loc.coordinates.latitude,
                        startLong: loc.coordinates.longitude,
                        endLat: orders[i].pickupLocation.coordinates.latitude,
                        endLong:
                            orders[i].pickupLocation.coordinates.longitude);
                    d2 = Utils.getDistance(
                        startLat: orders[i].pickupLocation.coordinates.latitude,
                        startLong:
                            orders[i].pickupLocation.coordinates.longitude,
                        endLat: orders[i].dropLocation.coordinates.latitude,
                        endLong: orders[i].dropLocation.coordinates.longitude);
                    return PartnerOrderListTile(
                      d1: d1,
                      d2: d2,
                      orderModel: orders[i],
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => MapLocationPage(
                                  orderModel: orders[i],
                                  d1: d1,
                                  d2: d2,
                                )));

                        // setState(() {
                        //   loading = false;
                        // });
                      },
                    );
                  })
              : Center(
                  child: Text("No orders!"),
                ),
    );
  }
}

class PartnerOrderListTile extends StatelessWidget {
  final OrderModel orderModel;
  final VoidCallback onTap;
  final d1;
  final d2;
  const PartnerOrderListTile(
      {@required this.orderModel, this.onTap, this.d1, this.d2});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(orderModel.shop != null
                  ? orderModel.shop.name
                  : "Package delivery"),
              subtitle: Text(orderModel.description),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (orderModel.type == OrderType.shopping) ...[
                  Column(
                    children: [Icon(Icons.gps_fixed), Text("You")],
                  ),
                  Text("$d1 km"),
                  Column(
                    children: [Icon(Icons.flag), Text("Pick up")],
                  ),
                  Text("$d2 km"),
                  Column(
                    children: [Icon(Icons.home), Text("drop")],
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
