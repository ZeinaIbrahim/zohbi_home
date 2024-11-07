import 'package:zohbi_user/common/enums/footer_type_enum.dart';
import 'package:zohbi_user/common/models/response_model.dart';
import 'package:zohbi_user/common/models/userinfo_model.dart';
import 'package:zohbi_user/features/profile/enums/login_medium_enum.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/features/profile/providers/profile_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/utill/color_resources.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:zohbi_user/common/widgets/custom_text_field_widget.dart';
import 'package:zohbi_user/common/widgets/footer_web_widget.dart';
import 'package:zohbi_user/common/widgets/on_hover.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileWebWidget extends StatefulWidget {
  final FocusNode? firstNameFocus;
  final FocusNode? lastNameFocus;
  final FocusNode? emailFocus;
  final FocusNode? phoneNumberFocus;
  final FocusNode? passwordFocus;
  final FocusNode? confirmPasswordFocus;
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneNumberController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final UserInfoModel? userInfo;

  final Function pickImage;
  final XFile? file;
  const ProfileWebWidget(
      {Key? key,
      required this.firstNameFocus,
      required this.lastNameFocus,
      required this.emailFocus,
      required this.phoneNumberFocus,
      required this.passwordFocus,
      required this.confirmPasswordFocus,
      required this.firstNameController,
      required this.lastNameController,
      required this.emailController,
      required this.phoneNumberController,
      required this.passwordController,
      required this.confirmPasswordController,
      //function
      required this.pickImage,
      //file
      required this.file,
      required this.userInfo})
      : super(key: key);

  @override
  State<ProfileWebWidget> createState() => _ProfileWebWidgetState();
}

class _ProfileWebWidgetState extends State<ProfileWebWidget> {
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
            return Center(
              child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 150,
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.centerLeft,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 240.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              profileProvider.userInfoModel != null
                                  ? Text(
                                      '${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel?.lName ?? 'nnn'}',
                                      style: rubikRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraLarge,
                                          color: Colors.white),
                                    )
                                  : const SizedBox(
                                      height: Dimensions.paddingSizeDefault,
                                      width: 150),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              profileProvider.userInfoModel != null
                                  ? Text(
                                      profileProvider.userInfoModel?.email ??
                                          '666',
                                      style: rubikRegular.copyWith(
                                          color: Colors.white),
                                    )
                                  : const SizedBox(height: 15, width: 100),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 240.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated('first_name', context),
                                          style: rubikMedium.copyWith(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        SizedBox(
                                          width: 430,
                                          child: CustomTextFieldWidget(
                                            hintText: 'John',
                                            isShowBorder: true,
                                            controller:
                                                widget.firstNameController,
                                            focusNode: widget.firstNameFocus,
                                            nextFocus: widget.lastNameFocus,
                                            inputType: TextInputType.name,
                                            capitalization:
                                                TextCapitalization.words,
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),

                                        // for email section
                                        Text(
                                          getTranslated('email', context),
                                          style: rubikMedium.copyWith(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        SizedBox(
                                          width: 430,
                                          child: CustomTextFieldWidget(
                                            hintText: getTranslated(
                                                'demo_gmail', context),
                                            isShowBorder: true,
                                            controller: widget.emailController,
                                            isEnabled: false,
                                            focusNode: widget.emailFocus,
                                            nextFocus: widget.phoneNumberFocus,
                                            inputType:
                                                TextInputType.emailAddress,
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),

                                        Text(
                                          getTranslated('password', context),
                                          style: rubikMedium.copyWith(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        SizedBox(
                                          width: 430,
                                          child: CustomTextFieldWidget(
                                            hintText: getTranslated(
                                                'password_hint', context),
                                            isShowBorder: true,
                                            controller:
                                                widget.passwordController,
                                            focusNode: widget.passwordFocus,
                                            nextFocus:
                                                widget.confirmPasswordFocus,
                                            isPassword: true,
                                            isShowSuffixIcon: true,
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated('last_name', context),
                                          style: rubikMedium.copyWith(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        SizedBox(
                                          width: 430,
                                          child: CustomTextFieldWidget(
                                            hintText: 'Doe',
                                            isShowBorder: true,
                                            controller:
                                                widget.lastNameController,
                                            focusNode: widget.lastNameFocus,
                                            nextFocus: widget.phoneNumberFocus,
                                            inputType: TextInputType.name,
                                            capitalization:
                                                TextCapitalization.words,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),

                                        // for phone Number section
                                        Row(
                                          children: [
                                            Text(
                                              getTranslated(
                                                  'mobile_number', context),
                                              style: rubikMedium.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      Dimensions.fontSizeSmall),
                                            ),
                                            !(splashProvider.configModel
                                                            ?.emailVerification ??
                                                        true) &&
                                                    profileProvider
                                                            .userInfoModel
                                                            ?.loginMedium ==
                                                        LoginMedium.general.name
                                                ? Text(
                                                    ' (${getTranslated('non_changeable', context)}) ',
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                        color: Colors.red),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),

                                        SizedBox(
                                          width: 430,
                                          child: CustomTextFieldWidget(
                                            hintText: getTranslated(
                                                'number_hint', context),
                                            isShowBorder: true,
                                            isEnabled: (splashProvider
                                                        .configModel
                                                        ?.emailVerification ??
                                                    false) ||
                                                profileProvider.userInfoModel
                                                        ?.loginMedium !=
                                                    LoginMedium.general.name,
                                            controller:
                                                widget.phoneNumberController,
                                            focusNode: widget.phoneNumberFocus,
                                            nextFocus: widget.passwordFocus,
                                            inputType: TextInputType.phone,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),

                                        Text(
                                          getTranslated(
                                              'confirm_password', context),
                                          style: rubikMedium.copyWith(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        SizedBox(
                                          width: 430,
                                          child: CustomTextFieldWidget(
                                            hintText: getTranslated(
                                                'password_hint', context),
                                            isShowBorder: true,
                                            controller: widget
                                                .confirmPasswordController,
                                            focusNode:
                                                widget.confirmPasswordFocus,
                                            isPassword: true,
                                            isShowSuffixIcon: true,
                                            inputAction: TextInputAction.done,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),
                                      ],
                                    ),
                                    const SizedBox(height: 55.0)
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: SizedBox(
                                        width: 180.0,
                                        child: CustomButtonWidget(
                                          isLoading: profileProvider.isLoading,
                                          btnTxt: getTranslated(
                                              'update_profile', context),
                                          onTap: () async {
                                            String firstName = widget
                                                    .firstNameController?.text
                                                    .trim() ??
                                                '';
                                            String lastName = widget
                                                    .lastNameController?.text
                                                    .trim() ??
                                                '';
                                            String email = widget
                                                    .emailController?.text
                                                    .trim() ??
                                                '';
                                            String phoneNumber = widget
                                                    .phoneNumberController?.text
                                                    .trim() ??
                                                '';
                                            String password = widget
                                                    .passwordController?.text
                                                    .trim() ??
                                                '';
                                            String confirmPassword = widget
                                                    .confirmPasswordController
                                                    ?.text
                                                    .trim() ??
                                                '';

                                            if (profileProvider
                                                        .userInfoModel?.fName ==
                                                    firstName &&
                                                profileProvider
                                                        .userInfoModel?.lName ==
                                                    lastName &&
                                                profileProvider
                                                        .userInfoModel?.phone ==
                                                    phoneNumber &&
                                                profileProvider
                                                        .userInfoModel?.email ==
                                                    widget.emailController
                                                        ?.text &&
                                                widget.file == null &&
                                                password.isEmpty &&
                                                confirmPassword.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'change_something_to_update',
                                                      context),
                                                  context);
                                            } else if (firstName.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_first_name',
                                                      context),
                                                  context);
                                            } else if (lastName.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_last_name',
                                                      context),
                                                  context);
                                            } else if (phoneNumber.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_phone_number',
                                                      context),
                                                  context);
                                            } else if ((password.isNotEmpty &&
                                                    password.length < 6) ||
                                                (confirmPassword.isNotEmpty &&
                                                    confirmPassword.length <
                                                        6)) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'password_should_be',
                                                      context),
                                                  context);
                                            } else if (password !=
                                                confirmPassword) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'password_did_not_match',
                                                      context),
                                                  context);
                                            } else {
                                              UserInfoModel
                                                  updateUserInfoModel =
                                                  UserInfoModel();
                                              updateUserInfoModel.fName =
                                                  firstName;
                                              updateUserInfoModel.lName =
                                                  lastName;
                                              updateUserInfoModel.email = email;
                                              updateUserInfoModel.phone =
                                                  phoneNumber;
                                              updateUserInfoModel.loginMedium =
                                                  widget.userInfo?.loginMedium;
                                              updateUserInfoModel.image =
                                                  widget.userInfo?.image;

                                              String pass = password;

                                              ResponseModel responseModel =
                                                  await profileProvider
                                                      .updateUserInfo(
                                                updateUserInfoModel,
                                                pass,
                                                widget.file,
                                                Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false)
                                                    .getUserToken(),
                                              );

                                              if (responseModel.isSuccess) {
                                                profileProvider.getUserInfo();
                                                widget.passwordController!
                                                    .text = '';
                                                widget
                                                    .confirmPasswordController!
                                                    .text = '';
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'updated_successfully',
                                                        Get.context!),
                                                    Get.context!,
                                                    isError: false);
                                              } else {
                                                showCustomSnackBar(
                                                    responseModel.message,
                                                    Get.context!);
                                              }
                                              setState(() {});
                                            }
                                          },
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 30,
                      top: 45,
                      child: Stack(
                        children: [
                          Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                color: ColorResources.getGreyColor(context),
                                image: DecorationImage(
                                    image:
                                        AssetImage(Images.placeholder(context)),
                                    fit: BoxFit.cover),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 22,
                                      offset: const Offset(0, 8.8))
                                ]),
                            child: ClipOval(
                              child: widget.file == null
                                  ? profileProvider.userInfoModel == null
                                      ? Image.asset(Images.placeholder(context),
                                          height: 170.0,
                                          width: 170.0,
                                          fit: BoxFit.cover)
                                      : FadeInImage.assetNetwork(
                                          placeholder:
                                              Images.placeholder(context),
                                          height: 170,
                                          width: 170,
                                          fit: BoxFit.cover,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
                                              '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                                  Images.placeholder(context),
                                                  height: 170,
                                                  width: 170,
                                                  fit: BoxFit.cover),
                                        )
                                  : Image.network(widget.file!.path,
                                      height: 170.0,
                                      width: 170.0,
                                      fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              right: 10,
                              child: OnHover(
                                  child: InkWell(
                                      hoverColor: Colors.transparent,
                                      onTap:
                                          widget.pickImage as void Function()?,
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.camera_alt,
                                              color: Colors.white60)))))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 55),
          const FooterWebWidget(footerType: FooterType.nonSliver),
        ],
      ),
    );
  }
}
