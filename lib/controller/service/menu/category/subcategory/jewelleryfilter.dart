// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../../modal/menu/category/subcategory/jewelleryfilter.dart';

class JewelleryFilterService {
  Future<JewelleryFilterModel?> fetchFilter() async {
    try {
      final url = AppUrl.jewelleryfilter;
      print('Sending request to: $url');
      final response = await DioClient.dio.get(
        url,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.data.toString());
        log('Jewellery = $jsonData');
        return JewelleryFilterModel.fromJson(jsonData);
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
