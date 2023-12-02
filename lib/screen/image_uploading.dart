import 'dart:io';
import 'package:dating_app/Config/config.dart';
import 'package:dating_app/Widgets/custom_snackbar.dart';
import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/models/user_media_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/upload_image_provider.dart';
import 'screen.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ImageUploading extends StatefulWidget {
  const ImageUploading({super.key});
  @override
  State<ImageUploading> createState() => _ImageUploadingState();
}

class _ImageUploadingState extends State<ImageUploading> {
  Future<void> pickImage(int index) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // ignore: use_build_context_synchronously
      nextScreen(context,
          ImagePreview(imageFile: File(pickedImage.path), index: index));
    }
  }

  UserMediaModel getImage = UserMediaModel();

  Future<UserMediaModel?> getUserMedia() async {
    getImage = await ProfileApi().fetchMedia();
    const Duration(seconds: 2);
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageUploadProvider>(
      builder: ((context, imageModel, child) => Scaffold(
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(36, 36, 36, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Text(
                        "Upload Your First Photo and Let Your Personality Shine!",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        "You have the option to delete or upload new pictures to your profile whenever you wish.",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
                    Expanded(
                      child: ReorderableGridView.count(
                        childAspectRatio: 4 / 5,
                        crossAxisCount: 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        onReorder: (oldIndex, newIndex) {
                          if (imageModel.uploadCompleted[newIndex] &&
                              imageModel.images[newIndex] != null) {
                            final element =
                                imageModel.images.removeAt(oldIndex);
                            imageModel.images.insert(newIndex, element);
                            setState(() {});
                          }
                        },
                        children: List.generate(
                          4,
                          (index) => GestureDetector(
                            key: ValueKey(index),
                            onTap: imageModel.isButtonEnable(index)
                                ? () {
                                    pickImage(index);
                                  }
                                : null,
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.38,
                              width: MediaQuery.of(context).size.width * 0.38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: imageModel.isButtonEnable(index)
                                    ? Colors.white
                                    : const Color(0XFFF2F2F2).withOpacity(0.20),
                              ),
                              child: imageModel.isButtonEnable(index)
                                  ? (imageModel.images[index] == null
                                      ? SvgPicture.asset(
                                          "assets/images/Add.svg")
                                      : imageModel.uploadCompleted[index]
                                          ? AspectRatio(
                                              aspectRatio: 4 / 5,
                                              child: (Image.file(
                                                imageModel.images[index]!,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.38 *
                                                    4 /
                                                    5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.38,
                                                fit: BoxFit.cover,
                                              )),
                                            )
                                          : CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ))
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (imageModel.images.every((image) => image != null)) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const FirstScreen()),
                      (Route route) => false);
                } else {
                  customSnackBar(
                      text: "Upload atleast 4 images", context: context);
                }
              },
              backgroundColor: Colors.white.withOpacity(0.5),
              child: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          )),
    );
  }
}
