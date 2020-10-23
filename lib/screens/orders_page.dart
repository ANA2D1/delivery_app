import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/screens/order_chat_page.dart';
import 'package:delivery_app/utils/constants.dart';
import 'package:delivery_app/utils/enums.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  StreamSubscription _subscription;
  List<OrderModel> _orderModels;
  @override
  void initState() {
    _subscription = Firestore.instance
        .collection("Orders")
        .where("user_id", isEqualTo: Constants.customerId)
        .snapshots()
        .listen((snap) {
      if (snap.documents.isNotEmpty) {
        _orderModels = snap.documents
            .map((d) => OrderModel.fromJson(d.documentID, d.data))
            .toList();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: _orderModels != null
          ? ListView.builder(
              itemCount: _orderModels.length,
              itemBuilder: (c, i) => OrderListTile(
                orderModel: _orderModels[i],
              ),
            )
          : Center(
              child: Text("No orders!"),
            ),
    );
  }
}

class OrderListTile extends StatelessWidget {
  const OrderListTile({Key key, this.orderModel}) : super(key: key);
  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OrderOfferPage(orderModel: orderModel))),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.shopping_basket),
                  ),
                  title: Text(
                    orderModel.type == OrderType.shopping
                        ? "Order | #${orderModel.id}"
                        : "Package | #${orderModel.id}",
                    // style: TextStyle(
                    //     fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${orderModel.description}",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                Divider(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getOrderStatus(orderModel.status)),
                    SizedBox(
                      width: 100,
                      height: 2,
                      child: LinearProgressIndicator(),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getOrderStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.subitted:
        return "Waiting for offers";
        break;
      case OrderStatus.assigned:
        return "Processing";
        break;
      case OrderStatus.cancelled:
        return "Cancelled";
        break;
      case OrderStatus.completed:
        return "Completed";
        break;
      default:
        return "Loading..";
    }
  }
}
