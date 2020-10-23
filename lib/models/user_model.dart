// var user = {
// "id":"",
// "name":"",
// "mobile":"",
// "rating":0,
// "time_stamp":""
// };

class UserModel {
  String id;
  String name;
  String mobile;
  String imageUrl;
  int rating;
  String timeStamp;

  UserModel(
      {this.id,
      this.name,
      this.mobile,
      this.imageUrl,
      this.rating,
      this.timeStamp});

  UserModel.fromJson(String key, Map<String, dynamic> json) {
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
