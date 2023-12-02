class UserMediaModel {
  List<ImageData>? data;
  String? message;
  bool? error;

  UserMediaModel({this.data, this.message, this.error});

  UserMediaModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ImageData>[];
      json['data'].forEach((v) {
        data!.add(ImageData.fromJson(v));
      });
    }
    message = json['message'];
    error = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data["error"] = false;
    return data;
  }
}

class ImageData {
  int? iD;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? userId;
  int? userProfileId;
  String? url;
  int? orderId;
  String? imageText;
  double? latitude;
  double? longitude;
  String? city;

  ImageData(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.userId,
      this.userProfileId,
      this.url,
      this.orderId,
      this.imageText,
      this.latitude,
      this.longitude,
      this.city});

  ImageData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    userId = json['user_id'];
    userProfileId = json['user_profile_id'];
    url = json['url'];
    orderId = json['order_id'];
    imageText = json['image_text'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    data['DeletedAt'] = deletedAt;
    data['user_id'] = userId;
    data['user_profile_id'] = userProfileId;
    data['url'] = url;
    data['order_id'] = orderId;
    data['image_text'] = imageText;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['city'] = city;
    return data;
  }
}
