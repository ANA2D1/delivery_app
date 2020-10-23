// var shop = {
//   "id":"",
//   "name":"",
//   "category":{"id":"","name":""},
//   "image":"",
//   "location":{"latitude":1.2,"longitude":1.2},
//   "address":"",
//   "menu":[{"name":"","price":1.2,"image":""}],
// };

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/location_model.dart';
import 'package:delivery_app/models/rating_model.dart';

class ShopModel {
  String id;
  String name;
  Category category;
  String image;
  LocationModel location;
  // String address;
  List<ItemModel> menu;
  double rating;

  ShopModel(
      {this.id,
      this.name,
      this.category,
      this.image,
      this.location,
      // this.address,
      this.menu,
      this.rating});

  ShopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    image = json['image'];
    location = json['location'] != null
        ? new LocationModel.fromJson(json['location'])
        : null;
    // address = json['address'];
    if (json['menu'] != null) {
      menu = new List<ItemModel>();
      json['menu'].forEach((DocumentSnapshot v) {
        menu.add(new ItemModel.fromJson(v.documentID, v.data));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['rating'] = this.rating;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['image'] = this.image;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    // data['address'] = this.address;
    if (this.menu != null) {
      data['menu'] = this.menu.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String id;
  String name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class LocationCoordinates {
  double latitude;
  double longitude;
  String address;

  LocationCoordinates({this.latitude, this.longitude, this.address});

  LocationCoordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    return data;
  }
}

class ItemModel {
  String id;
  String name;
  String description;
  double price;
  String image;
  String discount;

  ItemModel(
      {this.id,
      this.description,
      this.discount,
      this.name,
      this.price,
      this.image});

  ItemModel.fromJson(String key, Map<dynamic, dynamic> json) {
    id = key;
    name = json['name'];
    description = json['description'];
    price = json['price'];
    discount = json['discount'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['discount'] = this.discount;
    return data;
  }
}
