
class PostImageDataModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? orderId;
  final int userId;
  final int userProfileId;
  final String url;
  final String? imageText;
  final double latitude;
  final double longitude;
  final String city;

  PostImageDataModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.orderId,
    required this.userId,
    required this.userProfileId,
    required this.url,
    this.imageText,
    required this.latitude,
    required this.longitude,
    required this.city,
  });

  factory PostImageDataModel.fromJson(Map<String, dynamic> json) {
    return PostImageDataModel(
      id: json['data']['ID'],
      createdAt: DateTime.parse(json['data']['CreatedAt']),
      updatedAt: DateTime.parse(json['data']['UpdatedAt']),
      orderId: json['data']['order_id'],
      userId: json['data']['user_id'],
      userProfileId: json['data']['user_profile_id'],
      url: json['data']['url'],
      imageText: json['data']['image_text'],
      latitude: json['data']['latitude'],
      longitude: json['data']['longitude'],
      city: json['data']['city'],
    );
  }
}
