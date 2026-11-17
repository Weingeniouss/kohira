// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:kohira/view/utils/app_url.dart';

import '../../../../../modal/menu/category/subcategory/jewelleryfilter.dart';
import 'package:kohira/api/api_call.dart';

class JewelleryFilterService {
  Future<JewelleryFilterModel?> fetchFilter() async {
    try {
      final url = AppUrl.jewelleryfilter;
      print('Sending request to: $url');
      final response = await ApiCall.getRequest(url, useAuth: false);

      if (response != null) {
        final jsonData = json.decode(jsonEncode(response));
        log('Jewellery = $jsonData');
        return JewelleryFilterModel.fromJson(jsonData);
      } else {
        print('Error: ${200} - ${response}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
