// ignore_for_file: avoid_print, file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import 'package:kohira/view/utils/widget/pop.dart';

class Recommendedjewellerylist extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> recommendedjewellerylistFuction({required String slug}) async {
    try {
      isLoading.value = true;

      final url = '${AppUrl.recommendedJewelleryList}/$slug';
      print("Sending request to: $url");
      final responses = await DioClient.dio.get(
        url,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );

      if (responses.statusCode == 200 || responses.statusCode == 201) {
        data.value = jsonDecode(responses.data.toString());
        log('recommendedjewellerylistFuction data :- $data');
      } else {
        throw {
          'RecommendedjewellerylistFuction data Error :- ${responses.data}, ${responses.statusCode}',
          ToastificationError.Error('RecommendedjewellerylistFuction data Error :- ${responses.data}, ${responses.statusCode}'),
        };
      }
    } catch (e) {
      print('RecommendedjewellerylistFuction data Error this :- $e');
      ToastificationError.Error('RecommendedjewellerylistFuction data Error this :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
