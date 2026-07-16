import 'package:sq_delivery_customer/data/model/response/language_model.dart';
import 'package:sq_delivery_customer/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
