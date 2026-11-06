// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kohira/view/utils/dio_client.dart';

import '../../../../../modal/menu/category/subcategory/filtercategory.dart';
import '../../../../../view/utils/API_headers.dart';
import '../../../../../view/utils/app_url.dart';

class FilterCategoryService {
  Future<Filtercategory?> fetchFilter() async {
    try {
      final url = AppUrl.filtercategory;
      print('Sending request to :- $url');

      final response = await DioClient.dio.post(
        url,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.data.toString());
        log('FilterCategory $jsonData');
        return Filtercategory.fromJson(jsonData);
      } else {
        print('Error: ${response.statusCode} - ${response.data}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
