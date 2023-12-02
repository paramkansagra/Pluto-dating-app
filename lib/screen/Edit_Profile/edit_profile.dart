import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dating_app/Config/config.dart';
import 'package:dating_app/Widgets/custom_snackbar.dart';
import 'package:dating_app/api/download_nudge_api.dart';
import 'package:dating_app/api/send_nudge_api.dart';
import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/models/prompt_answer_model.dart';
import 'package:dating_app/models/user_media_model.dart';
import 'package:dating_app/screen/Edit_Profile/edit_answer.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Widgets/custom_choice_button.dart';
import '../../api/profile_api.dart';
import '../../models/prompt_model.dart';
import '../../provider/upload_image_provider.dart';
import 'more_about_me.dart';
import 'word_and_education.dart';
import 'update_gender.dart';
import '../edit_screen_image_preview.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController bioController = TextEditingController();
  late ProfileModel profileData;
  ProfileApi profileApi = ProfileApi();
  late List<String> interestElements;
  late Map<String, dynamic> interestList;
  late Map<String, dynamic> interestEmoticons;
  List<String>? questions;
  int order = 1;
  ApiData apiData = ApiData();
  double radius = 15;
  List<Nudges>? promptData;
  ImageUploadProvider imageUploadProvider = ImageUploadProvider();
  List<String?> promptQuestion = [];
  late UserMediaModel mediaModel;

  void myBasicsRoutes(int index) async {
    Map<String, dynamic>? returnProfileResponse;

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => occupationAndEducation(
                context: context,
                heading: "Occupation",
                subHeading:
                    "You can only show one job on your profile at a time",
                tileHeading: "Add a job",
                index: index),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => occupationAndEducation(
              context: context,
              heading: "Education",
              subHeading:
                  "You can only show one institution on your profile at a time",
              tileHeading: "Add education",
              index: index,
            ),
          ),
        );
        break;
      case 2:
        returnProfileResponse = await showModalBottomSheet(
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            context: context,
            builder: (context) {
              return ChecklistBottomSheet(
                profileModel: profileData,
              );
            });
    }
    if (returnProfileResponse != null) {
      Map<String, dynamic> update = {
        "data": returnProfileResponse,
        "message": "Successfull"
      };

      profileData = ProfileModel.fromJson(update);
      profileApi.updateProfile(profileData);
    }
  }

  void moreAboutMeRoutes(int index) async {
    Map<String, dynamic>? returnProfileResponse = await showModalBottomSheet(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.9),
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) {
          return MoreAboutMe(
            profileModel: profileData,
            optionIndex: index,
            optionResponse: options,
          );
        });

    if (returnProfileResponse != null) {
      Map<String, dynamic> update = {
        "data": returnProfileResponse,
        "message": "Successfull"
      };

      profileData = ProfileModel.fromJson(update);
      profileApi.updateProfile(profileData);
    }
  }

  late List<Widget> imageBoxes;
  List myBasics = [
    [Icons.work_outline, "Work", Icons.arrow_forward_ios_rounded],
    [Icons.school_outlined, "Education", Icons.arrow_forward_ios_rounded],
    [Icons.person_outline_sharp, "Gender", Icons.arrow_forward_ios_rounded],
    [Icons.pin_drop_outlined, "Location", Icons.arrow_forward_ios_rounded],
    [Icons.home_filled, "Town", Icons.arrow_forward_ios_rounded],
  ];
  List moreAboutMe = [
    [Icons.work_outline, "Height", Icons.arrow_forward_ios_rounded],
    [Icons.school_outlined, "Excercise", Icons.arrow_forward_ios_rounded],
    [
      Icons.person_outline_sharp,
      "Education Level",
      Icons.arrow_forward_ios_rounded
    ],
    [Icons.pin_drop_outlined, "Drinking", Icons.arrow_forward_ios_rounded],
    [Icons.home_filled, "Smoking", Icons.arrow_forward_ios_rounded],
    [Icons.work_outline, "Looking for", Icons.arrow_forward_ios_rounded],
    [Icons.school_outlined, "Kids", Icons.arrow_forward_ios_rounded],
    [Icons.person_outline_sharp, "Zodiac", Icons.arrow_forward_ios_rounded],
    [Icons.pin_drop_outlined, "Politics", Icons.arrow_forward_ios_rounded],
    [Icons.home_filled, "Religion", Icons.arrow_forward_ios_rounded],
  ];

  PromptAnswerModel? promptAnswerModel;
  late Map<String, dynamic> options;

  Future<void> pickImage(int index) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // ignore: use_build_context_synchronously
      nextScreen(
          context, EditScreenImagePreview(imageFile: File(pickedImage.path)));
    }
  }

  void deleteChosenPrompt() {
    if (promptAnswerModel!.data!.isNotEmpty) {
      for (int i = 0; i < promptAnswerModel!.data!.length; i++) {
        promptQuestion.remove(promptAnswerModel!.data![i].question);
      }
    }
  }

  Future<void> fetchApi() async {
    options = await profileApi.getEditOptions();
    mediaModel = await profileApi.getImage();

    profileData = await profileApi.fetchProfile();
    promptAnswerModel = await fetchPromptAnswers();
    interestElements = await profileApi.fetchUserInterest();
    interestList = await profileApi.fetchInterestList();
    interestEmoticons = profileApi.fetchInterestEmojiMap(interestList);
    imageUploadProvider.initSharedPreferences();
    http.Response response = await http.get(
      Uri.parse("https://firstpluto.com/nudges"),
    );
    if (response.statusCode == 200) {
      PromptsModel data = PromptsModel.fromJson(jsonDecode(response.body));
      promptData = data.nudges;
      promptQuestion = promptData!.map((element) => element.question).toList();
      deleteChosenPrompt();
    } else {
      throw Exception(
          "Error fetching prompts the status code is ${response.statusCode}");
    }
    if (profileData.data!.about != null &&
        profileData.data!.about!.isNotEmpty) {
      bioController.text = profileData.data!.about ?? "";
    }
  }

  Future<PromptAnswerModel> fetchPromptAnswers() async {
    http.Response response = await http.get(
      Uri.parse('${apiData.baseUrl}nudges'),
      headers: {"user_id": apiData.userId},
    );
    PromptAnswerModel promptAnswer = PromptAnswerModel();
    promptAnswer = PromptAnswerModel.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      return promptAnswer;
    } else {
      throw Exception(
          "Unable to fetch prompt answer status code is ${response.statusCode}");
    }
  }

  Future<void> updatePrompt(String answer, int order, int nudgeId) async {
    Map<String, dynamic> requestBody = {"answer": answer, "order": order};

    http.Response updateResponse = await http.put(
      Uri.parse('${apiData.baseUrl}nudge'),
      body: jsonEncode(requestBody),
      headers: {"user_id": apiData.userId, "nudge_id": nudgeId.toString()},
    );

    if (updateResponse.statusCode == 200) {
      log(jsonDecode(updateResponse.body));
      log("The update response code is ${updateResponse.statusCode}");
    } else {
      log("error updating the prompts response code is ${updateResponse.statusCode}");
    }
  }

  Future<void> postPrompt(String answer, String question) async {
    http.Response response = await http.post(
        Uri.parse('${apiData.baseUrl}nudge'),
        headers: {"user_id": apiData.userId},
        body: jsonEncode(
            {"answer": answer, "question": question, "order": order}));

    if (response.statusCode == 200) {
      log("Question posted Successfully");
      order++;
    } else {
      log("Error while postion ${response.statusCode}");
    }
  }

  Future<void> deleteNudge(int nudgeId) async {
    bool deleted = await SendNudge().deleteNudge(nudgeId);
    if (deleted) {
      log("Nudge has been deleted");
    } else {
      log("Nudge deleting not successful");
    }
  }

  @override
  void dispose() {
    bioController.dispose();
    imageUploadProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageUploadProvider>(
      builder: ((context, imageModel, child) => Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: IconButton(
                iconSize: 18,
                icon: const Icon(Icons.arrow_back_ios_new_sharp),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: FutureBuilder<void>(
              future: fetchApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Data has been fetched successfully, continue building the UI
                  return SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile Strength",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_rounded),
                            title: Text("34% Profile Completed",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Photos and Videos",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          Center(
                            child: Wrap(
                              runSpacing: 6.0,
                              spacing: 6.0,
                              children: List.generate(
                                mediaModel.data?.length ?? 0,
                                (index) => GestureDetector(
                                  onTap: () {
                                    actionSheetOfImage(context, index);
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.43,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    decoration: const BoxDecoration(
                                      color: Color(0XFFF2F2F2),
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: (Image.network(
                                        mediaModel.data?[index].url ?? "",
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.43 *
                                                4 /
                                                5,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.43,
                                        fit: BoxFit.cover,
                                      )),
                                    ),
                                  ),
                                ),
                              )..add(
                                  ((mediaModel.data?.length ?? 0) < 8 ||
                                          mediaModel.data!.isEmpty)
                                      ? GestureDetector(
                                          onTap: () {
                                            pickImage(
                                                mediaModel.data!.length - 1);
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.43,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.43,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: SvgPicture.asset(
                                                "assets/images/Add.svg"),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_rounded),
                            title: Text("Verify my profile",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "My interests",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Get specific about the things you love",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          // The fetched interest will be shown here
                          const SizedBox(
                            height: 10,
                          ),

                          //
                          //
                          //
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.black),
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: List<Widget>.generate(
                                interestElements.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    nextScreen(
                                      context,
                                      const Interest(
                                        editScreenChecker: true,
                                      ),
                                    );
                                  },
                                  child: customChoiceButton(
                                    interestElements[index],
                                    Colors.white.withOpacity(0.50),
                                    Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: Colors.black, fontSize: 12),
                                    emoji: interestEmoticons[
                                        interestElements[index]],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //
                          //
                          //
                          //
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Prompts",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Make your personality stand out from the crowd",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(
                            height: 7,
                          ),

                          // for the saved answers
                          // would generate later
                          Column(
                            children: List.generate(
                              promptAnswerModel!.data!.length,
                              (index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  alignment: Alignment.center,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.black, width: 0.5),
                                  ),
                                  child: ListTile(
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_sharp),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      promptAnswerModel!
                                              .data![index].question ??
                                          "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                    subtitle: Text(
                                      promptAnswerModel!
                                              .data![index].answer.isNotEmpty
                                          ? promptAnswerModel!
                                              .data![index].answer
                                          : promptAnswerModel!
                                              .data![index].type,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                    ),
                                    onTap: () {
                                      promtActionSheet(context, index);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),

                          promptAnswerModel!.data!.length < 4
                              ? ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  tileColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(radius),
                                  ),
                                  trailing: const Icon(Icons.add),
                                  title: Text("Add a question",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                  onTap: () {
                                    // showing the modal sheet
                                    showModalBottomSheet(
                                      // rounded corners on the top left and right
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      // it is scroll controlled
                                      isScrollControlled: true,
                                      context: context,
                                      // gave the max height of the box
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                      ),
                                      // the builder that is having the actual list
                                      builder: (BuildContext context) {
                                        // building a single child scroll view
                                        return SingleChildScrollView(
                                          // we are having a single column for showing the screen
                                          child: Column(
                                            // started with cross axis alignment as start
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // generating the list
                                            children: List.generate(
                                              // length of the list is equal to the length of the prompt question aprox 100
                                              promptQuestion.length,
                                              // giving inkwell for click
                                              (index) => InkWell(
                                                // when they are tapped we would be showing the answer sheet
                                                onTap: () {
                                                  // we will pop the prompt screen
                                                  Navigator.of(context).pop();

                                                  // --------------------------------
                                                  // we will push the answeing screen
                                                  answerAddingBottomSheet(
                                                    context,
                                                    indexPos: index,
                                                  ).whenComplete(() {
                                                    log("the answer sheet is closed");
                                                    setState(() {});
                                                  });
                                                  // -------------------------------
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  height: 100,
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor),
                                                  child: Text(
                                                    promptQuestion[index] ?? "",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              : const SizedBox(),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "My bio",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Write a fun and punchy intro",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.black, fontSize: 14),
                              maxLines: null,
                              keyboardType: TextInputType.text,
                              controller: bioController,
                              onSubmitted: (value) async {
                                profileData.data!.about = value;
                                await ProfileApi().updateProfile(profileData);
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                hintText: "A little bit about you...",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.grey),
                                contentPadding: const EdgeInsets.all(5),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "My basics",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                5,
                                (index) => ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  tileColor: Colors.white,
                                  leading: Icon(myBasics[index][0]),
                                  trailing: Icon(myBasics[index][2]),
                                  title: Text(myBasics[index][1],
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                  onTap: () {
                                    myBasicsRoutes(index);
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "More about me",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            "Cover the things most people are curious about",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                moreAboutMe.length,
                                (index) => ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  tileColor: Colors.white,
                                  leading: Icon(moreAboutMe[index][0]),
                                  trailing: Icon(moreAboutMe[index][2]),
                                  title: Text(moreAboutMe[index][1],
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                  onTap: () {
                                    moreAboutMeRoutes(index - 1);
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "My pronouns",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Be you on pluto and pick your pronouns",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          // The fetched interest will be shown here
                          const SizedBox(
                            height: 10,
                          ),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              leading: customChoiceButton(
                                "he/him",
                                Theme.of(context).scaffoldBackgroundColor,
                                Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Languages I know",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),

                          // The fetched interest will be shown here
                          const SizedBox(
                            height: 10,
                          ),

                          Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Wrap(spacing: 6, runSpacing: 6, children: [
                              customChoiceButton(
                                "English",
                                emoji: "💬",
                                Theme.of(context).scaffoldBackgroundColor,
                                Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: Colors.white, fontSize: 12),
                              ),
                              customChoiceButton(
                                "Hindi",
                                emoji: "💬",
                                Theme.of(context).scaffoldBackgroundColor,
                                Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: Colors.white, fontSize: 12),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Connected accounts",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Show off your socials",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          // The fetched interest will be shown here
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  trailing: const Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                  ),
                                  title: Text("Instagram",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                ),
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  trailing: const Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                  ),
                                  title: Text(
                                    "Spotify",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          )),
    );
  }

  Future<dynamic> actionSheetOfImage(BuildContext context, int index) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, "Cancel");
            },
            child: const Text("Cancel"),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                profileApi.deleteMedia(mediaModel.data?[index].iD ?? -1);
                pickImage(index);
                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                if (mediaModel.data!.length > 4) {
                  profileApi.deleteMedia(mediaModel.data?[index].iD ?? -1);
                  setState(() {});
                } else {
                  customSnackBar(
                      text: "Atleast 4 images should be there",
                      context: context);
                }

                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> promtActionSheet(BuildContext context, int index) {
    bool isUpdating = false;
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title:
                const Text("What would you like to with your Profile Prompt"),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () async {
                  // first we will check if the prompt type is audio video or text
                  // if it is audio or video we will download it and then send its nudge
                  if (!isUpdating) {
                    final promptType = promptAnswerModel!.data![index].type;
                    log("prompt type -> $promptType");
                    File? path;

                    isUpdating = true;
                    log("created one request");

                    if (promptType == "video" || promptType == "audio") {
                      // we have to download the file
                      if (promptType == "audio") {
                        path = await DefaultCacheManager().getSingleFile(
                          promptAnswerModel!.data![index].mediaUrl!,
                        );
                      } else {
                        String filePath = await DownloadNudgeApi()
                            .downloadNudge(promptAnswerModel!, index);
                        path = File(filePath);
                      }
                    }

                    // first pop the action sheet
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();

                    isUpdating = false;

                    // we will push them to first see what is the type of the media
                    log("this is the nudge id -> ${promptAnswerModel!.data![index].iD}");
                    // ignore: use_build_context_synchronously
                    await answerAddingBottomSheet(
                      context,
                      question: promptAnswerModel!.data![index].question,
                      answer: promptAnswerModel!.data![index].answer,
                      nudgeId: promptAnswerModel!.data![index].iD,
                      audioPath: promptType == "audio" ? path!.path : "",
                      videoPath: promptType == "video" ? path!.path : "",
                      // need to add the path of the video
                      // need to add the path of the audio if it is there
                    ).whenComplete(
                      () => log("the answer sheet is closed"),
                    );
                    // then we have the normal flow that is following
                    setState(() {});
                  } else {
                    log("not creating other request");
                  }
                },
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    deleteNudge(promptAnswerModel!.data![index].iD!);
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancel",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }

// bottom sheet for answering the questions
  Future<dynamic> answerAddingBottomSheet(
    BuildContext context, {
    int? indexPos,
    String? question,
    String? answer,
    String? audioPath,
    String? videoPath,
    int? nudgeId,
  }) {
    // so here we are passing the index of the question and also the question
    // maybe the answer as well
    return showModalBottomSheet(
      // giving the rounded borders
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      // giving it scroll capablity
      isScrollControlled: true,
      enableDrag: true,
      // giving it the constraints for height
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      // giving it the context that it needs
      context: context,
      // now building the actual widget
      builder: ((context) {
        // if we have the answer pehle se hi to fir we will go for the answer
        // i will make it null no matter what and just post it

        return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8),
                child: Text(
                  textAlign: TextAlign.center,
                  question ?? promptQuestion[indexPos!] ?? "",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                ),
              ),
              EditAnswer(
                question: question ?? promptQuestion[indexPos!] ?? "",
                prebuiltAnswer: answer ?? "",
                audioPath: audioPath ?? "",
                videoPath: videoPath ?? "",
                nudgeId: nudgeId ?? -1,
              ),
            ],
          ),
        );
      }),
    );
  }
}
