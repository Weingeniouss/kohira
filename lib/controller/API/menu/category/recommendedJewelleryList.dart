// ignore_for_file: avoid_print, file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/modal/menu/category/recommendedJewelleryList.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import 'package:kohira/view/utils/widget/pop.dart';

class Recommendedjewellerylist extends GetxController {
  var isLoading = false.obs;
  var model = Rxn<RecommendedJewelleryListModel>();
  var freqBoughtItems = <RecommendedItem>[].obs;
  var matchingItems = <RecommendedItem>[].obs;
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
        final decoded = jsonDecode(responses.data.toString());
        data.value = decoded;
        model.value = RecommendedJewelleryListModel.fromJson(decoded);
        freqBoughtItems.value = model.value?.freqBoughtItems ?? [];
        matchingItems.value = model.value?.matchingItems ?? [];
        log('recommendedjewellerylistFuction data :- $data');
      } else {
        ToastificationError.Error(
            'RecommendedjewellerylistFuction data Error :- ${responses.data}, ${responses.statusCode}');
      }
    } catch (e) {
      print('RecommendedjewellerylistFuction data Error this :- $e');
      ToastificationError.Error(
          'RecommendedjewellerylistFuction data Error this :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
