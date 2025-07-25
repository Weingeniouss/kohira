
// ignore_for_file: avoid_print, invalid_use_of_protected_member, file_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/appconstants.dart';
import 'package:kohira/view/utils/errorcode.dart';

class MyOrderController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future myOrder() async {
    try {
      isLoading.value = true;
      final url = Uri.parse(AppUrl.order);
      print("Sending Requset to :- $url");
      final responce = await http.get(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters, ApiHeaders.authorization: tokans});

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        data.value = jsonDecode(responce.body);
        log("myOrder Details :- ${data.value}");
      } else {
        'myOrder Details Error This :- ${responce.statusCode}, ${responce.body}';
        handleHttpError(responce.statusCode);
      }
    } catch (e) {
      print("myOrder Details Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
