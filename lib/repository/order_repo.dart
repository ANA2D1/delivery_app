import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/order_model.dart';

class OrderRepo {
  final ref = Firestore.instance.collection("Orders");
  Future<String> create(OrderModel orderModel) async {
    if (orderModel != null) {
      final temp = DateTime.now().millisecondsSinceEpoch;
      orderModel.id = "ORD" + temp.toString().substring(3, 9);
      orderModel.timeStamp = DateTime.now();
      try {
        final data = orderModel.toJson();
        await _documentReference(orderModel).setData(data);
        return orderModel.id;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> update(OrderModel orderModel) async {
    if (orderModel != null) {
      try {
        await _documentReference(orderModel).updateData(orderModel.toJson());
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  Stream<List<OrderModel>> orders$() {
    return _FirestoreStream<List<OrderModel>>(
      ref: ref,
      parser: FirestoreOrderParser(),
    ).stream;
  }

  DocumentReference _documentReference(OrderModel orderModel) {
    return ref.document(orderModel.id);
  }
}

abstract class FirestoreNodeParser<T> {
  T parse(QuerySnapshot querySnapshot);
}

class FirestoreOrderParser extends FirestoreNodeParser<List<OrderModel>> {
  List<OrderModel> parse(QuerySnapshot querySnapshot) {
    var orders = querySnapshot.documents.map((snap) {
      return OrderModel.fromJson(snap.documentID, snap.data);
    }).toList();
    return orders;
  }
}

class _FirestoreStream<T> {
  Stream<T> stream;
  _FirestoreStream({CollectionReference ref, FirestoreNodeParser<T> parser}) {
    Stream<QuerySnapshot> snapshots = ref.snapshots();
    stream = snapshots.map((snapshot) => parser.parse(snapshot));
  }
}
