// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/app_constants.dart';

class CountController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future counting() async {
    try {
      isLoading.value = true;
      final url = Uri.parse(AppUrl.count);
      final responce = await http.get(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters, ApiHeaders.authorization: tokans});
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        data.value = jsonDecode(responce.body);
      } else {
        throw {'Counting Error :- ${responce.statusCode}, ${responce.body}'};
      }
    } catch (e) {
      print("Counting Error :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
