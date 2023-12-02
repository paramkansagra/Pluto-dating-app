class UpdateSearchModel {
  Data? data;
  String? message;

  UpdateSearchModel({this.data, this.message});

  UpdateSearchModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data["data"];
  }
}

class Data {
  List<String>? gender;
  int? minAge;
  int? maxAge;
  int? distance;
  List<String>? language;
  bool? hideMyName;

  Data(
      {this.gender,
      this.minAge,
      this.maxAge,
      this.distance,
      this.language,
      this.hideMyName});

  Data.fromJson(Map<String, dynamic> json) {
    gender = json['gender'].cast<String>();
    minAge = json['min_age'];
    maxAge = json['max_age'];
    distance = json['distance'];
    language = json['language'].cast<String>();
    hideMyName = json['hide_my_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['min_age'] = minAge;
    data['max_age'] = maxAge;
    data['distance'] = distance;
    data['language'] = language;
    data['hide_my_name'] = hideMyName;
    return data;
  }
}
