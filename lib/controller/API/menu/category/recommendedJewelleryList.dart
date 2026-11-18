// ignore_for_file: avoid_print, file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kohira/modal/menu/category/recommendedJewelleryList.dart';

import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/view/utils/widget/pop.dart';
import 'package:kohira/api/api_call.dart';

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
      final responses = await ApiCall.getRequest(url, useAuth: false);

      if (responses != null) {
        final decoded = jsonDecode(jsonEncode(responses));
        data.value = decoded;
        model.value = RecommendedJewelleryListModel.fromJson(decoded);
        freqBoughtItems.value = model.value?.freqBoughtItems ?? [];
        matchingItems.value = model.value?.matchingItems ?? [];
        log('recommendedjewellerylistFuction data :- $data');
      } else {
        ToastificationError.Error(
            'RecommendedjewellerylistFuction data Error :- $responses, ${200}');
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
