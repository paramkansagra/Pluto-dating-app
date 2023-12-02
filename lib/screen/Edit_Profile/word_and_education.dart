import "package:dating_app/api/profile_api.dart";
import "package:flutter/material.dart";

import "../../models/profile_model.dart";

Scaffold occupationAndEducation(
    {required BuildContext context,
    required String heading,
    required String subHeading,
    required String tileHeading,
    required int index}) {
  late ProfileModel profileData;
  ProfileApi profileApi = ProfileApi();

  // late TextEditingController firstBox;
  // late TextEditingController secondBox;

  List<TextEditingController> fieldControllers = [
    TextEditingController(),
    TextEditingController()
  ];

  Future<void> fetchApi() async {
    profileData = await profileApi.fetchProfile();
  }

  List<dynamic> hintText = [
    ["Title", "Company (or just Industry)"],
    ["Institution", "Graduation year"]
  ];

  return Scaffold(
    backgroundColor: const Color(0XFFE7E7E7),
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text(
        heading,
        style: Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        color: Colors.black,
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: FutureBuilder(
        future: fetchApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            throw Exception(snapshot.error);
          } else {
            return Container(
              margin: const EdgeInsets.fromLTRB(6, 20, 6, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subHeading,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                          wordSpacing: 1.3)),
                  const SizedBox(
                    height: 16,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Colors.white,
                    title: Text(tileHeading,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14,
                                wordSpacing: 1.3)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0XFFE7E7E7),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return alertBox(context, heading, hintText, index,
                                fieldControllers, profileData);
                          });
                    },
                  ),
                  index == 1
                      ? profileData.data!.college != null &&
                              profileData.data!.college!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                1,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    tileColor: Colors.white,
                                    title: Text(profileData.data!.college!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14,
                                                wordSpacing: 1.3)),
                                    leading:
                                        const Icon(Icons.check_circle_rounded),
                                    contentPadding: const EdgeInsets.all(10),
                                    minLeadingWidth: 0,
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0XFFE7E7E7),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox()
                      : profileData.data!.occupation != null &&
                              profileData.data!.occupation!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                1,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    tileColor: Colors.white,
                                    title: Text(profileData.data!.occupation!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14,
                                                wordSpacing: 1.3)),
                                    leading:
                                        const Icon(Icons.check_circle_rounded),
                                    contentPadding: const EdgeInsets.all(10),
                                    minLeadingWidth: 0,
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0XFFE7E7E7),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                ],
              ),
            );
          }
        }),
  );
}

AlertDialog alertBox(
    BuildContext context,
    String heading,
    List<dynamic> hintText,
    int index,
    List<TextEditingController> controllers,
    ProfileModel profileData) {
  return AlertDialog(
    actionsPadding: const EdgeInsets.all(10),
    actions: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel")),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          onPressed: () async {
            if (controllers[0].value.text.length >= 3) {
              if (index == 1) {
                profileData.data!.college = controllers[0].value.text;
              } else if (index == 0) {
                profileData.data!.occupation = controllers[0].value.text;
              }
              profileData = await ProfileApi().updateProfile(profileData);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            }
          },
          child: const Text("Save")),
    ],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
    ),
    title: Text(heading),
    contentPadding: const EdgeInsets.all(10.0),
    content: Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: controllers[0],
              autofocus: true,
              decoration: InputDecoration(
                hintText: hintText[index][0],
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: controllers[1],
              decoration: InputDecoration(
                hintText: hintText[index][1],
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ]),
    ),
  );
}
