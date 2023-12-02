import 'package:dating_app/Config/config.dart';
import 'package:http/http.dart' as http;

class LikeDislikeApi {
  Future<bool> likedDisliked({
    required String likeeId,
    required bool liked,
  }) async {
    ApiData apiData = ApiData();
    if (apiData.userId.isEmpty) await apiData.getData();

    Map<String, int> likeBody = {
      "likerID": int.parse(apiData.userId),
      "likeeID": int.parse(likeeId),
      "type": liked ? 1 : 0,
    };

    Map<String, String> headers = {
      "user_id": apiData.userId,
    };

    http.Response likeResponce = await http.post(
      Uri.parse("${apiData.baseUrl}swipe/"),
      headers: headers,
      body: likeBody,
    );

    if (likeResponce.statusCode == 200) {
      return true;
    } else {
      int count = 1;
      int maxRetries = ApiData().maxRetries;

      while (count < maxRetries) {
        http.Response likeResponce = await http.post(
          Uri.parse("${apiData.baseUrl}swipe/"),
          headers: headers,
          body: likeBody,
        );

        if (likeResponce.statusCode == 200) {
          return true;
        }
      }
      return false;
    }
  }
}
