class EventModel {
  String? attendee;
  String? dateTime;
  String? description;
  String? expiresAt;
  String? type;
  Location? location;

  EventModel(
      {this.attendee,
      this.dateTime,
      this.description,
      this.expiresAt,
      this.type,
      this.location});

  EventModel.fromJson(Map<String, dynamic> json) {
    attendee = json['attendee'];
    dateTime = json['date_time'];
    description = json['description'];
    expiresAt = json['expires_at'];
    type = json['type'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attendee'] = attendee;
    data['date_time'] = dateTime;
    data['description'] = description;
    data['expires_at'] = expiresAt;
    data['type'] = type;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Location {
  String? address1;
  String? address2;
  String? city;
  String? country;
  double? latitude;
  double? longitude;
  String? pincode;
  String? state;

  Location(
      {this.address1,
      this.address2,
      this.city,
      this.country,
      this.latitude,
      this.longitude,
      this.pincode,
      this.state});

  Location.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    pincode = json['pincode'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['pincode'] = pincode;
    data['state'] = state;
    return data;
  }
}
