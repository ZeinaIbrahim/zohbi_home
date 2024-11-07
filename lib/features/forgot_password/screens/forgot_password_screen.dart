import 'package:country_code_picker/country_code_picker.dart';
import 'package:zohbi_user/common/enums/footer_type_enum.dart';
import 'package:zohbi_user/features/auth/providers/verification_provider.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/footer_web_widget.dart';
import 'package:zohbi_user/features/auth/widgets/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/common/widgets/custom_app_bar_widget.dart';
import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:zohbi_user/common/widgets/custom_text_field_widget.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    VerificationProvider verificationProvider =
        Provider.of<VerificationProvider>(context, listen: false);
    SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();

    verificationProvider.setVerificationCode = '';
    verificationProvider.setVerificationMessage = '';

    _countryDialCode =
        CountryCode.fromCountryCode(splashProvider.configModel!.countryCode!)
            .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:
          CustomAppBarWidget(title: getTranslated('forgot_password', context)),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Center(
              child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: ResponsiveHelper.isDesktop(context)
                            ? size.height - 400
                            : size.height),
                    child: Container(
                        width: width > 700 ? 700 : width,
                        margin: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.isDesktop(context)
                                ? Dimensions.paddingSizeLarge
                                : 0),
                        padding: width > 700
                            ? const EdgeInsets.all(
                                Dimensions.paddingSizeDefault)
                            : null,
                        decoration: width > 700
                            ? BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ],
                              )
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 55),
                            Image.asset(
                              Images.closeLock,
                              width: 142,
                              height: 142,
                            ),
                            const SizedBox(height: 40),
                            Provider.of<SplashProvider>(context, listen: false)
                                    .configModel!
                                    .phoneVerification!
                                ? Center(
                                    child: Text(
                                    getTranslated(
                                        'please_enter_your_mobile_number_to',
                                        context),
                                    textAlign: TextAlign.center,
                                    style: rubikMedium.copyWith(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.5)),
                                  ))
                                : Center(
                                    child: Text(
                                    getTranslated(
                                        'please_enter_your_number_to', context),
                                    textAlign: TextAlign.center,
                                    style: rubikMedium.copyWith(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.5)),
                                  )),
                            Provider.of<SplashProvider>(context, listen: false)
                                    .configModel!
                                    .phoneVerification!
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeLarge),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 80),
                                        Text(
                                          getTranslated(
                                              'mobile_number', context),
                                          style: rubikMedium.copyWith(
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.5)),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        Row(children: [
                                          CodePickerWidget(
                                            onChanged:
                                                (CountryCode countryCode) {
                                              _countryDialCode =
                                                  countryCode.dialCode;
                                            },
                                            initialSelection: _countryDialCode,
                                            favorite: [_countryDialCode!],
                                            showDropDownButton: true,
                                            padding: EdgeInsets.zero,
                                            textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge!
                                                    .color),
                                            showFlagMain: true,
                                          ),
                                          Expanded(
                                            child: CustomTextFieldWidget(
                                              hintText: getTranslated(
                                                  'number_hint', context),
                                              isShowBorder: true,
                                              controller:
                                                  _phoneNumberController,
                                              inputType: TextInputType.phone,
                                              inputAction: TextInputAction.done,
                                            ),
                                          ),
                                        ]),
                                        const SizedBox(height: 24),
                                        !authProvider.isForgotPasswordLoading
                                            ? CustomButtonWidget(
                                                btnTxt: getTranslated(
                                                    'send', context),
                                                onTap: () {
                                                  if (_phoneNumberController!
                                                      .text.isEmpty) {
                                                    showCustomSnackBar(
                                                        getTranslated(
                                                            'enter_phone_number',
                                                            context),
                                                        context);
                                                  } else {
                                                    Provider.of<AuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .forgetPassword(
                                                            _countryDialCode! +
                                                                _phoneNumberController!
                                                                    .text)
                                                        .then((value) {
                                                      if (value.isSuccess) {
                                                        Navigator.pushNamed(
                                                            context,
                                                            Routes.getVerifyRoute(
                                                                'forget-password',
                                                                _countryDialCode! +
                                                                    _phoneNumberController!
                                                                        .text));
                                                      } else {
                                                        showCustomSnackBar(
                                                            value.message,
                                                            context);
                                                      }
                                                    });
                                                  }
                                                },
                                              )
                                            : Center(
                                                child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(Theme.of(
                                                                context)
                                                            .primaryColor))),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeLarge),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 80),
                                        Text(
                                          getTranslated('email', context),
                                          style: rubikMedium.copyWith(
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.5)),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        CustomTextFieldWidget(
                                          hintText: getTranslated(
                                              'demo_gmail', context),
                                          isShowBorder: true,
                                          controller: _emailController,
                                          inputType: TextInputType.emailAddress,
                                          inputAction: TextInputAction.done,
                                        ),
                                        const SizedBox(height: 24),
                                        CustomButtonWidget(
                                          isLoading: authProvider
                                              .isForgotPasswordLoading,
                                          btnTxt:
                                              getTranslated('send', context),
                                          onTap: () {
                                            if (Provider.of<SplashProvider>(
                                                    context,
                                                    listen: false)
                                                .configModel!
                                                .phoneVerification!) {
                                              if (_phoneNumberController!
                                                  .text.isEmpty) {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'enter_phone_number',
                                                        context),
                                                    context);
                                              } else {
                                                Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false)
                                                    .forgetPassword(
                                                        _countryDialCode! +
                                                            _phoneNumberController!
                                                                .text
                                                                .trim())
                                                    .then((value) {
                                                  if (value.isSuccess) {
                                                    Navigator.pushNamed(
                                                        context,
                                                        Routes.getVerifyRoute(
                                                            'forget-password',
                                                            _countryDialCode! +
                                                                _phoneNumberController!
                                                                    .text
                                                                    .trim()));
                                                  } else {
                                                    showCustomSnackBar(
                                                        value.message, context);
                                                  }
                                                });
                                              }
                                            } else {
                                              if (_emailController!
                                                  .text.isEmpty) {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'enter_email_address',
                                                        context),
                                                    context);
                                              } else if (!_emailController!.text
                                                  .contains('@')) {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'enter_valid_email',
                                                        context),
                                                    context);
                                              } else {
                                                Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false)
                                                    .forgetPassword(
                                                        _emailController!.text)
                                                    .then((value) {
                                                  if (value.isSuccess) {
                                                    Navigator.pushNamed(
                                                        context,
                                                        Routes.getVerifyRoute(
                                                            'forget-password',
                                                            _emailController!
                                                                .text));
                                                  } else {
                                                    showCustomSnackBar(
                                                        value.message, context);
                                                  }
                                                });
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        )),
                  ),
                ),
                const FooterWebWidget(footerType: FooterType.nonSliver),
              ],
            ),
          ));
        },
      ),
    );
  }
}
