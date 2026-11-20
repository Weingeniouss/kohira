// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:kohira/view/utils/app_url.dart';

import '../../../../modal/menu/home/categories.dart';
import 'package:kohira/api/api_call.dart';
import 'dart:convert';

class CategoriesModal {
  final url = AppUrl.categories;

  Future<Categories?> categories_Service() async {
    print("Sending request to: $url");
    try {
      final responce = await ApiCall.getRequest(url, useAuth: false);

      if (responce != null) {
        final categories = categoriesFromJson(jsonEncode(responce));
        print('categories Data :- $categories');
        return categories;
      } else {
        throw {'categories Data Error : - ${200}, $responce'};
      }
    } catch (e) {
      print('categories Data Error :- $e');
    }
    return null;
  }
}
