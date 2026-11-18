// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../../view/utils/app_url.dart';
import '../../../../view/utils/widget/pop.dart';
import 'package:kohira/api/api_call.dart';

class Deletcart extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future deletcartcall({
    required String id,
    required String jewelryid,
    String? diamondid,
  }) async {
    try {
      isLoading.value = true;

      final url = AppUrl.deletcart;
      final body = {
        'id': id,
        'jewelryid': jewelryid,
        'diamondid': diamondid,
      }..removeWhere((key, value) => value == null);

      print('Sending request to: $url');
      print('Deletcart sendingbody :- $body');

      final responses =
          await ApiCall.postRequest(url, data: body, useAuth: true);

      if (responses != null) {
        data.value = jsonDecode(jsonEncode(responses));
        log('Deletcart data :- $data');
      } else {
        throw {
          'Deletcart data Error This :- ${200}, $responses',
          print('Deletcart data this :- ${200}, $responses'),
          ToastificationError.Error(
              "CountCart data this :- ${200}, $responses"),
        };
      }
    } catch (e) {
      print("Deletcart data Error This :- $e");
      ToastificationError.Error("Deletcart data Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
