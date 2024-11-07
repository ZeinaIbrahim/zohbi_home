import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/features/onboarding/providers/onboarding_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/provider/language_provider.dart';
import 'package:zohbi_user/provider/localization_provider.dart';
import 'package:zohbi_user/utill/app_constants.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelectButtonWidget extends StatelessWidget {
  final bool fromMenu;

  const LanguageSelectButtonWidget({Key? key, required this.fromMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnBoardingProvider onBoardingProvider =
        Provider.of<OnBoardingProvider>(context, listen: false);
    final LocalizationProvider localizationProvider =
        Provider.of<LocalizationProvider>(context, listen: false);

    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) => Center(
              child: Container(
                width: Dimensions.webScreenWidth,
                padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeLarge,
                    right: Dimensions.paddingSizeLarge,
                    bottom: Dimensions.paddingSizeLarge),
                child: CustomButtonWidget(
                  btnTxt: getTranslated('save', context),
                  onTap: () {
                    Provider.of<SplashProvider>(context, listen: false)
                        .disableLang();
                    if (languageProvider.languages.isNotEmpty &&
                        languageProvider.selectIndex != -1) {
                      localizationProvider.setLanguage(Locale(
                        AppConstants.languages[languageProvider.selectIndex!]
                            .languageCode!,
                        AppConstants.languages[languageProvider.selectIndex!]
                            .countryCode,
                      ));
                      if (fromMenu) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          ResponsiveHelper.isMobile(context) &&
                                  !onBoardingProvider.showOnBoardingStatus
                              ? Routes.getOnBoardingRoute()
                              : Routes.getMainRoute(),
                        );
                      }
                    } else {
                      showCustomSnackBar(
                          getTranslated('select_a_language', context), context);
                    }
                  },
                ),
              ),
            ));
  }
}
