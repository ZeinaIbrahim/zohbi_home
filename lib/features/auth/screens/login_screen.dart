import 'package:country_code_picker/country_code_picker.dart';
import 'package:zohbi_user/common/enums/footer_type_enum.dart';
import 'package:zohbi_user/features/auth/widgets/social_login_widget.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/features/profile/providers/profile_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/features/wishlist/providers/wishlist_provider.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/common/widgets/custom_shadow_widget.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:zohbi_user/common/widgets/custom_text_field_widget.dart';
import 'package:zohbi_user/common/widgets/custom_pop_scope_widget.dart';
import 'package:zohbi_user/common/widgets/footer_web_widget.dart';
import 'package:zohbi_user/common/widgets/web_app_bar_widget.dart';
import 'package:zohbi_user/features/auth/widgets/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController!.text =
        Provider.of<AuthProvider>(context, listen: false).getUserNumber();
    _passwordController!.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .countryCode!)
        .dialCode;

    _emailNumberFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    _emailNumberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    return CustomPopScopeWidget(
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? null
            : Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(
                preferredSize: Size.fromHeight(90), child: WebAppBarWidget())
            : null,
        body: SafeArea(
            child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: Center(
            child: SizedBox(
              height: ResponsiveHelper.isDesktop(context)
                  ? null
                  : MediaQuery.sizeOf(context).height,
              width: Dimensions.webScreenWidth / 1.9,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: CustomShadowWidget(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isDesktop(context)
                              ? 60
                              : Dimensions.paddingSizeExtraLarge,
                          vertical: Dimensions.paddingSizeLarge),
                      margin: const EdgeInsets.symmetric(
                          vertical: Dimensions.fontSizeThirty),
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => Form(
                          key: _formKeyLogin,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 30),
                              Center(
                                child: Image.asset(
                                  Images.logo,
                                  height: ResponsiveHelper.isDesktop(context)
                                      ? 100.0
                                      : 80,
                                  fit: BoxFit.scaleDown,
                                  matchTextDirection: true,
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Center(
                                  child: Text(getTranslated('login', context),
                                      style: rubikMedium.copyWith(
                                        fontSize: Dimensions.fontSizeOverLarge,
                                      ))),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSizeDefault),
                                  border: Border.all(
                                    color: (_emailNumberFocus.hasFocus)
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5)
                                        : Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: configModel.emailVerification!
                                    ? CustomTextFieldWidget(
                                        prefixIconData: Icons.email,
                                        isShowPrefixIcon: true,
                                        hintText: getTranslated(
                                            'demo_gmail', context),
                                        isShowBorder: true,
                                        focusNode: _emailNumberFocus,
                                        nextFocus: _passwordFocus,
                                        controller: _emailController,
                                        inputType: TextInputType.emailAddress,
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                            CodePickerWidget(
                                              onChanged: (countryCode) {
                                                _countryDialCode =
                                                    countryCode.dialCode;
                                              },
                                              initialSelection:
                                                  _countryDialCode,
                                              favorite: [_countryDialCode!],
                                              showDropDownButton: true,
                                              padding: EdgeInsets.zero,
                                              showFlagMain: true,
                                            ),
                                            Container(
                                                width: 1,
                                                height: Dimensions
                                                    .paddingSizeExtraLarge,
                                                color: Theme.of(context)
                                                    .dividerColor),
                                            Expanded(
                                                child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .radiusSizeDefault),
                                              child: CustomTextFieldWidget(
                                                hintText: getTranslated(
                                                    'enter_phone_number',
                                                    context),
                                                focusNode: _emailNumberFocus,
                                                nextFocus: _passwordFocus,
                                                controller: _emailController,
                                                inputType: TextInputType.phone,
                                              ),
                                            )),
                                          ]),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),

                              CustomTextFieldWidget(
                                hintText: getTranslated('6+character', context),
                                isPassword: true,
                                isShowBorder: true,
                                isShowPrefixIcon: true,
                                prefixIconUrl: Images.lockIcon,
                                prefixIconData: Icons.lock,
                                isShowSuffixIcon: true,
                                focusNode: _passwordFocus,
                                controller: _passwordController,
                                inputAction: TextInputAction.done,
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),

                              // for remember me section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Consumer<AuthProvider>(
                                      builder: (context, authProvider, child) =>
                                          InkWell(
                                            onTap: () {
                                              authProvider.toggleRememberMe();
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                      color: authProvider
                                                              .isActiveRememberMe
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .cardColor,
                                                      border: Border.all(
                                                          color: authProvider
                                                                  .isActiveRememberMe
                                                              ? Colors
                                                                  .transparent
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3)),
                                                  child: authProvider
                                                          .isActiveRememberMe
                                                      ? const Icon(Icons.done,
                                                          color: Colors.white,
                                                          size: 17)
                                                      : const SizedBox.shrink(),
                                                ),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall),
                                                Text(
                                                  getTranslated(
                                                      'remember_me', context),
                                                  style: rubikRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall),
                                                )
                                              ],
                                            ),
                                          )),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.getForgetPassRoute());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${getTranslated('forgot_password', context)} ?',
                                        style: rubikRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.loginErrorMessage!.isNotEmpty
                                      ? const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 5)
                                      : const SizedBox.shrink(),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.loginErrorMessage ?? "",
                                      style: rubikMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),

                              // for login button
                              CustomButtonWidget(
                                isLoading: authProvider.isLoading,
                                btnTxt: getTranslated('login', context),
                                onTap: () async {
                                  final ProfileProvider profileProvider =
                                      Provider.of<ProfileProvider>(context,
                                          listen: false);
                                  final WishListProvider wishListProvider =
                                      Provider.of<WishListProvider>(context,
                                          listen: false);

                                  String email = _emailController!.text.trim();
                                  if (!configModel.emailVerification!) {
                                    email = _countryDialCode! +
                                        _emailController!.text.trim();
                                  }

                                  String password =
                                      _passwordController!.text.trim();
                                  if (email.isEmpty) {
                                    if (configModel.emailVerification!) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_email_address', context),
                                          context);
                                    } else {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_phone_number_with_country_code',
                                              context),
                                          context);
                                    }
                                  } else if (password.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'enter_password', context),
                                        context);
                                  } else if (password.length < 6) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'password_should_be', context),
                                        context);
                                  } else {
                                    await authProvider
                                        .login(email, password)
                                        .then((status) async {
                                      if (!status.isSuccess &&
                                          status.message == 'verification') {
                                        Navigator.of(context).pushNamed(
                                            Routes.getVerifyRoute(
                                                'sign-up', email));
                                      } else if (status.isSuccess) {
                                        if (authProvider.isActiveRememberMe) {
                                          authProvider
                                              .saveUserNumberAndPassword(
                                                  _emailController!.text,
                                                  password);
                                        } else {
                                          authProvider
                                              .clearUserNumberAndPassword();
                                        }
                                        profileProvider.getUserInfo();
                                        wishListProvider.getWishList();
                                        await Navigator.pushNamedAndRemoveUntil(
                                            Get.context!,
                                            Routes.getMainRoute(),
                                            (route) => false);
                                      }
                                    });
                                  }
                                },
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),

                              // for create an account

                              if (configModel.socialLoginStatus!.isFacebook! ||
                                  configModel.socialLoginStatus!.isGoogle!)
                                const Center(child: SocialLoginWidget()),

                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),

                              Center(
                                  child: InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, Routes.getCreateAccountRoute()),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: getTranslated(
                                          'do_not_have_an_account', context),
                                      style: rubikRegular.copyWith(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.8),
                                      )),
                                  TextSpan(
                                      text:
                                          ' ${getTranslated('sign_up', context)}',
                                      style: rubikMedium.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        decoration: TextDecoration.underline,
                                      )),
                                ])),
                              )),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),

                              Center(
                                  child: Text(
                                getTranslated('or', context),
                                style: rubikRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              )),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),

                              Center(
                                  child: InkWell(
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, Routes.getDashboardRoute('home')),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          '${getTranslated('continue_as_a', context)} ',
                                      style: rubikRegular.copyWith(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.8),
                                      )),
                                  TextSpan(
                                      text: getTranslated('guest', context),
                                      style: rubikMedium.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        decoration: TextDecoration.underline,
                                      )),
                                ])),
                              )),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ]),
            ),
          )),
          const FooterWebWidget(footerType: FooterType.sliver),
        ])),
      ),
    );
  }
}
