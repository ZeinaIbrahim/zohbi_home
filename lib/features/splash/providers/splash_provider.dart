import 'package:zohbi_user/common/models/api_response_model.dart';
import 'package:zohbi_user/common/models/config_model.dart';
import 'package:zohbi_user/features/splash/domain/models/policy_model.dart';
import 'package:zohbi_user/features/splash/domain/reposotories/splash_repo.dart';
import 'package:zohbi_user/helper/api_checker_helper.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/utill/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  final SharedPreferences? sharedPreferences;
  SplashProvider({required this.splashRepo, this.sharedPreferences});

  ConfigModel? _configModel;
  PolicyModel? _policyModel;

  BaseUrls? _baseUrls;
  final DateTime _currentTime = DateTime.now();

  ConfigModel? get configModel => _configModel;
  PolicyModel? get policyModel => _policyModel;

  BaseUrls? get baseUrls => _baseUrls;
  DateTime get currentTime => _currentTime;

  bool _cookiesShow = true;
  bool get cookiesShow => _cookiesShow;

  Future<bool> initConfig() async {
    ApiResponseModel apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      isSuccess = true;

      if (!kIsWeb &&
          !Provider.of<AuthProvider>(Get.context!, listen: false)
              .isLoggedIn()) {
        await Provider.of<AuthProvider>(Get.context!, listen: false)
            .updateToken();
      }
      notifyListeners();
    } else {
      isSuccess = false;
      ApiCheckerHelper.checkApi(apiResponse);
    }
    return isSuccess;
  }

  Future<void> getPolicyPage({bool reload = false}) async {
    if (_policyModel == null || reload) {
      ApiResponseModel apiResponse = await splashRepo!.getPolicyPage();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _policyModel = PolicyModel.fromJson(apiResponse.response!.data);

        notifyListeners();
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }
  }

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  bool showLang() {
    return splashRepo!.showLang();
  }

  void disableLang() {
    splashRepo!.disableLang();
  }

  void cookiesStatusChange(String? data) {
    if (data != null) {
      splashRepo!.sharedPreferences!
          .setString(AppConstants.cookingManagement, data);
    }
    _cookiesShow = false;
    notifyListeners();
  }

  bool getAcceptCookiesStatus(String? data) =>
      splashRepo!.sharedPreferences!
              .getString(AppConstants.cookingManagement) !=
          null &&
      splashRepo!.sharedPreferences!
              .getString(AppConstants.cookingManagement) ==
          data;
}
