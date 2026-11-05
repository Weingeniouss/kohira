// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';

class Logout extends GetxController {
  var isLoading = false.obs;
  var isLoggedOut = false.obs;
  var logoutData = {}.obs;

  Future<void> logout() async {
    try {
      isLoading(true);
      final url = AppUrl.logout;
      print('Sending To Url :- $url');
      final response = await DioClient.dio.post(
        url,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.authorization: tokans
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logoutData.value = jsonDecode(response.data.toString());
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
