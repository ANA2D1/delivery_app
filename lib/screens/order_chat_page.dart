import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/offer_model.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/utils/enums.dart';
import 'package:flutter/material.dart';

class OrderOfferPage extends StatefulWidget {
  final OrderModel orderModel;
  const OrderOfferPage({@required this.orderModel});
  @override
  _OrderChatPageState createState() => _OrderChatPageState();
}

class _OrderChatPageState extends State<OrderOfferPage> {
  StreamSubscription _subscription;
  List<OfferModel> offers;
  bool showChat = false;
  @override
  void initState() {
    if (widget.orderModel.status == OrderStatus.assigned) {
      _subscription = _subscription = Firestore.instance
          .collection("Offers")
          .where("order_id", isEqualTo: widget.orderModel.id)
          .where("partner_id", isEqualTo: widget.orderModel.partnerId)
          .snapshots()
          .listen((event) {
        if (event.documents.isNotEmpty) {
          offers = event.documents
              .map((e) => OfferModel.fromJson(e.documentID, e.data))
              .toList();
          setState(() {
            showChat = true;
          });
        }
      });
    } else {
      _subscription = Firestore.instance
          .collection("Offers")
          .where("order_id", isEqualTo: widget.orderModel.id)
          .snapshots()
          .listen((snap) {
        if (snap.documents.isNotEmpty) {
          offers = snap.documents
              .map((d) => OfferModel.fromJson(d.documentID, d.data))
              .toList();
          setState(() {});
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var chatView = _chatView();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orderModel.type == OrderType.shopping
            ? "Order | #${widget.orderModel.id}"
            : "Package | #${widget.orderModel.id}"),
      ),
      body: offers != null
          ? showChat
              ? chatView
              : ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, i) => OfferListTile(
                        offerModel: offers[i],
                      ))
          : Center(
              child: Text("Waiting for offers"),
            ),
    );
  }

  _chatView() {
    return Center(
        child: Text(
      "Chat view",
    ));
  }
}

class OfferListTile extends StatelessWidget {
  final OfferModel offerModel;
  const OfferListTile({this.offerModel});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person),
                ),
                title: Text("Delivery cost : \$ ${offerModel.price}"),
              ),
              Divider(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    onPressed: () {},
                    child: Text("Accept"),
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Text("Reject"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
