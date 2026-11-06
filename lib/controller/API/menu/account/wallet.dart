// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/dio_client.dart';

class WalletController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future wallet() async {
    try {
      isLoading.value = true;
      final url = AppUrl.wallet;
      print("Sending Request to :- $url");

      final responce = await DioClient.dio.get(
        url,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.authorization: tokans
          },
        ),
      );

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        data.value = jsonDecode(responce.data.toString());
        log("Wallet :- ${data.value}");
      } else {
        'Wallet Error this :- ${responce.statusCode}, ${responce.data}';
      }
    } catch (e) {
      print("'Wallet Error this :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
