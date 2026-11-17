//counting items
// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../../view/utils/API_headers.dart';
import '../../../../view/utils/app_url.dart';
import '../../../../view/utils/app_constants.dart';
import '../../../../view/utils/widget/pop.dart';
import 'package:kohira/api/api_call.dart';

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

      final responses =
          await ApiCall.postRequest(url, data: body, useAuth: true);
      print('Sending request to: $url');
      print('Countingcart body :- $body');

      if (responses != null) {
        data.value = jsonDecode(jsonEncode(responses));
        log("CountCart data :- $data");
      } else {
        throw {
          'Fetchcart data Error This :- ${200}, ${responses}',
          print('CountCart data this :- ${200}, ${responses}'),
          ToastificationError.Error(
              "CountCart data this :- ${200}, ${responses}"),
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
