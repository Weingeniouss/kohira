// ignore_for_file: avoid_print, invalid_use_of_protected_member, file_names

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/dio_client.dart';

class MyOrderController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future myOrder() async {
    try {
      isLoading.value = true;
      final url = AppUrl.order;
      print("Sending Requset to :- $url");
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
        log("myOrder Details :- ${data.value}");
      } else {
        'myOrder Details Error This :- ${responce.statusCode}, ${responce.data}';
      }
    } catch (e) {
      print("myOrder Details Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
