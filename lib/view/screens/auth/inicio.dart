import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_delivery_customer/helper/route_helper.dart';
import 'package:sq_delivery_customer/util/images.dart';
import 'package:sq_delivery_customer/util/styles.dart';
import 'package:sq_delivery_customer/view/screens/auth/widget/guest_button.dart';
import 'package:sq_delivery_customer/view/screens/auth/widget/social_login_widget.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Images.background,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Fondo oscuro semi-transparente
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'register_now'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                       Text(
                        'benefits_exclusive'.tr,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                       Text(
                        'now_benefits'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                       Text(
                        'valid_for_new_users'.tr,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                       Text(
                        'applied_tyc'.tr,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // const SizedBox(height: 15),
                      // ElevatedButton.icon(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.blue,
                      //     minimumSize: const Size(double.infinity, 50),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //   ),
                      //   icon: const Icon(Icons.account_circle, color: Colors.white),
                      //   label: const Text('Continúa con Google'),
                      //   onPressed: () async {
                      //     GoogleSignInAccount googleAccount = (await googleSignIn.signIn())!;
                      //     GoogleSignInAuthentication auth = await googleAccount.authentication;
                      //     Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
                      //       email: googleAccount.email, token: auth.idToken, uniqueId: googleAccount.id, medium: 'google',
                      //     ));
                      //   },
                      // ),
                      // const SizedBox(height: Dimensions.paddingSizeSmall),
                      // Altura deseada2
                         const SocialLoginWidget(),
                     
                      // const SizedBox(height: 15),
                      // ElevatedButton.icon(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.black,
                      //     minimumSize: const Size(double.infinity, 50),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //   ),
                      //   icon: const Icon(Icons.apple, color: Colors.grey),
                      //   label: const Text('Continúa con tu Apple'),
                      //   onPressed: () {
                      //     Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                      //   },
                      // ),
                      const SizedBox(height: 15),
 
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).disabledColor,
                          minimumSize: const Size(330, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        icon: const Icon(Icons.phone, color: Colors.white),
                        label: const Text('Continúa con tu Numero de Teléfono'),
                        onPressed: () {
                          Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                        },
                      ),  
                      
                      const SizedBox(height: 15),
                     
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, 
                          minimumSize: const Size(340, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        icon: const Icon(Icons.email, color: Colors.white),
                        label: const Text('Continúa con tu correo'),
                        onPressed: () {
                          Get.toNamed(RouteHelper.getSignUpRoute());  
                        },
                      ),
                      
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute(false, null)),
                        child: Text('forgot_password'.tr, style: robotoRegular.copyWith(color: Colors.white)),
                      ),
                      const SizedBox(height: 30),
                      const GuestButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}