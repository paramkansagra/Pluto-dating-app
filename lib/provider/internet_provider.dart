import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider extends ChangeNotifier {
  late ConnectivityResult _connectivityResult;
  bool get hasInternet => _connectivityResult != ConnectivityResult.none;

  InternetProvider() {
    _connectivityResult = ConnectivityResult.none;
    checkInternetConnection();
    subscribeToConnectivityChanges();
  }

  Future<void> checkInternetConnection() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    notifyListeners();
  }

  void subscribeToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityResult = result;
      notifyListeners();
    });
  }
}
