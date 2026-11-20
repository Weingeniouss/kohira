// ignore_for_file: avoid_print

import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/category/category.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class CategroryModal {
  final url = AppUrl.category;

  Future<Category?> categroryservice() async {
    print("Sending request to: $url");
    try {
      final responce = await ApiCall.postRequest(url, useAuth: false);

      if (responce != null) {
        final categrory = categoryFromJson(jsonEncode(responce));
        print('categrory data :- $categrory');
        return categrory;
      } else {
        throw {'categrory Data Error : - ${200}, $responce'};
      }
    } catch (e) {
      print('categrory Data Error :- $e');
    }
    return null;
  }
}
