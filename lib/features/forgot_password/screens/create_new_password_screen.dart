import 'package:zohbi_user/common/enums/footer_type_enum.dart';
import 'package:zohbi_user/common/widgets/custom_shadow_widget.dart';
import 'package:zohbi_user/common/widgets/footer_web_widget.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/web_app_bar_widget.dart';
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

class CreateNewPasswordScreen extends StatefulWidget {
  final String? resetToken;
  final String? email;
  const CreateNewPasswordScreen(
      {Key? key, required this.resetToken, required this.email})
      : super(key: key);

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(90), child: WebAppBarWidget())
              : CustomAppBarWidget(
                  title: getTranslated('create_new_password', context)))
          as PreferredSizeWidget?,
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Center(
                      child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: CustomShadowWidget(
                  margin: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context) ? 100 : 0,
                      vertical: Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 55),
                      Image.asset(
                        Images.openLock,
                        width: 142,
                        height: 142,
                      ),
                      const SizedBox(height: 40),
                      Center(
                          child: Text(
                        getTranslated('enter_password_to_create', context),
                        textAlign: TextAlign.center,
                        style: rubikMedium.copyWith(
                            color: Theme.of(context).hintColor),
                      )),
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for password section

                            const SizedBox(height: 60),
                            Text(
                              getTranslated('new_password', context),
                              style: rubikMedium.copyWith(
                                  color: Theme.of(context).hintColor),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            CustomTextFieldWidget(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              isPassword: true,
                              focusNode: _passwordFocus,
                              nextFocus: _confirmPasswordFocus,
                              isShowSuffixIcon: true,
                              inputAction: TextInputAction.next,
                              controller: _passwordController,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            // for confirm password section
                            Text(
                              getTranslated('confirm_password', context),
                              style: rubikMedium.copyWith(
                                  color: Theme.of(context).hintColor),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            CustomTextFieldWidget(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              isPassword: true,
                              isShowSuffixIcon: true,
                              focusNode: _confirmPasswordFocus,
                              controller: _confirmPasswordController,
                              inputAction: TextInputAction.done,
                            ),

                            const SizedBox(height: 24),

                            Center(
                                child: SizedBox(
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 300
                                  : null,
                              child: CustomButtonWidget(
                                isLoading: auth.isForgotPasswordLoading,
                                btnTxt: getTranslated('save', context),
                                onTap: () {
                                  if (_passwordController.text.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'enter_password', context),
                                        context);
                                  } else if (_passwordController.text.length <
                                      6) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'password_should_be', context),
                                        context);
                                  } else if (_confirmPasswordController
                                      .text.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'enter_confirm_password', context),
                                        context);
                                  } else if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'password_did_not_match', context),
                                        context);
                                  } else {
                                    String? mail = Provider.of<SplashProvider>(
                                                context,
                                                listen: false)
                                            .configModel!
                                            .phoneVerification!
                                        ? '+${widget.email!.trim()}'
                                        : widget.email;
                                    auth
                                        .resetPassword(
                                            mail,
                                            widget.resetToken,
                                            _passwordController.text,
                                            _confirmPasswordController.text)
                                        .then((value) async {
                                      if (value.isSuccess) {
                                        await auth
                                            .login(widget.email,
                                                _passwordController.text)
                                            .then((value) async {
                                          await Navigator
                                              .pushNamedAndRemoveUntil(
                                                  context,
                                                  Routes.getMainRoute(),
                                                  (route) => false);
                                        });
                                      } else {
                                        showCustomSnackBar(
                                            'Failed to reset password',
                                            context);
                                      }
                                    });
                                  }
                                },
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
              const FooterWebWidget(footerType: FooterType.sliver),
            ],
          );
        },
      ),
    );
  }
}
