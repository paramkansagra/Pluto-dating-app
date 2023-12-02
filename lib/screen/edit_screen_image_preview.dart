import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dating_app/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import '../models/post_media_model.dart';
import 'image_preview.dart';

class EditScreenImagePreview extends StatefulWidget {
  final File imageFile;
  const EditScreenImagePreview({super.key, required this.imageFile});

  @override
  State<EditScreenImagePreview> createState() => _EditScreenImagePreviewState();
}

class _EditScreenImagePreviewState extends State<EditScreenImagePreview> {
  ApiData apiData = ApiData();
  final captionController = TextEditingController();
  final cityController = TextEditingController();
  late LocationData _currentPosition;
  Location location = Location();

  Future<PostImageDataModel> uploadImage(File imageFile, String? caption,
      String? city, LocationData location) async {
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
      final response = await request.send();
      if (response.statusCode == 200) {
        log("Image uploaded successfully");
        final responseString = await response.stream.bytesToString();
        PostImageDataModel postModel =
            PostImageDataModel.fromJson(jsonDecode(responseString));
        // final int mediaId = postModel.id;

        return postModel;
      } else {
        log(response.stream.bytesToString().toString());
        throw Exception(
            "Error uploading the image the statusCode is ${response.statusCode}");
      }
    } catch (e) {
      log("Error occurred during image upload: $e");
      rethrow;
    }
  }

  fetchLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    // TextEditingController captionController, locationController;
    // String? city;
    // String? caption;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
    captionController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          'Preview',
          style:
              Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              uploadImage(widget.imageFile, captionController.value.text,
                  cityController.value.text, _currentPosition);
              Navigator.of(context).pop();
            },
            child: Text(
              "Save",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 5,
                      child: Image.file(
                        File(widget.imageFile.path),
                        // fit: BoxFit,
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 18,
                      left: 18,
                      child: Column(
                        children: [
                          InputBox(
                            hint: 'Add captions',
                            icon: Icons.edit,
                            controller: captionController,
                          ),
                          const SizedBox(height: 8),
                          InputBox(
                            hint: 'Add location',
                            icon: Icons.location_on_outlined,
                            controller: cityController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
