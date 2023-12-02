// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// // import 'components/location_list_tile.dart';
// // import 'constants.dart';

// class SearchLocationScreen extends StatefulWidget {
//   const SearchLocationScreen({Key? key}) : super(key: key);

//   @override
//   State<SearchLocationScreen> createState() => _SearchLocationScreenState();
// }

// class _SearchLocationScreenState extends State<SearchLocationScreen> {
// Color primaryColor = const Color(0xFF006491);
// Color textColorLightTheme = const Color(0xFF0D0D0E);

// Color secondaryColor80LightTheme = const Color(0xFF202225);
// Color secondaryColor60LightTheme = const Color(0xFF313336);
// Color secondaryColor40LightTheme = const Color(0xFF585858);
// Color secondaryColor20LightTheme = const Color(0xFF787F84);
// Color secondaryColor10LightTheme = const Color(0xFFEEEEEE);
// Color secondaryColor5LightTheme = const Color(0xFFF8F8F8);

//   double defaultPadding = 16.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(left: defaultPadding),
//           child: CircleAvatar(
//             backgroundColor: secondaryColor10LightTheme,
//             child: SvgPicture.asset(
//               "assets/icons/location.svg",
//               height: 16,
//               width: 16,
//               color: secondaryColor40LightTheme,
//             ),
//           ),
//         ),
//         title: Text(
//           "Set Delivery Location",
//           style: TextStyle(color: textColorLightTheme),
//         ),
//         actions: [
//           CircleAvatar(
//             backgroundColor: secondaryColor10LightTheme,
//             child: IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.close, color: Colors.black),
//             ),
//           ),
//           SizedBox(width: defaultPadding)
//         ],
//       ),
// body: Column(
//   children: [
//     Form(
//       child: Padding(
//         padding: EdgeInsets.all(defaultPadding),
//         child: TextFormField(
//           onChanged: (value) {},
//           textInputAction: TextInputAction.search,
//           decoration: InputDecoration(
//             hintText: "Search your location",
//             prefixIcon: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: SvgPicture.asset(
//                 "assets/icons/location_pin.svg",
//                 color: secondaryColor40LightTheme,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//     Divider(
//       height: 4,
//       thickness: 4,
//       color: secondaryColor5LightTheme,
//     ),
//     Padding(
//       padding: EdgeInsets.all(defaultPadding),
//       child: ElevatedButton.icon(
//         onPressed: () {},
//         icon: SvgPicture.asset(
//           "assets/icons/location.svg",
//           height: 16,
//         ),
//         label: const Text("Use my Current Location"),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: secondaryColor10LightTheme,
//           foregroundColor: textColorLightTheme,
//           elevation: 0,
//           fixedSize: const Size(double.infinity, 40),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//           ),
//         ),
//       ),
//     ),
//     Divider(
//       height: 4,
//       thickness: 4,
//       color: secondaryColor5LightTheme,
//     ),
//     // LocationListTile(
//     //   press: () {},
//     //   location: "Banasree, Dhaka, Bangladesh",
//     // ),
//   ],
// ),
//     );
//   }
// }

import 'dart:developer';

import 'package:dating_app/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  Future<String?> fetchLocationUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/place/autocomplete/json",
        {"input": query, "key": ApiData().locationApiKey});

    String? response = await fetchLocationUrl(uri);

    if (response != null) {
      log(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColorLightTheme = const Color(0xFF0D0D0E);
    // Color secondaryColor80LightTheme = const Color(0xFF202225);
    // Color secondaryColor60LightTheme = const Color(0xFF313336);
    // Color secondaryColor40LightTheme = const Color(0xFF585858);
    // Color secondaryColor20LightTheme = const Color(0xFF787F84);
    Color secondaryColor10LightTheme = const Color(0xFFEEEEEE);
    Color secondaryColor5LightTheme = const Color(0xFFF8F8F8);
    double defaultPadding = 16.0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Search Location"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: TextFormField(
                onChanged: (value) {},
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: "Search your location",
                  prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.edit_location_outlined)),
                ),
              ),
            ),
          ),

          Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(defaultPadding),
            child: ElevatedButton.icon(
              onPressed: () {
                placeAutoComplete("dubai");
              },
              icon: const Icon(Icons.edit_location_outlined),
              label: const Text("Use my Current Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor10LightTheme,
                foregroundColor: textColorLightTheme,
                elevation: 0,
                fixedSize: const Size(double.infinity, 60),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),

          Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),
          // LocationListTile(
          //   press: () {},
          //   location: "Banasree, Dhaka, Bangladesh",
          // ),
        ],
      ),
    );
  }
}
