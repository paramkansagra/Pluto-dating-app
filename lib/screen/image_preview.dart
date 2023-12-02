import 'dart:io';
import 'package:dating_app/provider/upload_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class ImagePreview extends StatefulWidget {
  final File imageFile;
  final int index;
  const ImagePreview({super.key, required this.imageFile, required this.index});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  final captionController = TextEditingController();
  final cityController = TextEditingController();
  late LocationData _currentPosition;
  // late String _address;
  Location location = Location();

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
    return Consumer<ImageUploadProvider>(
        builder: ((context, imageModal, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.black,
              title: Text(
                'Preview',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontSize: 20),
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
                    imageModal.pickedAndSend(
                        widget.imageFile,
                        widget.index,
                        _currentPosition,
                        captionController.value.text,
                        cityController.value.text);
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
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageModal.images.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.33,
                                height:
                                    MediaQuery.of(context).size.height * 0.2475,
                                color: Colors.transparent,
                                child: (imageModal.images[index] != null)
                                    ? AspectRatio(
                                        aspectRatio: 4 / 5,
                                        child: Image.file(
                                            imageModal.images[index]!))
                                    : null,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ))));
  }
}

class InputBox extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  const InputBox({
    required this.icon,
    required this.hint,
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: Theme.of(context).textTheme.displayMedium,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          hintStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
