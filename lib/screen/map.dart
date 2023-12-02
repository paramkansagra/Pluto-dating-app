// ignore_for_file: camel_case_types

import 'package:dating_app/Config/config.dart';
import 'package:dating_app/screen/Event/add_event.dart';

import 'package:dating_app/Widgets/buttom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'Event/view_event.dart';

class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  GoogleMapController? _controller;
  bool isLoading = true;

  late LocationData _currentPosition;
  // late String _address;
  Location location = Location();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ignore: unused_field
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  fetchLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

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

    setState(() {
      isLoading = false;
    });
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentPosition = currentLocation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                ))
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    zoom: 13.5,
                    target: LatLng(_currentPosition.latitude ?? 37.7749,
                        _currentPosition.longitude ?? -122.4194)),
                markers: {
                  Marker(
                      markerId: const MarkerId("Current Location"),
                      position: LatLng(_currentPosition.latitude ?? 37.7749,
                          _currentPosition.longitude ?? -122.4194)),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _controller!.animateCamera(CameraUpdate.newLatLng(LatLng(
                      _currentPosition.latitude ?? 37.7749,
                      _currentPosition.longitude ?? -122.4194)));
                },
              ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 14),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onPressed: () {
                    nextScreen(context, const ViewEvent());
                  },
                  child: const Text("My Events")),
            ),
            FloatingActionButton(
              onPressed: () {
                nextScreen(context, const AddEvent(null));
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(
                Icons.add,
              ),
            ),
          ],
        ));
  }
}
