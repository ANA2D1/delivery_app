// var order = {
//   "id": "",
//   "user_id": "",
//   "partner_id": "",
//   "pickup_location": "",
//   "drop_location": "",
//   "min_price": 0.0,
//   "max_price": 0.0,
//   "description": "",
//   "final_price": 0.0,
//   "attachments": [""],
//   "time_stamp": "",
//   "completion_time": "",
//   "chats": [
//     {"type": "", "value": "", "sender_id": "", "time_stamp": ""}
//   ]
// };

import 'package:delivery_app/models/location_model.dart';
import 'package:delivery_app/models/shop_model.dart';
import 'package:delivery_app/utils/enums.dart';

class OrderModel {
  String id;
  OrderType type;
  String userId;
  String partnerId;
  ShopModel shop;
  double distance;
  LocationModel pickupLocation;
  LocationModel dropLocation;
  int minPrice;
  int maxPrice;
  List<ItemModel> items;
  String description;
  int finalPrice;
  List<String> attachments;
  DateTime timeStamp;
  DateTime completionTime;
  List<Chats> chats;
  OrderStatus status;
  OrderModel(
      {this.id,
      this.userId,
      this.type,
      this.partnerId,
      this.distance,
      this.pickupLocation,
      this.dropLocation,
      this.minPrice,
      this.maxPrice,
      this.description,
      this.finalPrice,
      this.attachments,
      this.timeStamp,
      this.completionTime,
      this.chats,
      this.items,
      this.status,
      this.shop});

  OrderModel.fromJson(String key, Map<dynamic, dynamic> json) {
    id = key;
    type = json['type'] != null ? OrderType.values[json['type']] : null;
    status = json['status'] != null ? OrderStatus.values[json['status']] : null;
    userId = json['user_id'];
    partnerId = json['partner_id'];
    distance = json['distance'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    description = json['description'];
    finalPrice = json['final_price'];
    attachments = json['attachments']?.cast<String>();
    timeStamp = json['time_stamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['time_stamp'])
        : null;
    completionTime = json['completion_time'] != null
        ? DateTime.fromMicrosecondsSinceEpoch(json['completion_time'])
        : null;
    if (json['shop'] != null) {
      shop = ShopModel.fromJson(json['shop']);
    }
    if (json['pickup_location'] != null) {
      pickupLocation = LocationModel.fromJson(json['pickup_location']);
    }
    if (json['drop_location'] != null) {
      dropLocation = LocationModel.fromJson(json['drop_location']);
    }
    if (json['chats'] != null) {
      chats = new List<Chats>();
      json['chats'].forEach((v) {
        chats.add(new Chats.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = new List<ItemModel>();
      json['items'].forEach((v) {
        items.add(new ItemModel.fromJson('', v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['user_id'] = this.userId;
    data['type'] = this.type.index;
    data['status'] = this.status.index;
    data['partner_id'] = this.partnerId;
    data['distance'] = this.distance;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['description'] = this.description;
    data['final_price'] = this.finalPrice;
    data['attachments'] = this.attachments;
    data['time_stamp'] = this.timeStamp?.millisecondsSinceEpoch;
    data['completion_time'] = this.completionTime?.millisecondsSinceEpoch;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    if (this.pickupLocation != null) {
      data['pickup_location'] = this.pickupLocation.toJson();
    }
    if (this.dropLocation != null) {
      data['drop_location'] = this.dropLocation.toJson();
    }
    if (this.chats != null) {
      data['chats'] = this.chats.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  ChatType type;
  String value;
  String senderId;
  DateTime timeStamp;

  Chats({this.type, this.value, this.senderId, this.timeStamp});

  Chats.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    senderId = json['sender_id'];
    timeStamp = json['time_stamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    data['sender_id'] = this.senderId;
    data['time_stamp'] = this.timeStamp;
    return data;
  }
}
