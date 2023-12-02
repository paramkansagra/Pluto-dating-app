class PromptAnswerModel {
  List<Data>? data;

  PromptAnswerModel({this.data});

  PromptAnswerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? iD;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? userId;
  String? question;
  String answer = "";
  int? order;
  String? mediaUrl;
  String type = "";

  Data(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.userId,
      this.question,
      this.answer = "",
      this.order,
      this.mediaUrl,
      this.type = ""});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    userId = json['user_id'];
    question = json['question'] ?? "";
    answer = json['answer'] ?? "";
    order = json['order'];
    mediaUrl = json['media_url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    data['DeletedAt'] = deletedAt;
    data['user_id'] = userId;
    data['question'] = question;
    data['answer'] = answer;
    data['order'] = order;
    data['media_url'] = mediaUrl;
    data['type'] = type;
    return data;
  }
}
