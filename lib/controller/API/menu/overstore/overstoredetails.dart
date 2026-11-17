// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/services/api_service.dart';

class OverStoreDetails extends GetxController {
  var isLoading = false.obs;
  var overStoreDetailsData = {}.obs;

  Future<void> getOverStoreDetails(String slug) async {
    final url = '${AppUrl.storedetails}/$slug';
    print('Sending to Url :- $url');
    try {
      isLoading.value = true;
      final response = await ApiService.getApi(url, useAuth: false);
      overStoreDetailsData.value = response;
      log("Response Data: $response");
    } catch (e) {
      print("Exception in getOverStoreDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
