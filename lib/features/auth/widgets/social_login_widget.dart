import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zohbi_user/common/models/config_model.dart';
import 'package:zohbi_user/features/auth/domain/models/social_login_model.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:provider/provider.dart';

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel socialLogin = SocialLoginModel();

  void route(
    bool isRoute,
    String? token,
    String errorMessage,
  ) async {
    if (isRoute) {
      if (token != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.getDashboardRoute('home'),
          (route) => false,
        );
      } else {
        showCustomSnackBar(errorMessage, context);
      }
    } else {
      showCustomSnackBar(errorMessage, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SocialStatus? socialStatus =
        Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .socialLoginStatus;
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: ResponsiveHelper.isDesktop(context)
                ? Dimensions.paddingSizeLarge
                : 0),
        child: SizedBox(
            height: ResponsiveHelper.isDesktop(context) ? 45 : null,
            child: ListView(
              scrollDirection: ResponsiveHelper.isDesktop(context)
                  ? Axis.horizontal
                  : Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                if (socialStatus!.isGoogle!)
                  InkWell(
                    onTap: () async {
                      try {
                        GoogleSignInAuthentication auth =
                            await authProvider.googleLogin();
                        GoogleSignInAccount googleAccount =
                            authProvider.googleAccount!;

                        authProvider.socialLogin(
                            SocialLoginModel(
                              email: googleAccount.email,
                              token: auth.accessToken,
                              uniqueId: googleAccount.id,
                              medium: 'google',
                            ),
                            route);
                      } catch (er) {
                        debugPrint('access token error is : $er');
                      }
                    },
                    child: SocialButtonView(
                        icon: Images.google,
                        socialName: getTranslated('google', context)),
                  ),
                if (socialStatus.isGoogle!)
                  SizedBox(
                      height: Dimensions.paddingSizeDefault,
                      width: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeDefault
                          : null),
                if (socialStatus.isFacebook!)
                  InkWell(
                    onTap: () async {
                      LoginResult result = await FacebookAuth.instance.login();

                      if (result.status == LoginStatus.success) {
                        Map userData =
                            await FacebookAuth.instance.getUserData();

                        authProvider.socialLogin(
                          SocialLoginModel(
                            email: userData['email'],
                            token: result.accessToken!.token,
                            uniqueId: result.accessToken!.userId,
                            medium: 'facebook',
                          ),
                          route,
                        );
                      }
                    },
                    child: SocialButtonView(
                        icon: Images.facebookSocial,
                        socialName: getTranslated('facebook', context)),
                  ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ],
            )),
      );
    });
  }
}

class SocialButtonView extends StatelessWidget {
  final String icon;
  final String socialName;
  const SocialButtonView({
    Key? key,
    required this.icon,
    required this.socialName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeSmall,
          horizontal: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getTranslated('continue_with', context),
            style: rubikRegular,
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Image.asset(
            icon,
            height: 30,
            width: 30,
          ),
        ],
      ),
    );
  }
}
