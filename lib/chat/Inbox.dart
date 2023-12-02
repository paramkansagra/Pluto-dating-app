import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/chat/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat/data/dummy_data.dart';
import '../Config/config.dart';
import '../Widgets/widget.dart';
import '../models/profile_model.dart';
import '../provider/sign_in_provider.dart';
import '../screen/screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "../models/matched_model.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  MatchedModel matchedList = MatchedModel();
  List<ProfileModel?> matchedProfileList = [null];

  Future<void> fetchMatchedList() async {
    matchedList = await ProfileApi().matchedProfiles();
    for (int i = 0; i < (matchedList.data?.length ?? 0); i++) {
      // if (i == 0) {
      //   matchedProfileList[0] = await ProfileApi()
      //       .fetchProfile(user_id: matchedList.data![i].matchId.toString());
      // } else {
      //   matchedProfileList.add(
      //     await ProfileApi()
      //         .fetchProfile(user_id: matchedList.data![i].matchId.toString()),
      //   );
      // }
      final matchId = matchedList.data?[i].matchId.toString();
      if (matchId != null) {
        final profile = await ProfileApi().fetchProfile(userId: matchId);
        matchedProfileList.add(profile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      backgroundColor: const Color(0XFFE9E9E9),
      appBar: AppBar(
        backgroundColor: const Color(0XFF047E78),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.settings_outlined))
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
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
      ),
      body: FutureBuilder(
          future: fetchMatchedList(),
          builder: (context, future) {
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0XFF379590),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:
                        // matchedList.data!.isNotEmpty
                        //     ? Wrap(
                        //         children: List.generate(
                        //           matchedList.data!.length,
                        //           (index) => StoryWidget(
                        //               imageUrl: matchedList.data![index].url!),
                        //         ),
                        //       )
                        //     : const SizedBox(),
                        matchedList.data != null && matchedList.data!.isNotEmpty
                            ? Wrap(
                                children: List.generate(
                                  matchedList.data!.length,
                                  (index) => StoryWidget(
                                    imageUrl: matchedList.data![index].url ??
                                        '', // Provide a default value for imageUrl
                                  ),
                                ),
                              )
                            : const SizedBox(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chats",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.filter_list_outlined,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                // ListView.builder(
                //     itemCount: matchedProfileList.length,
                //     itemBuilder: (context, index) {
                //       return ChatListWidget();
                //     }),
                ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return const ChatListWidget();
                    }),
              ],
            );
          }),
    );
  }
}

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: CircleAvatar(
          radius: 6,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      leading: InkWell(
        onTap: () {
          nextScreen(context, const StoryScreen(stories: stories));
        },
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider(
            user.profileImageUrl,
          ),
          child: stories.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2),
                  ),
                )
              : null,
        ),
      ),
      contentPadding: const EdgeInsets.only(right: 8, bottom: 8),
      title: Transform.translate(
          offset: const Offset(-24, 0),
          child: Text(
            user.name,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.black, fontSize: 16),
          )),
      subtitle: Transform.translate(
          offset: const Offset(-24, 0),
          child: Text(
            "Going for hiking🧗.. Wanna join?",
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Colors.black),
          )),
    );
  }
}

class StoryWidget extends StatelessWidget {
  final String imageUrl;

  const StoryWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            nextScreen(context, const StoryScreen(stories: stories));
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: CachedNetworkImageProvider(
              imageUrl,
            ),
            child: stories.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 4),
                    ),
                  )
                : null,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: TooltipShapeBorder(arrowArc: 0.5),
                  shadows: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2))
                  ],
                ),
                child: const Text(
                  "CSK VS MI",
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  const TooltipShapeBorder({
    this.radius = 20.0,
    this.arrowWidth = 8.0,
    this.arrowHeight = 8.0,
    this.arrowArc = 1.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..addOval(Rect.fromCircle(
          center: Offset(rect.bottomLeft.dx + 16, rect.bottom), radius: 8))
      ..addOval(Rect.fromCircle(
          center: Offset(rect.bottomLeft.dx + 22, rect.bottom + 12),
          radius: 4));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
