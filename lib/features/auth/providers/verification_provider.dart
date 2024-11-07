import 'dart:async';

import 'package:zohbi_user/features/auth/domain/enums/verification_type_enum.dart';
import 'package:zohbi_user/common/models/api_response_model.dart';
import 'package:zohbi_user/common/models/response_model.dart';
import 'package:zohbi_user/features/auth/domain/reposotories/auth_repo.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helper/api_checker_helper.dart';
import '../../../helper/custom_snackbar_helper.dart';

class VerificationProvider with ChangeNotifier {
  final AuthRepo authRepo;

  VerificationProvider({required this.authRepo});

  bool _isLoading = false;
  bool _isEnableVerificationCode = false;
  String? _verificationMsg = '';
  String _verificationCode = '';
  Timer? _timer;
  int? currentTime;

  bool get isLoading => _isLoading;
  String? get verificationMessage => _verificationMsg;
  String get verificationCode => _verificationCode;
  bool get isEnableVerificationCode => _isEnableVerificationCode;

  set setVerificationMessage(String value) => _verificationMsg = value;
  set setVerificationCode(String value) => _verificationCode = value;

  Future<ResponseModel> verifyToken(String? email) async {
    _isLoading = true;
    notifyListeners();

    ApiResponseModel? apiResponse =
        await authRepo.verifyToken(email, _verificationCode);

    ResponseModel responseModel;

    if (apiResponse.response?.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response?.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors?.first.message);
    }

    _isLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> sendVerificationCode(
      {required String? emailOrPhone,
      required VerificationType verificationType}) async {
    ResponseModel responseModel;

    _isLoading = true;
    _verificationMsg = '';
    notifyListeners();

    ApiResponseModel? apiResponse =
        await authRepo.sendVerificationCode(emailOrPhone, verificationType);

    if (apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response?.data['token']);
      startVerifyTimer();
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors?.first.message;
      responseModel = ResponseModel(false, _verificationMsg);
    }

    _isLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> verifyVerificationCode(
      {required String emailOrPhone,
      required VerificationType verificationType}) async {
    _isLoading = true;
    _verificationMsg = '';
    notifyListeners();

    ApiResponseModel? apiResponse = await authRepo.verifyVerificationCode(
        emailOrPhone, _verificationCode, verificationType);

    ResponseModel responseModel;

    if (apiResponse.response?.statusCode == 200) {
      String token = apiResponse.response?.data["token"];

      authRepo.saveUserToken(token);
      await authRepo.updateToken();

      responseModel =
          ResponseModel(true, apiResponse.response?.data["message"]);
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors?.first.message;

      responseModel = ResponseModel(false, _verificationMsg);
      showCustomSnackBar(_verificationMsg, Get.context!);
    }

    _isLoading = false;
    notifyListeners();

    return responseModel;
  }

  void updateVerificationCode(String verificationCode) {
    if (verificationCode.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }

    _verificationCode = verificationCode;

    notifyListeners();
  }

  void startVerifyTimer() {
    _timer?.cancel();
    currentTime = Provider.of<SplashProvider>(Get.context!, listen: false)
            .configModel
            ?.otpResendTime ??
        0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (currentTime! > 0) {
        currentTime = currentTime! - 1;
      } else {
        _timer?.cancel();
      }

      notifyListeners();
    });
  }
}
