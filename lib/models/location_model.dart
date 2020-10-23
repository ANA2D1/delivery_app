// var l = {
//   "coordinates": {"latitude": 37.4230502, "longitude": -122.08418069999999},
//   "addressLine": "1500 Amphitheatre Pkwy, Mountain View, CA 94043, USA,",
//   " countryName": "United States",
//   "countryCode": "US",
//   "featureName": "1500",
//   "postalCode": "94043",
//   "locality": "Mountain View",
//   "subLocality": "",
//   "adminArea": "California",
//   "subAdminArea": "Santa Clara County",
//   "thoroughfare": "Amphitheatre Parkway",
//   "subThoroughfare": "1500"
// };

class LocationModel {
  Coordinates coordinates;
  String addressLine;
  String countryName;
  String countryCode;
  String featureName;
  String postalCode;
  String locality;
  String subLocality;
  String adminArea;
  String subAdminArea;
  String thoroughfare;
  String subThoroughfare;

  LocationModel(
      {this.coordinates,
      this.addressLine,
      this.countryName,
      this.countryCode,
      this.featureName,
      this.postalCode,
      this.locality,
      this.subLocality,
      this.adminArea,
      this.subAdminArea,
      this.thoroughfare,
      this.subThoroughfare});

  LocationModel.fromJson(Map<dynamic, dynamic> json) {
    coordinates = json['coordinates'] != null
        ? new Coordinates.fromJson(json['coordinates'])
        : null;
    addressLine = json['addressLine'];
    countryName = json['countryName'];
    countryCode = json['countryCode'];
    featureName = json['featureName'];
    postalCode = json['postalCode'];
    locality = json['locality'];
    subLocality = json['subLocality'];
    adminArea = json['adminArea'];
    subAdminArea = json['subAdminArea'];
    thoroughfare = json['thoroughfare'];
    subThoroughfare = json['subThoroughfare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }
    data['addressLine'] = this.addressLine;
    data['countryName'] = this.countryName;
    data['countryCode'] = this.countryCode;
    data['featureName'] = this.featureName;
    data['postalCode'] = this.postalCode;
    data['locality'] = this.locality;
    data['subLocality'] = this.subLocality;
    data['adminArea'] = this.adminArea;
    data['subAdminArea'] = this.subAdminArea;
    data['thoroughfare'] = this.thoroughfare;
    data['subThoroughfare'] = this.subThoroughfare;
    return data;
  }
}

class Coordinates {
  double latitude;
  double longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<dynamic, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
