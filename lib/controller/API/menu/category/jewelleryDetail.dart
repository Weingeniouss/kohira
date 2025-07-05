// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/widget/pop.dart';

class JewellerydetailCall extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> jewellerydetailservices({required String slug}) async {
    try {
      isLoading.value = true;
      final url = Uri.parse("${AppUrl.jewelleryDetail}/$slug");
      final response = await http.get(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters});

      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.body);
        log('Jewellerydetail :- $data');
      } else {
        'Jewellerydetail Error :- ${response.statusCode}, ${response.body}';
        ToastificationError.Error("Jewellerydetail Error :- ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      ToastificationError.Error("Jewellerydetail Error :- $e");
      print('Jewellerydetail Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
