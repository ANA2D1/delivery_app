// var rating = {
//   "id": "",
//   "rater_id": "",
//   "candidate_id": "",
//   "order_id": "",
//   "descriptin": "",
//   "rating": 0.0,
//   "time_stamp": "",
//   "status": ""
// };

class RatingModel {
  String id;
  String raterId;
  String candidateId;
  String orderId;
  String descriptin;
  double rating;
  DateTime timeStamp;
  String status;

  RatingModel(
      {this.id,
      this.raterId,
      this.candidateId,
      this.orderId,
      this.descriptin,
      this.rating,
      this.timeStamp,
      this.status});

  RatingModel.fromJson(String key, Map<String, dynamic> json) {
    id = key;
    raterId = json['rater_id'];
    candidateId = json['candidate_id'];
    orderId = json['order_id'];
    descriptin = json['descriptin'];
    rating = json['rating'];
    timeStamp = json['time_stamp'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['rater_id'] = this.raterId;
    data['candidate_id'] = this.candidateId;
    data['order_id'] = this.orderId;
    data['descriptin'] = this.descriptin;
    data['rating'] = this.rating;
    data['time_stamp'] = this.timeStamp;
    data['status'] = this.status;
    return data;
  }
}
