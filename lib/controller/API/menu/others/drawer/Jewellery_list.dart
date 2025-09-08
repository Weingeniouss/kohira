
// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;

class JewelleryList extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> jewellerylist() async {
    try {
      isLoading.value = true;
      final url = Uri.parse(AppUrl.jewellery_filter);
      final response = await http.get(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters});

      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.body);
      } else {
        throw{
          'Error Jewllery List :- ${response.statusCode}, ${response.body}',
      };
    }
  }catch(e){
    log('Error Jewllery List :- $e');
    }finally{
    isLoading.value = false;
    }
  }
}