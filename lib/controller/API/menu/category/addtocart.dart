// ignore_for_file: avoid_print, invalid_use_of_protected_member, non_constant_identifier_names, duplicate_ignore

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';

import '../../../../view/utils/app_json.dart';
import '../../../../view/utils/errorcode.dart';
import 'package:kohira/api/api_call.dart';

class Addtocart extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  final url = AppUrl.addtocart;

  Future<void> addtocartservice({
    String? jewelryid,
    String? qty,
    String? ringsize,
    String? metal_type,
    String? metal_stamp,
    String? sideDiaGrpId,
    required String tokan,
  }) async {
    try {
      isLoading.value = true;
      Get.dialog(
        Center(child: Lottie.asset(AppJson.loading2)),
        barrierDismissible: false,
      );

      print("Sending request to: $url");
      final body = {
        'jewelryid': jewelryid,
        'qty': qty,
        'ringsize': ringsize,
        'metal_type': metal_type,
        'metal_stamp': metal_stamp,
        'sideDiaGrpId': sideDiaGrpId,
      }..removeWhere((key, value) => value == null);

      print('Request body: $body');

      final responcse =
          await ApiCall.postRequest(url, data: body, useAuth: true);

      if (responcse != null) {
        data.value = jsonDecode(jsonEncode(responcse));
        print('Addtocart to cart data :-  $data');
        print('Request body: $body');
        ToastificationSuccess.Success(data.value['message']);

        if (data.value['success'] == false) {
          print(data.value['message']);
        }
      } else {
        throw {
          'Addtocart to cart data Error :- 200, $responcse',
          print('200, ${data.value['message']}'),
          handleHttpError(200),
        };
      }
    } catch (e) {
      print('Addtocart to cart data Error this :- $e');
      ToastificationError.Error('$e');
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }
}
