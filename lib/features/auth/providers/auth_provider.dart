// ignore_for_file: empty_catches

import 'dart:async';

import 'package:zohbi_user/features/auth/domain/enums/verification_type_enum.dart';
import 'package:zohbi_user/features/auth/domain/models/social_login_model.dart';
import 'package:zohbi_user/common/models/api_response_model.dart';
import 'package:zohbi_user/common/models/error_response_model.dart';
import 'package:zohbi_user/common/models/response_model.dart';
import 'package:zohbi_user/common/models/userinfo_model.dart';
import 'package:zohbi_user/features/auth/domain/reposotories/auth_repo.dart';
import 'package:zohbi_user/features/auth/providers/verification_provider.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/features/cart/providers/cart_provider.dart';
import 'package:zohbi_user/features/profile/providers/profile_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../helper/api_checker_helper.dart';
import '../../../localization/language_constrants.dart';
import '../../../helper/custom_snackbar_helper.dart';
import '../screens/login_screen.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  AuthProvider({required this.authRepo});

  // for registration section
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool resendButtonLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  bool _isAgreeTerms = false;
  bool get isAgreeTerms => _isAgreeTerms;

  // for login section
  String? _loginErrorMessage = '';

  String? get loginErrorMessage => _loginErrorMessage;

  Future<ResponseModel> login(String? email, String? password) async {
    final VerificationProvider verificationProvider =
        Provider.of<VerificationProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(Get.context!, listen: false);

    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.login(email: email, password: password);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      ResponseModel? verificationResponse;
      String? token;
      String? tempToken;
      Map map = apiResponse.response?.data;

      if (map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      } else if (map.containsKey('token')) {
        token = map["token"];
      }
      if (token != null) {
        await updateAuthToken(token);
      } else if (tempToken != null) {
        verificationResponse = await verificationProvider.sendVerificationCode(
          emailOrPhone: email,
          verificationType:
              (splashProvider.configModel?.phoneVerification ?? false)
                  ? VerificationType.phone
                  : VerificationType.email,
        );

        if (!verificationResponse.isSuccess) {
          _loginErrorMessage = verificationResponse.message;
        }
      }

      responseModel = ResponseModel(token != null,
          (verificationResponse?.isSuccess ?? false) ? 'verification' : null);
    } else {
      _loginErrorMessage =
          ErrorResponseModel.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> updateToken() async {
    if (await authRepo!.getDeviceToken() != '@') {
      await authRepo!.updateToken();
    }
  }

  // for forgot password
  bool _isForgotPasswordLoading = false;

  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  Future<ResponseModel> forgetPassword(String email) async {
    _isForgotPasswordLoading = true;
    resendButtonLoading = true;
    notifyListeners();

    ApiResponseModel apiResponse = await authRepo!.forgetPassword(email);
    ResponseModel responseModel;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors?.first.message);
    }
    resendButtonLoading = false;
    _isForgotPasswordLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> resetPassword(String? mail, String? resetToken,
      String password, String confirmPassword) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!
        .resetPassword(mail, resetToken, password, confirmPassword);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
    }
    return responseModel;
  }

  // for phone verification

  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  //email

  Future<void> updateAuthToken(String token) async {
    authRepo?.saveUserToken(token);
    await authRepo?.updateToken();
  }

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() => authRepo!.isLoggedIn();

  Future<bool> clearSharedData() async {
    final WishListProvider wishListProvider =
        Provider.of<WishListProvider>(Get.context!, listen: false);
    final CartProvider cartProvider =
        Provider.of<CartProvider>(Get.context!, listen: false);

    _isLoading = true;
    notifyListeners();
    bool isSuccess = await authRepo!.clearSharedData();

    await socialLogout();
    wishListProvider.clearWishList();
    cartProvider.getCartData(isUpdate: true);

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo!.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo!.getUserNumber();
  }

  String getUserPassword() {
    return authRepo!.getUserPassword();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo!.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }

  Future deleteUser() async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel response = await authRepo!.deleteUser();
    _isLoading = false;
    if (response.response!.statusCode == 200) {
      Provider.of<SplashProvider>(Get.context!, listen: false)
          .removeSharedData();
      showCustomSnackBar(
          getTranslated('your_account_remove_successfully', Get.context!),
          Get.context!);
      Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    } else {
      Navigator.of(Get.context!).pop();
      ApiCheckerHelper.checkApi(response);
    }
  }

  Future<GoogleSignInAuthentication> googleLogin() async {
    GoogleSignInAuthentication auth;
    googleAccount = await _googleSignIn.signIn();
    auth = await googleAccount!.authentication;
    return auth;
  }

  Future socialLogin(SocialLoginModel socialLogin, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.socialLogin(socialLogin);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = '';
      String? token = '';
      try {
        message = map['error_message'] ?? '';
      } catch (e) {
        debugPrint('error ===> $e');
      }
      try {
        token = map['token'];
      } catch (e) {
        token = null;
      }

      if (token != null) {
        authRepo!.saveUserToken(token);
        await authRepo!.updateToken();
      }

      callback(true, token, message);
      notifyListeners();
    } else {
      String? errorMessage =
          ErrorResponseModel.fromJson(apiResponse.error).errors![0].message;
      callback(false, '', errorMessage);
      notifyListeners();
    }
  }

  Future<void> socialLogout() async {
    final UserInfoModel user =
        Provider.of<ProfileProvider>(Get.context!, listen: false)
            .userInfoModel!;
    if (user.loginMedium!.toLowerCase() == 'google') {
      try {
        await _googleSignIn.disconnect();
      } catch (e) {}
    } else if (user.loginMedium!.toLowerCase() == 'facebook') {
      await FacebookAuth.instance.logOut();
    }
  }

  bool updateIsUpdateTernsStatus({bool isUpdate = true, bool? value}) {
    if (value != null) {
      _isAgreeTerms = value;
    } else {
      _isAgreeTerms = !_isAgreeTerms;
    }
    if (isUpdate) {
      notifyListeners();
    }

    return _isAgreeTerms;
  }
}
