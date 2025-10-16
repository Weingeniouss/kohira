// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;

class Logout extends GetxController {
  var isLoading = false.obs;
  var isLoggedOut = false.obs;
  var logoutData = {}.obs;

  Future<void> logout() async {
    try {
      isLoading(true);
      final url = Uri.parse(AppUrl.logout);
      print('Sending To Url :- $url');
      final response = await http.post(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters, ApiHeaders.authorization: tokans});
      if (response.statusCode == 200 || response.statusCode == 201) {
        logoutData.value = jsonDecode(response.body);
        log('Logout Data :- ${logoutData.value}');
        isLoggedOut(true);
      } else {
        throw Exception('Logout failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Logout Error: $e');
      isLoggedOut(false);
    } finally {
      isLoading(false);
    }
  }
}