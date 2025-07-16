// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import '../../../../../modal/menu/category/subcategory/filtercategory.dart';
import '../../../../../view/utils/API_headers.dart';
import '../../../../../view/utils/app_url.dart';
import 'package:http/http.dart' as http;

class FilterCategoryService {
  Future<Filtercategory?> fetchFilter() async {
    try {
      final url = Uri.parse(AppUrl.filtercategory);
      print('Sending request to :- $url');

      final response = await http.post(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        log('FilterCategory $jsonData');
        return Filtercategory.fromJson(jsonData);
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