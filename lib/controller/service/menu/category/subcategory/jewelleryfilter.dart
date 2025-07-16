// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import '../../../../../modal/menu/category/subcategory/jewelleryfilter.dart';

class JewelleryFilterService {
  Future<JewelleryFilterModel?> fetchFilter() async {
    try {
      final url = Uri.parse(AppUrl.jewelleryfilter);
      print('Sending request to: $url');
      final response = await http.get(url, headers: {ApiHeaders.heading : ApiHeaders.peramitters});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        log('Jewellery = $jsonData');
        return JewelleryFilterModel.fromJson(jsonData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}