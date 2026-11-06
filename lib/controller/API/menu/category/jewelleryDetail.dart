// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/modal/menu/category/jewelleryDetail.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import 'package:kohira/view/utils/widget/pop.dart';

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
      final response = await DioClient.dio.get(
        url,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.data.toString());
        data.value = decoded;
        detailModel.value = JewelleryDetailModel.fromJson(decoded);
        detailData.value = detailModel.value?.data;
        log('Jewellery detail :- $data');
      } else {
        ToastificationError.Error(
            "Jewellery detail Error :- ${response.statusCode}, ${response.data}");
      }
    } catch (e) {
      ToastificationError.Error("Jewellery detail Error :- $e");
      print('Jewellery detail Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
