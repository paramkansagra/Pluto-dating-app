import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ApiData {
  String baseUrl = "https://firstpluto.com/user/";
  String userId = "";
  String token = "";
  int maxRetries = 3;

  // also save in shared pref https://medium.flutterdevs.com/using-sharedpreferences-in-flutter-251755f07127

  // String userId = "13"; test karne ke liye
  String userProfileId = "2"; // dont change
//   String userProfileId = "45";
  String locationApiKey = "MAP API KEY";

  ApiData() {
    callingFunction();
  }

  void callingFunction() {
    getData();
  }

  Future<void> saveData(String userId, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
    prefs.setString("token", token);
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUserId = prefs.getString("userId");
    String? tempToken = prefs.getString("token");

    if (tempUserId == null || tempToken == null) {
      userId = "-1";
      token = "-1";
    } else {
      userId = tempUserId;
      token = tempToken;
    }
  }

  Future<bool> isDataPresent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUserId = prefs.getString("userId");
    String? tempToken = prefs.getString("token");

    if (tempUserId == null || tempToken == null) {
      return false;
    }
    return true;
  }

  Future<bool> deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool removeUserId = await prefs.remove("userId");
    bool removeToken = await prefs.remove("token");

    bool prefsClear = await prefs.clear();

    log("remove user id -> $removeUserId removing token -> $removeToken other prefs clear => $prefsClear");

    if (removeUserId && removeToken && prefsClear) {
      return true;
    }
    return false;
  }
}
