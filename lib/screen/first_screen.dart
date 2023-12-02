import 'package:dating_app/models/user_media_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/widget.dart';
import '../api/profile_api.dart';
import "package:dating_app/Config/config.dart";
import '../models/profile_model.dart';
import '../models/prompt_answer_model.dart';
import '../provider/internet_provider.dart';
import '../provider/sign_in_provider.dart';
import 'screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late ProfileModel profileData;
  late List<String> interestElement;
  late Map<String, dynamic> interestMap;
  late Map<String, String> interestEmoticons;
  late UserMediaModel userMedia;
  String city = "";
  ProfileApi profileApi = ProfileApi();
  late PromptAnswerModel promptAnswerModel;

  Future<void> fetchApi() async {
    UserMediaModel allMedia = await profileApi.fetchMedia();
    // List<ImageData> filteredMedia =
    //     allMedia.data!.where((media) => media.orderId != 0).toList();
    // for (int i = 0; i < filteredMedia.length; i++) {
    //   log(filteredMedia[i].url);
    // }
    // filteredMedia.sort((a, b) => a.orderId!.compareTo(b.orderId!));

    userMedia = UserMediaModel(data: allMedia.data);
    profileData = await profileApi.fetchProfile();
    // nonNullBasics = getNonNull(profileData);
    interestElement = await profileApi.fetchUserInterest();
    interestMap = await profileApi.fetchInterestList();
    interestEmoticons = profileApi.fetchInterestEmojiMap(interestMap);
    promptAnswerModel = await profileApi.fetchPromptAnswers();
    city = await profileApi.getCityName(
      profileData.data!.latitude ?? 20.22,
      profileData.data!.longitude ?? 20.22,
    );
  }

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    final ip = context.read<InternetProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ip.checkInternetConnection();
    });
    ip.subscribeToConnectivityChanges();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final ip = context.watch<InternetProvider>();
    final sp = context.watch<SignInProvider>();

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
      ),
      appBar: CustomAppBar(sp: sp),
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
            )
          ],
        ),
      ),
      backgroundColor: const Color(0XFFF1F1F1),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (!ip.hasInternet) {
              return const OfflineScreenCard();
            } else {
              return FutureBuilder(
                future: fetchApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return throw Exception("Error: ${snapshot.error}");
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SafeArea(
                        child:
                            // Stack(
                            //   children: [
                            ProfileCardWidget(
                          city: city,
                          userMediaModel: userMedia,
                          interestElement: interestElement,
                          interestEmoticons: interestEmoticons,
                          promptAnswerModel: promptAnswerModel,
                          profileData: profileData,
                          check: 1,
                        ),
                        // swipe != Swipe.none
                        //     ? swipe == Swipe.right
                        //         ? Positioned(
                        //             top: 50,
                        //             right: 24,
                        //             child: Transform.rotate(
                        //               angle: -12,
                        //               child: TagWidget(
                        //                 text: 'DISLIKE',
                        //                 color: Colors.red[400]!,
                        //               ),
                        //             ),
                        //           )
                        //         : Positioned(
                        //             top: 40,
                        //             left: 20,
                        //             child: Transform.rotate(
                        //               angle: 12,
                        //               child: TagWidget(
                        //                 text: 'LIKE',
                        //                 color: Colors.green[400]!,
                        //               ),
                        //             ),
                        //           )
                        //     : const SizedBox.shrink(),
                        // ],
                        // )
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class OfflineScreenCard extends StatelessWidget {
  const OfflineScreenCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "That's all until you're online",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 20, wordSpacing: 1.25),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
              "But don't let a little thing like having no internet stops you connecting with people!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  wordSpacing: 1.25,
                  fontSize: 14,
                  fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: color,
            width: 4,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 36,
        ),
      ),
    );
  }
}
