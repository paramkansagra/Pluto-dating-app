import 'dart:developer';

import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/models/post_media_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/config.dart';
import "package:path_provider/path_provider.dart";
import 'package:path/path.dart';

class ImageUploadProvider extends ChangeNotifier {
  SharedPreferences? _prefs;
  List<File?> images = [null, null, null, null];
  List<bool> uploadCompleted = [false, false, false, false];

  ApiData apiData = ApiData();
  int uploadIndex = 0;

  ImageUploadProvider() {
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < images.length; i++) {
      String? imagePath = _prefs!.getString('image_$i');
      if (imagePath != null) {
        images[i] = File(imagePath);
      }
    }

    String? completedString = _prefs!.getString('upload_completed');
    if (completedString != null) {
      List<int> completedList = jsonDecode(completedString).cast<int>();
      uploadCompleted = completedList
          .map((completed) => completed == 1 ? true : false)
          .toList();
    }

    notifyListeners();
  }

  Future<void> saveImagePathToCache(int index, int mediaId) async {
    if (images[index] != null) {
      String fileName = '$mediaId.jpg';
      Directory appDir = await getApplicationDocumentsDirectory();
      String imagePath = '${appDir.path}/$fileName';
      await images[index]!.copy(imagePath);
      _prefs!.setString('image_$index', imagePath);
    }
  }

  Future<String?> getFileNameFromCache(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('image_$index');
  }

  Future<void> removeImagePathFromCache(int index) async {
    int? mediaId;
    if (images[index] != null) {
      String? filePath = images[index]!.path;
      String fileName = basename(filePath);
      mediaId = int.parse(fileName.replaceAll(RegExp(r'[^0-9]'), ''));
      log(mediaId.toString());
    }

    ProfileApi().deleteMedia(mediaId ?? -1).then((response) async {
      if (response.statusCode == 200) {
        _prefs?.remove('image_$index');
        uploadCompleted[index] = false;
        await saveUploadCompletedToCache();
      } else {
        log(jsonDecode(response.body));
        log("Unable to delete media and the delete response code is ${response.statusCode}");
      }
    });
  }

  Future<void> updateImageOrder(int mediaId, int index) async {
    if (apiData.userId.isEmpty) await apiData.getData();
    final orderResponse = await http.post(
      Uri.parse('${apiData.baseUrl}update/profileMedia'),
      headers: {"user_id": apiData.userId},
      body: json.encode({"media_id": mediaId, "order_id": index + 1}),
    );

    if (orderResponse.statusCode == 200) {
      log("order updated successfully");
    } else {
      log("The order error response code is ${orderResponse.statusCode}");
    }
  }

  Future<PostImageDataModel> uploadImage(File imageFile, int uploadIndex,
      String? caption, String? city, LocationData location) async {
    if (apiData.userId.isEmpty) await apiData.getData();
    log("upload image user id -> ${apiData.userId}");
    log("upload image user profile id -> ${apiData.userProfileId}");
    Map<String, String> headers = {
      "user_id": apiData.userId,
      "user_profile_id": apiData.userProfileId,
    };

    final request = http.MultipartRequest(
        'POST', Uri.parse("${apiData.baseUrl}profileMedia"));
    request.headers.addAll(headers);
    final file = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(file);
    request.fields["image_text"] = caption ?? "";
    request.fields["city"] = city ?? "";
    request.fields['longitude'] = location.longitude.toString();
    request.fields['latitude'] = location.latitude.toString();
    try {
      log("USER ID inside image provider ->${apiData.userId}");
      log("sending responce");
      final response = await request.send();
      log("responce sent");
      log("${response.statusCode}");
      if (response.statusCode == 200) {
        log("Image uploaded successfully");
        final responseString = await response.stream.bytesToString();
        PostImageDataModel postModel =
            PostImageDataModel.fromJson(jsonDecode(responseString));
        final int mediaId = postModel.id;

        uploadCompleted[uploadIndex] = true;
        await saveUploadCompletedToCache();
        notifyListeners();

        await saveImagePathToCache(uploadIndex, mediaId);
        return postModel;
      } else {
        String issue = await response.stream.bytesToString();
        log("issue ->$issue");
        throw Exception(
            "Error uploading the image the statusCode is ${response.statusCode}");
      }
    } catch (e) {
      log("Error occurred during image upload: $e");
      rethrow;
    }
  }

  Future<void> pickedAndSend(File? imageFile, int index, LocationData position,
      String? text, String? city) async {
    if (imageFile != null) {
      images[index] = File(imageFile.path);

      await uploadImage(images[index]!, uploadIndex, text, city, position);
      if (uploadIndex < 3) {
        uploadIndex++;
      }
      notifyListeners();
    }
  }

  bool isButtonEnable(int index) {
    if (index == 0) {
      return true;
    }

    if (index <= uploadIndex) {
      return uploadCompleted[index - 1] != false;
    }

    return false;
  }

  Future<void> pickImage(int index) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      images[index] = File(pickedImage.path);
      if (uploadIndex < 3) {
        uploadIndex++;
      }

      notifyListeners();
    }
  }

  Future<void> saveUploadCompletedToCache() async {
    List<int> completedList =
        uploadCompleted.map((completed) => completed ? 1 : 0).toList();
    _prefs!.setString('upload_completed', jsonEncode(completedList));
  }
}
