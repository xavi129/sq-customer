import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sq_customer/util/dimensions.dart';

class Bannerads extends StatefulWidget {
  const Bannerads({Key? key}) : super(key: key);

  @override
  BannerExampleState createState() => BannerExampleState();
}

class BannerExampleState extends State<Bannerads> {
  BannerAd? _bannerAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-5048252174354106/8332454347'
      : 'ca-app-pub-5048252174354106/9281222863';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
 Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
    child: Column(
      children: [
        _bannerAd != null
          ? Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            )
          : const SizedBox.shrink(), // or Container() or any other widget
      ],
    ),
  );
}

  void _loadAd() async {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

AppOpenAd? myAppOpenAd;

String appOpenAdUnitId = Platform.isAndroid
    ? 'ca-app-pub-5048252174354106/7666008427'
    : 'ca-app-pub-5048252174354106/4840033526';

loadAppOpenAd() {
  AppOpenAd.load(
      adUnitId: appOpenAdUnitId, //Your ad Id from admob
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            myAppOpenAd = ad;
            myAppOpenAd!.show();
          },
          onAdFailedToLoad: (error) {}),
      orientation: AppOpenAd.orientationPortrait);
}