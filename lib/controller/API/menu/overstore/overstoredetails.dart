// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import '../../../../view/utils/app_constants.dart';

class OverStoreDetails extends GetxController {
  var isLoading = false.obs;
  var overStoreDetailsData = {}.obs;

  Future<void> getOverStoreDetails(String slug) async {
    final url = Uri.parse('${AppUrl.storedetails}/$slug').toString();
    print('Sending to Url :- $url');
    try {
      isLoading.value = true;
      final response = await dio.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        overStoreDetailsData.value = response.data;
        log("Response Data: ${response.data}");
      } else {
        throw{
          "statusCode": response.statusCode,
          "message": response.statusMessage,
        };
      }
    } catch (e) {
      print("Exception in getOverStoreDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
