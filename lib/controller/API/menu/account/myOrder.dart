// ignore_for_file: avoid_print, invalid_use_of_protected_member, file_names

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';

import 'package:kohira/api/api_call.dart';

class MyOrderController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future myOrder() async {
    try {
      isLoading.value = true;
      final url = AppUrl.order;
      print("Sending Requset to :- $url");
      final responce = await ApiCall.getRequest(url, useAuth: true);

      if (responce != null) {
        data.value = jsonDecode(jsonEncode(responce));
        log("myOrder Details :- ${data.value}");
      } else {
        'myOrder Details Error This :- ${200}, ${responce}';
      }
    } catch (e) {
      print("myOrder Details Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
