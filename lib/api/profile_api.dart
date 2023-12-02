import 'dart:convert';
import 'package:dating_app/Config/config.dart';
import 'package:dating_app/models/profile_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../models/matched_model.dart';
import '../models/profile_creation_model.dart';
import '../models/prompt_answer_model.dart';
import '../models/prompt_model.dart';
import '../models/update_search_model.dart';
import '../models/user_media_model.dart';
import 'dart:developer';

class ProfileApi {
  ApiData apiData = ApiData();

  Future<void> createProfile() async {
    if (apiData.userId.isEmpty) await apiData.getData();
    http.Response profileResponse = await http.post(
      Uri.parse("${apiData.baseUrl}profile"),
      headers: {"user_id": apiData.userId},
      body: jsonEncode(ProfileCreationModel().toJson()),
    );

    if (profileResponse.statusCode == 200) {
      log(jsonDecode(profileResponse.body));
      log("Profile Created Successfully profileAPI");
    } else {
      log(
        "Create profile ---> ${jsonEncode(ProfileCreationModel().toJson())}",
      );
      log("Error : status code is ${profileResponse.statusCode}");
    }
  }

  Future<ProfileModel> fetchProfile({String? userId}) async {
    if (apiData.userId.isEmpty) await apiData.getData();
    log("USER ID profile api -> ${apiData.userId}");
    http.Response response = await http.get(
        Uri.parse("${apiData.baseUrl}profile/"),
        headers: {"user_id": userId ?? apiData.userId, "user_profile_id": "3"});
    if (response.statusCode == 200) {
      Map<String, dynamic>? jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        log(jsonResponse.toString());
        ProfileModel profileModel = ProfileModel.fromJson(jsonResponse);
        return profileModel;
      } else {
        throw Exception('Failed to decode interest response');
      }
    } else {
      if (jsonDecode(response.body)["error"] == "record not found") {
        return ProfileModel(error: true);
      } else {
        throw Exception(
            'Failed to load profile response status code is ${response.statusCode}');
      }
    }
  }

  Future<Map<String, dynamic>> fetchInterestList() async {
    if (apiData.userId.isEmpty) await apiData.getData();
    String interestUrl = "https://firstpluto.com/interests";

    http.Response interestResponse = await http.get(Uri.parse(interestUrl));

    if (interestResponse.statusCode == 200) {
      return jsonDecode(interestResponse.body)["interests"];
    } else {
      throw Exception("Unable to fetch user interest");
    }
  }

  Map<String, String> fetchInterestEmojiMap(Map<String, dynamic> interestMap) {
    Map<String, String> interestEmojiMap = {};
    interestMap.forEach(
      (key, value) {
        value as List<dynamic>;
        for (var element in value) {
          interestEmojiMap
              .addAll({element["interest_value"]: element["emoticon"]});
        }
      },
    );

    return interestEmojiMap;
  }

  Future<List<String>> fetchUserInterest() async {
    if (apiData.userId.isEmpty) await apiData.getData();
    List<String> selectedInterest = [];
    http.Response userInterest = await http.get(
        Uri.parse("${apiData.baseUrl}interests"),
        headers: {"user_id": apiData.userId});

    if (userInterest.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(userInterest.body);
      Map<String, dynamic> data = response['data'];

      if (response.isNotEmpty) {
        for (var value in data.values) {
          if (value != null) {
            if (value is List) {
              selectedInterest.addAll(value.cast<String>());
            } else {
              selectedInterest.add(value.toString());
            }
          }
        }

        return selectedInterest;
      } else {
        throw Exception("Fail to get interest");
      }
    } else {
      throw Exception(
          'Failed to load profile response status code is ${userInterest.statusCode}');
    }
  }

  Future postInterest(Map<String, List<String>> selectedInterest) async {
    if (apiData.userId.isEmpty) await apiData.getData();
    final Map<String, dynamic> data = <String, dynamic>{};
    data['interests'] = jsonEncode(selectedInterest);
    http.Response response = await http.post(
      Uri.parse("${apiData.baseUrl}interests"),
      headers: {"user_id": apiData.userId},
      body: data['interests'],
    );
    if (response.statusCode != 200) {
      log("Post Interest Status code is ${response.statusCode}");
      log(response.body);
    }
  }

  Future<PromptAnswerModel> fetchPromptAnswers() async {
    if (apiData.userId.isEmpty) await apiData.getData();
    http.Response response = await http.get(
      Uri.parse('${apiData.baseUrl}nudges'),
      headers: {"user_id": apiData.userId},
    );

    PromptAnswerModel promptAnswer = PromptAnswerModel();
    promptAnswer = PromptAnswerModel.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      return promptAnswer;
    } else {
      int count = 1;
      int maxRetries = apiData.maxRetries;

      while (count <= maxRetries) {
        response = await http.get(
          Uri.parse('${apiData.baseUrl}nudges'),
          headers: {"user_id": apiData.userId},
        );

        if (response.statusCode == 200) {
          PromptAnswerModel promptAnswer = PromptAnswerModel();
          promptAnswer = PromptAnswerModel.fromJson(jsonDecode(response.body));

          return promptAnswer;
        } else {
          count++;
        }
      }

      throw Exception(
          "Unable to fetch prompt answer status code is ${response.statusCode}");
    }
  }

  Future<ProfileModel> updateProfile(ProfileModel data) async {
    if (apiData.userId.isEmpty) await apiData.getData();
    Map<String, dynamic> jsonResponse = data.data!.toJson();
    jsonResponse.remove("id");

    http.Response updateResponse = await http.put(
        Uri.parse("${apiData.baseUrl}profile"),
        headers: {"user_id": apiData.userId},
        body: jsonEncode(jsonResponse));

    if (updateResponse.statusCode == 200) {
      log("profile Updated (updateProfile function profile_api file)");
      return ProfileModel.fromJson(jsonDecode(updateResponse.body));
    } else {
      log(jsonEncode(jsonResponse));
      throw Exception(
          "Error updating this status code is ${updateResponse.statusCode}");
    }
  }

  Future<void> updateProfileFirstTime(ProfileCreationModel data) async {
    if (apiData.userId.isEmpty) await apiData.getData();
    log("update profile -> ${apiData.userId}");
    http.Response updateResponse = await http.put(
      Uri.parse("${apiData.baseUrl}profile"),
      headers: {"user_id": apiData.userId},
      body: jsonEncode(
        data.toJson(),
      ),
    );

    log("update profile first time => ${updateResponse.body.toString()}");

    if (updateResponse.statusCode == 200) {
      log("Profile Updated updateProfileFirstTime function(profile_api file)");
      log(data.toJson().toString());
    } else {
      throw Exception(
          "Error updating this status code is ${updateResponse.statusCode}");
    }
  }

  Future<PromptsModel> fetchPrompts() async {
    http.Response response =
        await http.get(Uri.parse("https://firstpluto.com/nudges"));

    if (response.statusCode == 200) {
      PromptsModel data = PromptsModel.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception(
          "Error fetching prompts the status code is ${response.statusCode}");
    }
  }

  Future<UserMediaModel> fetchMedia() async {
    if (apiData.userId.isEmpty) await apiData.getData();
    UserMediaModel mediaData;
    http.Response mediaResponse = await http.get(
        Uri.parse('${apiData.baseUrl}profileMedia?user_id=${apiData.userId}'));

    if (mediaResponse.statusCode == 200) {
      mediaData = UserMediaModel.fromJson(jsonDecode(mediaResponse.body));
      return mediaData;
    } else if (mediaResponse.statusCode == 500 &&
        jsonDecode(mediaResponse.body)["error"] == "record not found") {
      log("No record found");
      return UserMediaModel(error: true);
    } else {
      throw Exception(
          "Error feteching the media response ${mediaResponse.statusCode}");
    }
  }

  Future<String> getCityName(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    return placemarks[0].name!;
  }

  Future<void> otpSend(String mobileNumber) async {
    http.Response otpResoponse = await http.post(
        Uri.parse("${apiData.baseUrl}send/otp"),
        body: jsonEncode({"phoneNumber": mobileNumber}));

    log(jsonDecode(otpResoponse.body));
    if (otpResoponse.statusCode == 200) {
      log("Otp successfully send");
    } else {
      throw Exception("Error: The otp doesn't send ${otpResoponse.statusCode}");
    }
  }

  Future<void> otpVerify(String number, String otp) async {
    http.Response verifyOtpResonse =
        await http.post(Uri.parse("${apiData.baseUrl}verify/otp"),
            body: jsonEncode({
              "user": {"phoneNumber": number},
              "otp": otp
            }));

    log(jsonDecode(verifyOtpResonse.body));

    if (verifyOtpResonse.statusCode == 200) {
      log("OTP verified and user logged in ");
    } else {
      throw Exception("OTP is not verified ${verifyOtpResonse.statusCode}");
    }
  }

  Future<void> updateSearch(UpdateSearchModel filterData) async {
    if (apiData.userId.isEmpty) await apiData.getData();
    http.Response filterResponse = await http.put(
        Uri.parse("${apiData.baseUrl}updateSearchProfile/"),
        headers: {"user_id": apiData.userId},
        body: jsonEncode(filterData.toJson()));

    if (filterResponse.statusCode == 200) {
      log("profile updated successfully");
    } else {
      log(" Error while updating ${filterResponse.statusCode}");
    }
  }

  Future<MatchedModel> matchedProfiles() async {
    http.Response matchedResponses = await http.get(
        Uri.parse("${apiData.baseUrl}matches"),
        headers: {"user_id": apiData.userId});

    if (matchedResponses.statusCode == 200) {
      log("Matched responses successfully feteched");
      MatchedModel matchList =
          MatchedModel.fromJson(jsonDecode(matchedResponses.body));

      return matchList;
    } else {
      throw Exception(
          "The error on fetching the matched responses the status code is ${matchedResponses.statusCode}");
    }
  }

  Future<UserMediaModel> getImage() async {
    http.Response imageResponse = await http.get(
        Uri.parse("${apiData.baseUrl}profileMedia?user_id=${apiData.userId}"));

    UserMediaModel listImageModel =
        UserMediaModel.fromJson(jsonDecode(imageResponse.body));

    return listImageModel;
  }

  Future<dynamic> getEditOptions() async {
    http.Response optionsResponse =
        await http.get(Uri.parse("https://firstpluto.com/filters"));
    if (optionsResponse.statusCode == 200) {
      return jsonDecode(optionsResponse.body)["data"];
    } else {
      log("Error fetching the edit profile options");
    }
  }

  Future<http.Response> deleteMedia(int mediaId) async {
    if (apiData.userId.isEmpty) await apiData.getData();
    http.Response deleteResponse = await http.delete(
        Uri.parse("${apiData.baseUrl}profileMedia?mediaId=$mediaId"),
        headers: {"user_id": apiData.userId});
    return deleteResponse;
  }

  Future<Map<String, dynamic>> fetchUserId({required idToken}) async {
    http.Response getUserIdResponce = await http.post(
      Uri.parse("${apiData.baseUrl}google/login"),
      body: jsonEncode(
        {"id_token": idToken},
      ),
    );

    if (getUserIdResponce.statusCode == 200) {
      Map<String, dynamic> userIdResponce = jsonDecode(getUserIdResponce.body);
      return userIdResponce;
    } else {
      throw Exception(
          "User Id not recived error ${getUserIdResponce.statusCode}");
    }
  }
}
