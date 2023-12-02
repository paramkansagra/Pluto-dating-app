import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dating_app/Config/config.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart' as parser;

class SendNudge {
  final ApiData _apiData = ApiData();

  Future<bool> deleteNudge(int nudgeId) async {
    if (_apiData.userId.isEmpty) await _apiData.getData();
    final responce = await http.delete(
      Uri.parse('${_apiData.baseUrl}nudge'),
      headers: {
        "nudge_id": nudgeId.toString(),
      },
    );

    if (responce.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendTextNudge({
    required question,
    required answer,
    required order,
    required nudgeId,
  }) async {
    if (_apiData.userId.isEmpty) await _apiData.getData();
    log("upload text nudge user id -> ${_apiData.userId}");
    log("upload text nudge user profile id -> ${_apiData.userProfileId}");

    log("question -> $question answer -> $answer order -> $order");

    if (nudgeId == -1) {
      final nudgeResponce = await http.post(
        Uri.parse("${_apiData.baseUrl}nudge"),
        headers: {"user_id": _apiData.userId},
        body: json.encode(
          {
            "question": question,
            "answer": answer,
            "order": order,
            "type": "text",
          },
        ),
      );

      if (nudgeResponce.statusCode == 200) {
        log("text nudge uploaded successfully");
        return true;
      } else {
        log("text nudge error responce code -> ${nudgeResponce.statusCode}");
        log("text nudge error -> ${nudgeResponce.body}");
        return false;
      }
    } else {
      final textRequest = http.MultipartRequest(
        'PUT',
        Uri.parse("${_apiData.baseUrl}nudge"),
      );
      Map<String, String> headers = {
        "user_id": _apiData.userId.toString(),
        "nudge_id": nudgeId.toString(),
      };

      textRequest.headers.addAll(headers);
      textRequest.fields["question"] = question;
      textRequest.fields["answer"] = answer;
      textRequest.fields["order"] = order.toString();

      log(textRequest.headers.toString());
      log(textRequest.fields.toString());

      log("sending the audio request");
      final nudgeResponse = await textRequest.send();
      log("responce sent");
      String issue = await nudgeResponse.stream.bytesToString();

      log("responce body -> $issue");
      log("responce code -> ${nudgeResponse.statusCode}");
      if (nudgeResponse.statusCode == 200) {
        log("audio sent successfully");
        return true;
      } else {
        log("audio nudge error responce code -> ${nudgeResponse.statusCode}");
        String issue = await nudgeResponse.stream.bytesToString();
        log("audio nudge error -> $issue");
        return false;
      }
    }
  }

  Future<bool> sendAudioNudge({
    required question,
    required audioPath,
    required order,
    required nudgeId,
  }) async {
    if (_apiData.userId.isEmpty) await _apiData.getData();
    log("upload audio nudge user id -> ${_apiData.userId}");
    log("upload audio nudge user profile id -> ${_apiData.userProfileId}");

    final audioRequest = http.MultipartRequest(
      nudgeId == -1 ? 'POST' : 'PUT',
      nudgeId == -1
          ? Uri.parse("${_apiData.baseUrl}nudge/media")
          : Uri.parse("${_apiData.baseUrl}nudge"),
    );

    Map<String, String> headers = {
      "user_id": _apiData.userId.toString(),
    };

    if (nudgeId != -1) {
      headers.addAll(
        {
          "nudge_id": nudgeId.toString(),
        },
      );
    }

    audioRequest.headers.addAll(headers);
    audioRequest.fields["question"] = question;
    audioRequest.fields["answer"] = "";
    audioRequest.fields["order"] = order.toString();

    log("path -> $audioPath");
    log("url -> ${audioRequest.url}");

    final audioFile = http.MultipartFile(
      "media", // it is the name of the key present in form-data
      File(audioPath).readAsBytes().asStream(),
      File(audioPath).lengthSync(),
      filename: File(audioPath).path.split("/").last,
      contentType: parser.MediaType("audio", "m4a"),
    );

    log("audio file content -> ${audioFile.contentType} name -> ${audioFile.filename}");

    audioRequest.files.add(audioFile);

    log(audioRequest.headers.toString());
    log(audioRequest.fields.toString());

    log("sending the audio request");
    final nudgeResponse = await audioRequest.send();
    log("responce sent");
    String issue = await nudgeResponse.stream.bytesToString();

    log("responce body -> $issue");
    log("responce code -> ${nudgeResponse.statusCode}");
    if (nudgeResponse.statusCode == 200) {
      log("audio sent successfully");
      return true;
    } else {
      log("audio nudge error responce code -> ${nudgeResponse.statusCode}");
      String issue = await nudgeResponse.stream.bytesToString();
      log("audio nudge error -> $issue");
      return false;
    }
  }

  Future<bool> sendVideoNudge({
    required question,
    required videoPath,
    required order,
    required nudgeId,
  }) async {
    if (_apiData.userId.isEmpty) await _apiData.getData();
    log("upload audio nudge user id -> ${_apiData.userId}");
    log("upload audio nudge user profile id -> ${_apiData.userProfileId}");

    final videoRequest = http.MultipartRequest(
      nudgeId == -1 ? 'POST' : 'PUT',
      nudgeId == -1
          ? Uri.parse("${_apiData.baseUrl}nudge/media")
          : Uri.parse("${_apiData.baseUrl}nudge"),
    );

    Map<String, String> headers = {
      "user_id": _apiData.userId.toString(),
    };

    if (nudgeId != -1) {
      headers.addAll(
        {
          "nudge_id": nudgeId.toString(),
        },
      );
    }

    videoRequest.headers.addAll(headers);
    videoRequest.fields["question"] = question;
    videoRequest.fields["answer"] = "";
    videoRequest.fields["order"] = order.toString();

    log("path -> $videoPath");
    log("url -> ${videoRequest.url}");

    final audioFile = http.MultipartFile(
      "media", // it is the name of the key present in form-data
      File(videoPath).readAsBytes().asStream(),
      File(videoPath).lengthSync(),
      filename: File(videoPath).path.split("/").last,
      contentType: parser.MediaType("video", "mp4"),
    );

    log("audio file content -> ${audioFile.contentType} name -> ${audioFile.filename}");

    videoRequest.files.add(audioFile);

    log(videoRequest.headers.toString());
    log(videoRequest.fields.toString());

    log("sending the video request");
    final nudgeResponse = await videoRequest.send();
    log("responce sent");
    String issue = await nudgeResponse.stream.bytesToString();

    log("responce body -> $issue");
    log("responce code -> ${nudgeResponse.statusCode}");
    if (nudgeResponse.statusCode == 200) {
      log("video sent successfully");
      return true;
    } else {
      log("video nudge error responce code -> ${nudgeResponse.statusCode}");
      String issue = await nudgeResponse.stream.bytesToString();
      log("video nudge error -> $issue");
      return false;
    }
  }
}
