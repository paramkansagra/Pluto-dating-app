class ViewEventModel {
  List<Data>? data;
  String? message;

  ViewEventModel({this.data, this.message});

  ViewEventModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  String? dateTime;
  Location? location;
  String? type;
  String? description;
  String? attendees;
  String? expiresAt;
  String? createdAt;

  Data(
      {this.id,
      this.dateTime,
      this.location,
      this.type,
      this.description,
      this.attendees,
      this.expiresAt,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime = json['date_time'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    type = json['type'];
    description = json['description'];
    attendees = json['attendees'];
    expiresAt = json['expires_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date_time'] = dateTime;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['type'] = type;
    data['description'] = description;
    data['attendees'] = attendees;
    data['expires_at'] = expiresAt;
    data['created_at'] = createdAt;
    return data;
  }
}

class Location {
  String? address1;
  String? address2;
  String? city;
  String? pincode;
  String? state;
  String? country;
  double? latitude;
  double? longitude;

  Location(
      {this.address1,
      this.address2,
      this.city,
      this.pincode,
      this.state,
      this.country,
      this.latitude,
      this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
    country = json['country'];
    latitude = json['latitude'].toDouble();
    longitude = json['longitude'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['pincode'] = pincode;
    data['state'] = state;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
