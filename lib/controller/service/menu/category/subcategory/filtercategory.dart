// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import '../../../../../modal/menu/category/subcategory/filtercategory.dart';
import '../../../../../view/utils/app_url.dart';
import 'package:kohira/api/api_call.dart';

class FilterCategoryService {
  Future<Filtercategory?> fetchFilter() async {
    try {
      final url = AppUrl.filtercategory;
      print('Sending request to :- $url');

      final response = await ApiCall.postRequest(url, useAuth: false);

      if (response != null) {
        final jsonData = json.decode(jsonEncode(response));
        log('FilterCategory $jsonData');
        return Filtercategory.fromJson(jsonData);
      } else {
        print('Error: ${200} - $response');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
