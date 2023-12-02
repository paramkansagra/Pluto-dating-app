import 'dart:convert';
import 'package:dating_app/models/event_model.dart';
import 'package:dating_app/models/view_event_model.dart';
import 'package:http/http.dart' as http;
import '../Config/api_data.dart';
import 'dart:developer';

class EventApi {
  ApiData apiData = ApiData();

  Future<void> createEvent(EventModel eventDetails) async {
    http.Response eventResponse = await http.post(
        Uri.parse("${apiData.baseUrl}event"),
        headers: {"user_id": apiData.userId},
        body: jsonEncode(eventDetails.toJson()));

    if (eventResponse.statusCode == 200 || eventResponse.statusCode == 201) {
      log("Event added successfully");
    } else {
      throw Exception(
          "error while adding event the status code is ${eventResponse.statusCode}");
    }
  }

  Future<ViewEventModel> getEvent() async {
    http.Response eventResponse = await http.get(
      Uri.parse("${apiData.baseUrl}event"),
      headers: {"user_id": apiData.userId},
    );

    if (eventResponse.statusCode == 200 || eventResponse.statusCode == 201) {
      return ViewEventModel.fromJson((jsonDecode(eventResponse.body)));
    } else {
      throw Exception(
          "Event Failed to load status code is ${eventResponse.statusCode}");
    }
  }

  Future<void> updateEvent(Data eventDetails) async {
    http.Response eventResponse = await http.put(
        Uri.parse("${apiData.baseUrl}event"),
        headers: {"user_id": apiData.userId},
        body: jsonEncode(eventDetails.toJson()));

    if (eventResponse.statusCode != 200 || eventResponse.statusCode != 201) {
      throw Exception(
          "error while adding event the status code is ${eventResponse.statusCode}");
    }
  }
}
