class MatchedModel {
  List<Data>? data;
  String? message;

  MatchedModel({this.data, this.message});

  MatchedModel.fromJson(Map<String, dynamic> json) {
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
  int? iD;
  int? userId;
  int? matchId;
  int? orderId;
  int? mediaId;
  String? url;
  String? chatId;
  String? createdAt;
  String? deletedAt;

  Data(
      {this.iD,
      this.userId,
      this.matchId,
      this.orderId,
      this.mediaId,
      this.url,
      this.chatId,
      this.createdAt,
      this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    userId = json['user_id'];
    matchId = json['match_id'];
    orderId = json['order_id'];
    mediaId = json['media_id'];
    url = json['url'];
    chatId = json['chat_id'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['user_id'] = userId;
    data['match_id'] = matchId;
    data['order_id'] = orderId;
    data['media_id'] = mediaId;
    data['url'] = url;
    data['chat_id'] = chatId;
    data['created_at'] = createdAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
