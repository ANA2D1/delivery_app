import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/offer_model.dart';

class OfferRepo {
  final ref = Firestore.instance.collection("Offers");
  Future<void> create(OfferModel offerModel) async {
    offerModel.id = DateTime.now().millisecondsSinceEpoch.toString();
    await _documentReference(offerModel).setData(offerModel.toJson());
  }

  Future<void> update(OfferModel offerModel) async {
    await _documentReference(offerModel).updateData(offerModel.toJson());
  }

  DocumentReference _documentReference(OfferModel offerModel) =>
      ref.document(offerModel.id);
}
