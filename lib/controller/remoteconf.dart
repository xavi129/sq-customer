import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

enum AppState {
  adsfood,
  adssuper
}

class AdsController extends GetxController {
  bool adsfood = false;
  bool adssuper = false;

  void remoteController(AppState appState) async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    try {
      // Fetch and activate the remote config
      await remoteConfig.fetchAndActivate();

      // Get the remote config values
      adsfood = remoteConfig.getBool('adsfood');
      adssuper = remoteConfig.getBool('adssuper');
      debugPrint('remoteconf adsfood: $adsfood');
    } catch (e) {
      debugPrint('Failed to fetch remote config: $e');
    }
    
    update();
  }
}