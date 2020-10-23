// var delivery = {
//   "id":"",
//   "name":"",
//   "mobile":"",
//   "rating":0,
//   "time_stamp":""
// };

class DeliveryManModel {
  String id;
  String imageUrl;
  String name;
  String mobile;
  int rating;
  String timeStamp;

  DeliveryManModel(
      {this.id,
      this.name,
      this.imageUrl,
      this.mobile,
      this.rating,
      this.timeStamp});

  DeliveryManModel.fromJson(String key, Map<String, dynamic> json) {
    id = key;
    name = json['name'];
    mobile = json['mobile'];
    imageUrl = json['image_url'];
    rating = json['rating'];
    timeStamp = json['time_stamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['image_url'] = this.imageUrl;
    data['rating'] = this.rating;
    data['time_stamp'] = this.timeStamp;
    return data;
  }
}
