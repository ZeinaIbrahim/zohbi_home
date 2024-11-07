import 'package:zohbi_user/common/enums/footer_type_enum.dart';
import 'package:zohbi_user/common/models/config_model.dart';
import 'package:zohbi_user/common/enums/app_mode.dart';
import 'package:zohbi_user/common/widgets/footer_web_widget.dart';
import 'package:zohbi_user/features/auth/domain/enums/verification_type_enum.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/features/auth/providers/verification_provider.dart';
import 'package:zohbi_user/helper/email_checker_helper.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/utill/app_constants.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_directionality_widget.dart';
import 'package:flutter/material.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/utill/color_resources.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/common/widgets/custom_app_bar_widget.dart';
import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  final String emailAddress;
  final bool fromSignUp;
  const VerificationScreen(
      {Key? key, required this.emailAddress, this.fromSignUp = false})
      : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    final VerificationProvider verificationProvider =
        Provider.of<VerificationProvider>(context, listen: false);
    verificationProvider.startVerifyTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final isPhone = EmailCheckerHelper.isNotValid(widget.emailAddress);

    final ConfigModel config =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBarWidget(
          title: getTranslated(
              isPhone ? 'verify_phone' : 'verify_email', context)),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Center(
              child: SizedBox(
                  width: Dimensions.webScreenWidth,
                  child: Consumer<VerificationProvider>(
                    builder: (context, verificationProvider, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 55),
                        config.emailVerification!
                            ? Image.asset(
                                Images.emailWithBackground,
                                width: 142,
                                height: 142,
                              )
                            : Icon(Icons.phone_android_outlined,
                                size: 50,
                                color: Theme.of(context).primaryColor),
                        const SizedBox(height: 40),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Center(
                                child: Text(
                              '${getTranslated('please_enter_4_digit_code', context)}\n ${widget.emailAddress}',
                              textAlign: TextAlign.center,
                              style: rubikMedium.copyWith(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.6)),
                            ))),
                        if (AppMode.demo == AppConstants.appMode)
                          Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            child: Text(
                              getTranslated('for_demo_purpose_use', context),
                              style: rubikMedium.copyWith(
                                  color: Theme.of(context).disabledColor),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width > 850 ? 300 : 39, vertical: 35),
                          child: PinCodeTextField(
                            length: 4,
                            appContext: context,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              fieldHeight: 63,
                              fieldWidth: 55,
                              borderWidth: 1,
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4),
                              selectedFillColor: Colors.white,
                              inactiveFillColor:
                                  ColorResources.getSearchBg(context),
                              inactiveColor:
                                  Theme.of(context).secondaryHeaderColor,
                              activeColor: Theme.of(context).primaryColor,
                              activeFillColor:
                                  ColorResources.getSearchBg(context),
                            ),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            onChanged:
                                verificationProvider.updateVerificationCode,
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                getTranslated(
                                    'did_not_receive_the_code', context),
                                style: rubikMedium.copyWith(
                                  color: rubikMedium.color?.withOpacity(.6),
                                )),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            verificationProvider.isLoading
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    onPressed: verificationProvider
                                                .currentTime! >
                                            0
                                        ? null
                                        : () async {
                                            if (widget.fromSignUp) {
                                              await verificationProvider
                                                  .sendVerificationCode(
                                                emailOrPhone:
                                                    widget.emailAddress,
                                                verificationType: config
                                                        .phoneVerification!
                                                    ? VerificationType.phone
                                                    : VerificationType.email,
                                              );
                                            } else {
                                              await authProvider
                                                  .forgetPassword(
                                                      widget.emailAddress)
                                                  .then((value) {
                                                verificationProvider
                                                    .startVerifyTimer();

                                                if (value.isSuccess) {
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                          'resend_code_successful',
                                                          context),
                                                      context,
                                                      isError: false);
                                                } else {
                                                  showCustomSnackBar(
                                                      value.message!, context);
                                                }
                                              });
                                            }
                                          },
                                    child: Builder(builder: (context) {
                                      int? days, hours, minutes, seconds;

                                      Duration duration = Duration(
                                          seconds: verificationProvider
                                                  .currentTime ??
                                              0);
                                      days = duration.inDays;
                                      hours = duration.inHours - days * 24;
                                      minutes = duration.inMinutes -
                                          (24 * days * 60) -
                                          (hours * 60);
                                      seconds = duration.inSeconds -
                                          (24 * days * 60 * 60) -
                                          (hours * 60 * 60) -
                                          (minutes * 60);

                                      return CustomDirectionalityWidget(
                                        child: Text(
                                            (verificationProvider.currentTime !=
                                                        null &&
                                                    verificationProvider
                                                            .currentTime! >
                                                        0)
                                                ? '${getTranslated('resend', context)} (${minutes > 0 ? '${minutes}m :' : ''}${seconds}s)'
                                                : getTranslated(
                                                    'resend_it', context),
                                            textAlign: TextAlign.end,
                                            style: rubikMedium.copyWith(
                                              color: verificationProvider
                                                              .currentTime !=
                                                          null &&
                                                      verificationProvider
                                                              .currentTime! >
                                                          0
                                                  ? Theme.of(context)
                                                      .disabledColor
                                                  : Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(.6),
                                            )),
                                      );
                                    })),
                          ],
                        ),
                        const SizedBox(height: 48),
                        verificationProvider.isEnableVerificationCode &&
                                !verificationProvider.isLoading
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                                child: SizedBox(
                                  width: ResponsiveHelper.isMobile(context)
                                      ? Dimensions.webScreenWidth
                                      : 300,
                                  child: CustomButtonWidget(
                                    isLoading: verificationProvider.isLoading,
                                    btnTxt: getTranslated('verify', context),
                                    onTap: () {
                                      if (widget.fromSignUp) {
                                        verificationProvider
                                            .verifyVerificationCode(
                                          emailOrPhone:
                                              widget.emailAddress.trim(),
                                          verificationType:
                                              (config.phoneVerification ??
                                                      false)
                                                  ? VerificationType.phone
                                                  : VerificationType.email,
                                        )
                                            .then((value) async {
                                          if (value.isSuccess) {
                                            await Navigator
                                                .pushNamedAndRemoveUntil(
                                                    context,
                                                    Routes.getMainRoute(),
                                                    (route) => false);
                                          }
                                        });
                                      } else {
                                        verificationProvider
                                            .verifyToken(widget.emailAddress)
                                            .then((value) {
                                          if (value.isSuccess) {
                                            Navigator.pushNamed(
                                                context,
                                                Routes.getNewPassRoute(
                                                    widget.emailAddress,
                                                    verificationProvider
                                                        .verificationCode));
                                          } else {
                                            showCustomSnackBar(
                                                value.message, context);
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ],
                    ),
                  ))),
        ),
        const FooterWebWidget(footerType: FooterType.sliver),
      ]),
    );
  }
}
