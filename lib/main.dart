import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sq_customer/controller/config_remote.dart';
import 'package:sq_customer/controller/auth_controller.dart';
import 'package:sq_customer/controller/cart_controller.dart';
import 'package:sq_customer/controller/localization_controller.dart';
import 'package:sq_customer/controller/location_controller.dart';
import 'package:sq_customer/controller/splash_controller.dart';
import 'package:sq_customer/controller/theme_controller.dart';
import 'package:sq_customer/controller/wishlist_controller.dart';
import 'package:sq_customer/data/model/body/notification_body.dart';
import 'package:sq_customer/helper/notification_helper.dart';
import 'package:sq_customer/helper/responsive_helper.dart';
import 'package:sq_customer/helper/route_helper.dart';
import 'package:sq_customer/theme/dark_theme.dart';
import 'package:sq_customer/theme/light_theme.dart';
import 'package:sq_customer/util/app_constants.dart';
import 'package:sq_customer/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sq_customer/view/screens/home/ads.dart';
import 'package:sq_customer/view/screens/home/widget/cookies_view.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wiredash/wiredash.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if(ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  Map<String, Map<String, String>> languages = await di.init();
 
  NotificationBody? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(_) {}
  await MobileAds.instance.initialize();
  await Config.initConfig();
    if (Config.openapp == true) {
    loadAppOpenAd();
  }
  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  const MyApp({Key? key, required this.languages, required this.body}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    _route();
  }

  void _route() async {
    if(GetPlatform.isWeb) {
      await Get.find<SplashController>().initSharedData();
      if(Get.find<LocationController>().getUserAddress() != null && Get.find<LocationController>().getUserAddress()!.zoneIds == null) {
        Get.find<AuthController>().clearSharedAddress();
      }

      if(!Get.find<AuthController>().isLoggedIn() && !Get.find<AuthController>().isGuestLoggedIn() /*&& !ResponsiveHelper.isDesktop(Get.context!)*/) {
        await Get.find<AuthController>().guestLogin();
      }
      if((Get.find<AuthController>().isLoggedIn() || Get.find<AuthController>().isGuestLoggedIn()) && Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }
    }
    Get.find<SplashController>().getConfigData(loadLandingData: GetPlatform.isWeb).then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          if(Get.find<SplashController>().module != null) {
            await Get.find<WishListController>().getWishList();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Wiredash(
      projectId: 'sq-entregas-98iuk50',
      secret: 'DnhiPr_t0OyAz0O0YbD-Fy8KuUEICXQ8',
      options: const WiredashOptionsData(
    locale: Locale('es', 'MX'),
    ),
    child: GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null) ? const SizedBox() : GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            ),
            theme: themeController.darkTheme ? dark() : light(),
            locale: localizeController.locale,
            translations: Messages(languages: widget.languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
            initialRoute: GetPlatform.isWeb ? RouteHelper.getInitialRoute() : RouteHelper.getSplashRoute(widget.body),
            getPages: RouteHelper.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
            builder: (BuildContext context, widget) {
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: Material(
                child: Stack(children: [
                  widget!,
                  GetBuilder<SplashController>(builder: (splashController){
                    if(!splashController.savedCookiesData && !splashController.getAcceptCookiesStatus(splashController.configModel != null ? splashController.configModel!.cookiesText! : '')){
                      return ResponsiveHelper.isWeb() ? const Align(alignment: Alignment.bottomCenter, child: CookiesView()) : const SizedBox();
                    }else{
                      return const SizedBox();
                    }
                  })
                ]),
              ));
          },
          );
        });
      });
    }),
  );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}