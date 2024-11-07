import 'package:zohbi_user/common/reposotories/language_repo.dart';
import 'package:flutter/material.dart';
import 'package:zohbi_user/common/models/language_model.dart';

class LanguageProvider with ChangeNotifier {
  final LanguageRepo? languageRepo;

  LanguageProvider({this.languageRepo});

  int? _selectIndex = 0;

  int? get selectIndex => _selectIndex;

  void setSelectIndex(int? index) {
    _selectIndex = index;
    notifyListeners();
  }

  List<LanguageModel> _languages = [];

  List<LanguageModel> get languages => _languages;

  void searchLanguage(String query, BuildContext context) {
    if (query.isEmpty) {
      _languages.clear();
      _languages = languageRepo!.getAllLanguages(context: context);
      notifyListeners();
    } else {
      _selectIndex = -1;
      _languages = [];
      languageRepo!.getAllLanguages(context: context).forEach((product) async {
        if (product.languageName!.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(product);
        }
      });
      notifyListeners();
    }
  }

  void initializeAllLanguages(BuildContext context) {
    _languages = [];
    _languages = languageRepo?.getAllLanguages(context: context) ?? [];
  }
}
