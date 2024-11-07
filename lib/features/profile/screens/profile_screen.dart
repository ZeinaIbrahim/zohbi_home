import 'dart:io';

import 'package:zohbi_user/common/widgets/custom_image_widget.dart';
import 'package:zohbi_user/common/widgets/custom_loader_widget.dart';
import 'package:zohbi_user/features/profile/enums/login_medium_enum.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/features/profile/widgets/profile_web_widget.dart';
import 'package:flutter/material.dart';
import 'package:zohbi_user/common/models/response_model.dart';
import 'package:zohbi_user/common/models/userinfo_model.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/features/profile/providers/profile_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_app_bar_widget.dart';
import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:zohbi_user/common/widgets/custom_text_field_widget.dart';
import 'package:zohbi_user/common/widgets/not_logged_in_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode? _firstNameFocus;
  FocusNode? _lastNameFocus;
  FocusNode? _emailFocus;
  FocusNode? _phoneNumberFocus;
  FocusNode? _passwordFocus;
  FocusNode? _confirmPasswordFocus;

  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  XFile? file;
  XFile? data;
  final picker = ImagePicker();

  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if (_isLoggedIn) {
      profileProvider.getUserInfo();
    }

    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    if (_isLoggedIn) {
      profileProvider.getUserInfo().then((_) {
        UserInfoModel? userInfoModel = profileProvider.userInfoModel;
        if (userInfoModel != null) {
          _firstNameController?.text = userInfoModel.fName ?? '';
          _lastNameController?.text = userInfoModel.lName ?? '';
          _phoneNumberController?.text = userInfoModel.phone ?? '';
          _emailController?.text = userInfoModel.email ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('my_profile', context)),
      body: _isLoggedIn
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                if (ResponsiveHelper.isDesktop(context)) {
                  return ProfileWebWidget(
                    file: data,
                    pickImage: _choose,
                    confirmPasswordController: _confirmPasswordController,
                    confirmPasswordFocus: _confirmPasswordFocus,
                    emailController: _emailController,
                    firstNameController: _firstNameController,
                    firstNameFocus: _firstNameFocus,
                    lastNameController: _lastNameController,
                    lastNameFocus: _lastNameFocus,
                    emailFocus: _emailFocus,
                    passwordController: _passwordController,
                    passwordFocus: _passwordFocus,
                    phoneNumberController: _phoneNumberController,
                    phoneNumberFocus: _phoneNumberFocus,
                    userInfo: profileProvider.userInfoModel,
                  );
                }
                return profileProvider.userInfoModel != null
                    ? Column(children: [
                        Expanded(
                            child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Center(
                              child: SizedBox(
                                  width: Dimensions.webScreenWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // for profile image
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeLarge),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.4),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .dividerColor
                                                  .withOpacity(0.8),
                                              width: 3),
                                          shape: BoxShape.circle,
                                        ),
                                        child: InkWell(
                                          onTap: _choose,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: file != null
                                                    ? ResponsiveHelper
                                                            .isMobilePhone()
                                                        ? Image.file(
                                                            File(file!.path),
                                                            width: 80,
                                                            height: 80,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.network(
                                                            file!.path,
                                                            width: 80,
                                                            height: 80,
                                                            fit: BoxFit.fill,
                                                          )
                                                    : CustomImageWidget(
                                                        placeholder:
                                                            Images.placeholder(
                                                                context),
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.cover,
                                                        image:
                                                            '${splashProvider.baseUrls!.customerImageUrl}/'
                                                            '${profileProvider.userInfoModel?.image}',
                                                      ),
                                              ),
                                              Positioned(
                                                  bottom: 15,
                                                  right: -10,
                                                  child: InkWell(
                                                      onTap: _choose,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Theme.of(
                                                                  context)
                                                              .dividerColor
                                                              .withOpacity(0.8),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Theme.of(
                                                                      context)
                                                                  .dividerColor),
                                                        ),
                                                        child: const Icon(
                                                            Icons.edit,
                                                            size: 13),
                                                      ))),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // for name
                                      Center(
                                          child: Text(
                                        '${profileProvider.userInfoModel!.fName} ${profileProvider.userInfoModel!.lName}',
                                        style: rubikMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge),
                                      )),
                                      const SizedBox(height: 28),

                                      // for first name section
                                      Text(
                                        getTranslated('first_name', context),
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context).hintColor),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),

                                      CustomTextFieldWidget(
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                            fontSize: Dimensions.fontSizeSmall),
                                        hintText: 'John',
                                        isShowBorder: true,
                                        controller: _firstNameController,
                                        focusNode: _firstNameFocus,
                                        nextFocus: _lastNameFocus,
                                        inputType: TextInputType.name,
                                        capitalization:
                                            TextCapitalization.words,
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeLarge),

                                      // for last name section
                                      Text(
                                        getTranslated('last_name', context),
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context).hintColor),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),

                                      CustomTextFieldWidget(
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                            fontSize: Dimensions.fontSizeSmall),
                                        hintText: 'Doe',
                                        isShowBorder: true,
                                        controller: _lastNameController,
                                        focusNode: _lastNameFocus,
                                        nextFocus: splashProvider
                                                .configModel!.emailVerification!
                                            ? _phoneNumberFocus
                                            : _emailFocus,
                                        inputType: TextInputType.name,
                                        capitalization:
                                            TextCapitalization.words,
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeLarge),

                                      // for email section
                                      Row(children: [
                                        Text(
                                          getTranslated('email', context),
                                          style: rubikMedium.copyWith(
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        splashProvider
                                                .configModel!.emailVerification!
                                            ? Text(
                                                '(${getTranslated('non_changeable', context)})',
                                                style: rubikRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Colors.red),
                                              )
                                            : const SizedBox(),
                                      ]),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      CustomTextFieldWidget(
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                            fontSize: Dimensions.fontSizeSmall),
                                        hintText: getTranslated(
                                            'demo_gmail', context),
                                        isShowBorder: true,
                                        controller: _emailController,
                                        isEnabled: !splashProvider
                                            .configModel!.emailVerification!,
                                        focusNode: _emailFocus,
                                        nextFocus: _phoneNumberFocus,
                                        inputType: TextInputType.emailAddress,
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeLarge),

                                      // for phone Number section
                                      Row(children: [
                                        Text(
                                          getTranslated(
                                              'mobile_number', context),
                                          style: rubikMedium.copyWith(
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        !splashProvider.configModel!
                                                    .emailVerification! &&
                                                profileProvider.userInfoModel
                                                        ?.loginMedium ==
                                                    LoginMedium.general.name
                                            ? Text(
                                                '(${getTranslated('non_changeable', context)})',
                                                style: rubikRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Colors.red),
                                              )
                                            : const SizedBox(),
                                      ]),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),

                                      CustomTextFieldWidget(
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                            fontSize: Dimensions.fontSizeSmall),
                                        hintText: getTranslated(
                                            'number_hint', context),
                                        isShowBorder: true,
                                        isEnabled: (splashProvider.configModel
                                                    ?.emailVerification ??
                                                false) ||
                                            profileProvider.userInfoModel
                                                    ?.loginMedium !=
                                                LoginMedium.general.name,
                                        controller: _phoneNumberController,
                                        focusNode: _phoneNumberFocus,
                                        nextFocus: _passwordFocus,
                                        inputType: TextInputType.phone,
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeLarge),

                                      Text(
                                        getTranslated('password', context),
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context).hintColor),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),

                                      CustomTextFieldWidget(
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                            fontSize: Dimensions.fontSizeSmall),
                                        hintText: getTranslated(
                                            'password_hint', context),
                                        isShowBorder: true,
                                        controller: _passwordController,
                                        focusNode: _passwordFocus,
                                        nextFocus: _confirmPasswordFocus,
                                        isPassword: true,
                                        isShowSuffixIcon: true,
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeLarge),

                                      Text(
                                        getTranslated(
                                            'confirm_password', context),
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context).hintColor),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),

                                      CustomTextFieldWidget(
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                            fontSize: Dimensions.fontSizeSmall),
                                        hintText: getTranslated(
                                            'password_hint', context),
                                        isShowBorder: true,
                                        controller: _confirmPasswordController,
                                        focusNode: _confirmPasswordFocus,
                                        isPassword: true,
                                        isShowSuffixIcon: true,
                                        inputAction: TextInputAction.done,
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeLarge),
                                    ],
                                  ))),
                        )),
                        Center(
                            child: Container(
                          width: Dimensions.webScreenWidth,
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: CustomButtonWidget(
                            isLoading: profileProvider.isLoading,
                            btnTxt: getTranslated('update_profile', context),
                            onTap: () async {
                              String firstName =
                                  _firstNameController?.text.trim() ?? '';
                              String lastName =
                                  _lastNameController?.text.trim() ?? '';
                              String phoneNumber =
                                  _phoneNumberController?.text.trim() ?? '';
                              String password =
                                  _passwordController?.text.trim() ?? '';
                              String confirmPassword =
                                  _confirmPasswordController?.text.trim() ?? '';

                              bool didNotChange =
                                  profileProvider.userInfoModel?.fName ==
                                          firstName &&
                                      profileProvider.userInfoModel?.lName ==
                                          lastName &&
                                      profileProvider.userInfoModel?.phone ==
                                          phoneNumber &&
                                      profileProvider.userInfoModel?.email ==
                                          _emailController?.text &&
                                      file == null &&
                                      password.isEmpty &&
                                      confirmPassword.isEmpty;

                              if (didNotChange) {
                                showCustomSnackBar(
                                    getTranslated(
                                        'change_something_to_update', context),
                                    context);
                              } else if (firstName.isEmpty) {
                                showCustomSnackBar(
                                    getTranslated('enter_first_name', context),
                                    context);
                              } else if (lastName.isEmpty) {
                                showCustomSnackBar(
                                    getTranslated('enter_last_name', context),
                                    context);
                              } else if (phoneNumber.isEmpty) {
                                showCustomSnackBar(
                                    getTranslated(
                                        'enter_phone_number', context),
                                    context);
                              } else if ((password.isNotEmpty &&
                                      password.length < 6) ||
                                  (confirmPassword.isNotEmpty &&
                                      confirmPassword.length < 6)) {
                                showCustomSnackBar(
                                    getTranslated(
                                        'password_should_be', context),
                                    context);
                              } else if (password != confirmPassword) {
                                showCustomSnackBar(
                                    getTranslated(
                                        'password_did_not_match', context),
                                    context);
                              } else {
                                UserInfoModel updateUserInfoModel =
                                    UserInfoModel();
                                updateUserInfoModel.fName = firstName;
                                updateUserInfoModel.lName = lastName;
                                updateUserInfoModel.phone = phoneNumber;

                                ResponseModel responseModel =
                                    await profileProvider.updateUserInfo(
                                  updateUserInfoModel,
                                  password,
                                  file,
                                  authProvider.getUserToken(),
                                );

                                if (responseModel.isSuccess) {
                                  profileProvider.getUserInfo();
                                  showCustomSnackBar(
                                      getTranslated(
                                          'updated_successfully', Get.context!),
                                      Get.context!,
                                      isError: false);
                                } else {
                                  showCustomSnackBar(
                                      responseModel.message, Get.context!);
                                }
                              }
                            },
                          ),
                        )),
                      ])
                    : Center(
                        child: CustomLoaderWidget(
                        color: Theme.of(context).primaryColor,
                      ));
              },
            )
          : const NotLoggedInScreen(),
    );
  }

  void _choose() async {
    XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);

    setState(() {
      if (pickedFile != null) {
        if (ResponsiveHelper.isDesktop(context)) {
          data = pickedFile;
        } else {
          file = pickedFile;
        }
      }
    });
  }
}
