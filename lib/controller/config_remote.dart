import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  static final _config = FirebaseRemoteConfig.instance;

  static const _defaultValues = {
  "adssuper": "true",
  "adsfood": "true",
  "openapp": "true"
  };

  static Future<void> initConfig() async {
    await _config.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 30)));

    await _config.setDefaults(_defaultValues);
    await _config.fetchAndActivate();
  

    _config.onConfigUpdated.listen((event) async {
      await _config.activate();
    });
  }

  static bool get _showAd => _config.getBool('ads');

  //ad ids 
  static bool get adsfood => _config.getBool('adsfood');
  static bool get adssuper => _config.getBool('adssuper');
  static bool get openapp => _config.getBool('openapp');

  static bool get hideAds => !_showAd;
}