import 'dart:async';
import 'package:dio/dio.dart';
import 'package:zohbi_user/features/auth/domain/enums/verification_type_enum.dart';
import 'package:zohbi_user/features/auth/domain/models/social_login_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:zohbi_user/data/datasource/remote/dio/dio_client.dart';
import 'package:zohbi_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:zohbi_user/common/models/api_response_model.dart';
import 'package:zohbi_user/common/models/signup_model.dart';
import 'package:zohbi_user/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});
  String? smsModule;

  Future<ApiResponseModel> registration(SignUpModel signUpModel) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.registerUri,
        data: signUpModel.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> login({String? email, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"email_or_phone": email, "email": email, "password": password},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  //phone login
  Future<ApiResponseModel> loginByPhone(
      {String? phone, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"phone": phone, "password": password},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> updateToken({String? fcmToken}) async {
    try {
      String? deviceToken = '@';

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = (await getDeviceToken())!;
        }
      } else {
        deviceToken = (await getDeviceToken())!;
      }

      if (!kIsWeb) {
        if (fcmToken == null) {
          FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
        } else {
          FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        }
      } else {
        await subscribeTokenToTopic(
            deviceToken, fcmToken ?? AppConstants.topic);
      }

      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: {"_method": "put", "cm_firebase_token": fcmToken ?? deviceToken},
      );

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<void> subscribeTokenToTopic(token, topic) async {
    await dioClient?.post(AppConstants.subscribeToTopic,
        data: {"token": '$token', "topic": topic});
  }

  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    } catch (error) {
      debugPrint('eroor ====> $error');
    }
    if (deviceToken != null) {
      debugPrint('--------Device Token---------- $deviceToken');
    }

    return deviceToken;
  }

  // for forgot password email
  Future<ApiResponseModel> forgetPassword(String? email) async {
    try {
      Response response = await dioClient!.post(AppConstants.forgetPasswordUri,
          data: {"email_or_phone": email, "email": email});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyToken(String? email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyTokenUri,
          data: {
            "email_or_phone": email,
            "email": email,
            "reset_token": token
          });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> resetPassword(String? mail, String? resetToken,
      String password, String confirmPassword) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.resetPasswordUri,
        data: {
          "_method": "put",
          "reset_token": resetToken,
          "password": password,
          "confirm_password": confirmPassword,
          "email_or_phone": mail,
          "email": mail
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify Email
  Future<ApiResponseModel> sendVerificationCode(
      String? emailOrPhone, VerificationType verificationType) async {
    try {
      Response response = await dioClient!.post(
        verificationType == VerificationType.email
            ? AppConstants.checkEmailUri
            : AppConstants.checkPhoneUri,
        data: {
          verificationType == VerificationType.email ? "email" : "phone":
              emailOrPhone
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyVerificationCode(String phoneOrEmail,
      String token, VerificationType verificationType) async {
    try {
      Response response = await dioClient!.post(
        verificationType == VerificationType.phone
            ? AppConstants.verifyPhoneUri
            : AppConstants.verifyEmailUri,
        data: {
          verificationType == VerificationType.phone ? "phone" : "email":
              phoneOrEmail.trim(),
          "token": token
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.updateHeader(getToken: token);

    try {
      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    await updateToken(fcmToken: '@');
    await sharedPreferences!.remove(AppConstants.token);
    await sharedPreferences!.remove(AppConstants.cartList);
    await sharedPreferences!.remove(AppConstants.userAddress);
    await sharedPreferences!.remove(AppConstants.searchAddress);
    dioClient?.updateHeader(getToken: null);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.userPassword, password);
      await sharedPreferences!.setString(AppConstants.userNumber, number);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences!.getString(AppConstants.userNumber) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.userPassword) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences!.remove(AppConstants.userPassword);
    return await sharedPreferences!.remove(AppConstants.userNumber);
  }

  Future<ApiResponseModel> deleteUser() async {
    try {
      Response response = await dioClient!.delete(AppConstants.customerRemove);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> socialLogin(SocialLoginModel socialLogin) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.socialLogin,
        data: socialLogin.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
