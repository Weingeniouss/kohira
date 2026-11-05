// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/dio_client.dart';

class CountController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future counting() async {
    try {
      isLoading.value = true;
      final url = AppUrl.count;
      final responce = await DioClient.dio.get(
        url,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.authorization: tokans,
          },
        ),
      );
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        data.value = jsonDecode(responce.data.toString());
      } else {
        throw {'Counting Error :- ${responce.statusCode}, ${responce.data}'};
      }
    } catch (e) {
      print("Counting Error :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
