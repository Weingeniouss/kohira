// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/api/api_call.dart';

class Logout extends GetxController {
  var isLoading = false.obs;
  var isLoggedOut = false.obs;
  var logoutData = {}.obs;

  Future<void> logout() async {
    try {
      isLoading(true);
      final url = AppUrl.logout;
      print('Sending To Url :- $url');
      final response = await ApiCall.postRequest(url, useAuth: true);
      if (response != null) {
        logoutData.value = jsonDecode(jsonEncode(response));
        log('Logout Data :- ${logoutData.value}');
        isLoggedOut(true);
      } else {
        throw Exception('Logout failed: ${200}');
      }
    } catch (e) {
      print('Logout Error: $e');
      isLoggedOut(false);
    } finally {
      isLoading(false);
    }
  }
}
