//counting items
// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../view/utils/API_headers.dart';
import '../../../../view/utils/app_url.dart';
import '../../../../view/utils/app_constants.dart';
import '../../../../view/utils/widget/pop.dart';

class CountCart extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future countcardcall({
    required String jewelryid,
    required String qty,
    String? ringsize,
    String? metal_type,
    String? metal_stamp,
    String? sideDiaGrpId,
  }) async {
    try {
      isLoading.value = true;

      final url = AppUrl.countcart;
      final body = {
        if (jewelryid != null) 'jewelryid': jewelryid,
        if (qty != null) 'qty': qty.toString(),
        if (ringsize != null) 'ringsize': ringsize,
        if (metal_type != null) 'metal_type': metal_type,
        if (metal_stamp != null) 'metal_stamp': metal_stamp,
        if (sideDiaGrpId != null) 'sideDiaGrpId': sideDiaGrpId,
      }..removeWhere((key, value) => value == null);

      final responses = await DioClient.dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.authorization: tokans,
          },
        ),
      );
      print('Sending request to: $url');
      print('Countingcart body :- $body');

      if (responses.statusCode == 200 || responses.statusCode == 201) {
        data.value = jsonDecode(responses.data.toString());
        log("CountCart data :- $data");
      } else {
        throw {
          'Fetchcart data Error This :- ${responses.statusCode}, ${responses.data}',
          print('CountCart data this :- ${responses.statusCode}, ${responses.data}'),
          ToastificationError.Error("CountCart data this :- ${responses.statusCode}, ${responses.data}"),
        };
      }
    } catch (e) {
      print("Fetchcart data Error This :- $e");
      ToastificationError.Error("Fetchcart data Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
