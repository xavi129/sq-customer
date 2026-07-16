import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sq_delivery_customer/controller/auth_controller.dart';
import 'package:sq_delivery_customer/controller/splash_controller.dart';
import 'package:sq_delivery_customer/data/model/body/social_log_in_body.dart';
import 'package:sq_delivery_customer/util/dimensions.dart';
import 'package:sq_delivery_customer/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Verificamos si hay opciones de inicio de sesión social disponibles
    bool isGoogleAvailable = Get.find<SplashController>().configModel != null &&
        Get.find<SplashController>().configModel!.socialLogin != null &&
        Get.find<SplashController>().configModel!.socialLogin!.isNotEmpty &&
        Get.find<SplashController>().configModel!.socialLogin![0].status! &&
        !GetPlatform.isIOS;

    bool isFacebookAvailable = Get.find<SplashController>().configModel != null &&
        Get.find<SplashController>().configModel!.socialLogin != null &&
        Get.find<SplashController>().configModel!.socialLogin!.length > 1 &&
        Get.find<SplashController>().configModel!.socialLogin![1].status!;

    bool isAppleAvailable = Get.find<SplashController>().configModel != null &&
        Get.find<SplashController>().configModel!.appleLogin != null &&
        Get.find<SplashController>().configModel!.appleLogin!.isNotEmpty &&
        Get.find<SplashController>().configModel!.appleLogin![0].status! &&
        !GetPlatform.isAndroid &&
        !GetPlatform.isWeb;

    if (isGoogleAvailable || isFacebookAvailable || isAppleAvailable) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón de inicio de sesión con Google
              if (isGoogleAvailable)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(335, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    shadowColor: Colors.grey[Get.isDarkMode ? 700 : 300],
                    elevation: 5,
                  ),
                  icon: Image.asset(
                    Images.google,
                    height: 24,
                    width: 24,
                  ),
                  label: Text(
                    'sign_in_google'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      GoogleSignInAccount? googleAccount =
                          await googleSignIn.signIn();
                      if (googleAccount != null) {
                        GoogleSignInAuthentication auth =
                            await googleAccount.authentication;
                        Get.find<AuthController>().loginWithSocialMedia(
                          SocialLogInBody(
                            email: googleAccount.email,
                            token: auth.idToken,
                            uniqueId: googleAccount.id,
                            medium: 'google',
                          ),
                        );
                      } else {
                        // El usuario canceló el inicio de sesión
                      }
                    } catch (e) {
                      // Manejo de errores
                    }
                  },
                ),

              // Espacio entre botones
              if (isGoogleAvailable && isFacebookAvailable)
                const SizedBox(width: Dimensions.paddingSizeSmall),

              // Botón de inicio de sesión con Facebook
              if (isFacebookAvailable)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(335, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    shadowColor: Colors.grey[Get.isDarkMode ? 700 : 300],
                    elevation: 5,
                  ),
                  icon: Image.asset(
                    Images.socialFacebook,
                    height: 24,
                    width: 24,
                  ),
                  label: Text(
                    'sign_in_facebook'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      LoginResult result =
                          await FacebookAuth.instance.login();
                      if (result.status == LoginStatus.success) {
                        Map<String, dynamic> userData =
                            await FacebookAuth.instance.getUserData();
                        Get.find<AuthController>().loginWithSocialMedia(
                          SocialLogInBody(
                            email: userData['email'],
                            token: result.accessToken!.token,
                            uniqueId: result.accessToken!.userId,
                            medium: 'facebook',
                          ),
                        );
                      } else {
                        // El usuario canceló el inicio de sesión
                      }
                    } catch (e) {
                      // Manejo de errores
                    }
                  },
                ),

              // Espacio entre botones
              if ((isGoogleAvailable || isFacebookAvailable) && isAppleAvailable)
                const SizedBox(width: Dimensions.paddingSizeSmall),

              // Botón de inicio de sesión con Apple
              if (isAppleAvailable)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(335, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    shadowColor: Colors.grey[Get.isDarkMode ? 700 : 300],
                    elevation: 5,
                  ),
                  icon: Image.asset(
                    Images.appleLogo,
                    height: 24,
                    width: 24,
                  ),
                  label: Text(
                    'sign_in_apple'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final credential =
                          await SignInWithApple.getAppleIDCredential(
                        scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName,
                        ],
                        webAuthenticationOptions: WebAuthenticationOptions(
                          clientId: Get.find<SplashController>()
                              .configModel!
                              .appleLogin![0]
                              .clientId!,
                          redirectUri: Uri.parse(
                              'https://sq_entregas-web.sqteam.com/apple'),
                        ),
                      );
                      Get.find<AuthController>().loginWithSocialMedia(
                        SocialLogInBody(
                          email: credential.email,
                          token: credential.authorizationCode,
                          uniqueId: credential.userIdentifier,
                          medium: 'apple',
                        ),
                      );
                    } catch (e) {
                      // Manejo de errores
                    }
                  },
                ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
