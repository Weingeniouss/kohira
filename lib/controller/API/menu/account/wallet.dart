// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';

import 'package:kohira/api/api_call.dart';

class WalletController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future wallet() async {
    try {
      isLoading.value = true;
      final url = AppUrl.wallet;
      print("Sending Request to :- $url");

      final responce = await ApiCall.getRequest(url, useAuth: true);

      if (responce != null) {
        data.value = jsonDecode(jsonEncode(responce));
        log("Wallet :- ${data.value}");
      } else {
        'Wallet Error this :- ${200}, ${responce}';
      }
    } catch (e) {
      print("'Wallet Error this :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
