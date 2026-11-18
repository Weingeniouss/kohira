// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kohira/modal/menu/category/jewelleryDetail.dart';

import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/view/utils/widget/pop.dart';
import 'package:kohira/api/api_call.dart';

class JewellerydetailCall extends GetxController {
  var isLoading = false.obs;
  var detailModel = Rxn<JewelleryDetailModel>();
  var detailData = Rxn<JewelleryDetailData>();
  var data = {}.obs;

  Future<void> jewellerydetailservices({required String slug}) async {
    try {
      isLoading.value = true;
      final url = "${AppUrl.jewelleryDetail}/$slug";
      print("Sending request to: $url");
      final response = await ApiCall.getRequest(url, useAuth: false);

      if (response != null) {
        final decoded = jsonDecode(jsonEncode(response));
        data.value = decoded;
        detailModel.value = JewelleryDetailModel.fromJson(decoded);
        detailData.value = detailModel.value?.data;
        log('Jewellery detail :- $data');
      } else {
        ToastificationError.Error(
            "Jewellery detail Error :- ${200}, $response");
      }
    } catch (e) {
      ToastificationError.Error("Jewellery detail Error :- $e");
      print('Jewellery detail Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
