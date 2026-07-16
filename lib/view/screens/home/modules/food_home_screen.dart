import 'package:flutter/material.dart';
import 'package:sq_customer/controller/config_remote.dart';
import 'package:sq_customer/view/screens/home/ads.dart';
// import 'package:sq_customer/controller/auth_controller.dart';
import 'package:sq_customer/view/screens/home/widget/bad_weather_widget.dart';
import 'package:sq_customer/view/screens/home/widget/grocery/best_store_nearby_view.dart';
import 'package:sq_customer/view/screens/home/widget/grocery/category_view.dart';
// import 'package:sq_customer/view/screens/home/widget/grocery/item_that_you_love_view.dart';
import 'package:sq_customer/view/screens/home/widget/grocery/just_for_you_view.dart';
import 'package:sq_customer/view/screens/home/widget/grocery/most_popular_item_view.dart';
import 'package:sq_customer/view/screens/home/widget/grocery/new_on_mart_view.dart';
import 'package:sq_customer/view/screens/home/widget/grocery/special_offer_view.dart';
import 'package:sq_customer/view/screens/home/widget/banner_view.dart';
import 'package:sq_customer/util/images.dart';

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

       Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.foodModuleBannerBg),
            fit: BoxFit.cover,
          ),
        ),
        child:  const Column(
          children: [
            BadWeatherWidget(),

            BannerView(isFeatured: false),
            SizedBox(height: 12),
          ],
        ),
      ),

      const CategoryView(),
      // isLoggedIn ? const VisitAgainView(fromFood: true) : const SizedBox(),
       Config.adsfood ? const Bannerads() : const SizedBox.shrink(),
      const SpecialOfferView(isFood: true, isShop: false),
      const BestStoreNearbyView(),
      // const ItemThatYouLoveView(forShop: false),
      const MostPopularItemView(isFood: true, isShop: false),
      const JustForYouView(),
      const NewOnMartView(isNewStore: true, isPharmacy: false, isShop: false),
    ]);
  }
}
