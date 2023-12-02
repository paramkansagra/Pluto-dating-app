import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/models/profile_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Config/config.dart';
import '../Widgets/widget.dart';
import '../models/prompt_answer_model.dart';
import '../models/user_media_model.dart';
import '../provider/sign_in_provider.dart';
import 'screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileApi profileApi = ProfileApi();
  late PromptAnswerModel promptAnswerModel;

  late ProfileModel profileData;
  late List<String> interestElement;
  late Map<String, dynamic> interestMap;
  late Map<String, String> interestEmoticons;
  String? city;
  late NetworkImage networkImage;
  late UserMediaModel userMedia;
  @override
  void initState() {
    super.initState();
    showModel();
  }

  Future<void> showModel() async {
    userMedia = await profileApi.fetchMedia();
    promptAnswerModel = await profileApi.fetchPromptAnswers();
    profileData = await profileApi.fetchProfile();
    interestElement = await profileApi.fetchUserInterest();
    interestMap = await profileApi.fetchInterestList();
    interestEmoticons = profileApi.fetchInterestEmojiMap(interestMap);
    city = await profileApi.getCityName(
      profileData.data!.latitude ?? 20.79,
      profileData.data!.longitude ?? 20.79,
    );
    networkImage = NetworkImage(userMedia.data?.elementAt(0).url ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
      ),
      backgroundColor: const Color(0XFFE7E7E7),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark),
        iconTheme: const IconThemeData(color: Colors.grey, size: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, const Settings());
            },
            icon: const Icon(
              Icons.settings,
              size: 28,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Sign Out',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              trailing: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onTap: () {
                sp.userSignOut();
                nextScreen(context, const LoginScreen());
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: showModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      viewProfileModalSheet(
                        context,
                        profileData,
                        interestElement,
                        city ?? "Empty",
                      );
                    },
                    // ignore: unnecessary_null_comparison
                    child: networkImage == null
                        ? const CircularProgressIndicator()
                        : CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            radius: 100,
                            backgroundImage: networkImage),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${profileData.data!.firstName ?? "Undefined"}, ${profileData.data!.age ?? "Undefined"}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void viewProfileModalSheet(BuildContext context, ProfileModel profileData,
      List<String> interestData, String city) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) {
        return Card(
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: ProfileCardWidget(
                  city: city,
                  userMediaModel: userMedia,
                  interestElement: interestElement,
                  interestEmoticons: interestEmoticons,
                  promptAnswerModel: promptAnswerModel,
                  profileData: profileData,
                  check: 0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 16,
                child: ElevatedButton(
                  onPressed: () {
                    nextScreen(context, const EditProfile());
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Text(
                    style: Theme.of(context).textTheme.displayMedium,
                    "Edit profile",
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        );
      },
    );
  }
}
