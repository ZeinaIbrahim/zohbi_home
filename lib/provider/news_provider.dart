import 'package:zohbi_user/common/models/api_response_model.dart';
import 'package:zohbi_user/common/reposotories/news_letter_repo.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:flutter/material.dart';

class NewsLetterProvider extends ChangeNotifier {
  final NewsLetterRepo? newsLetterRepo;
  NewsLetterProvider({required this.newsLetterRepo});

  Future<void> addToNewsLetter(String email) async {
    ApiResponseModel apiResponse = await newsLetterRepo!.addToNewsLetter(email);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('successfully_subscribe', Get.context!), Get.context!,
          isError: false);
    } else {
      showCustomSnackBar(
          getTranslated('mail_already_exist', Get.context!), Get.context!);
    }
  }
}
