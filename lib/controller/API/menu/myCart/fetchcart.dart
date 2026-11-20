// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kohira/view/utils/app_constants.dart';


import '../../../../view/utils/app_url.dart';
import 'package:kohira/api/api_call.dart';

class FetchcartCalling extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future fetchcartcall(
      {String? flag, String? qty, String? cart, String? type}) async {
    if (!islogin || tokans.isEmpty) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading.value = true;

      final url =
          '${AppUrl.cart}?flag=${flag ?? ''}&qty=${qty ?? ''}&cart=${cart ?? ''}&type=${type ?? ''}';
      print('Sending request to: $url');
      final responses = await ApiCall.getRequest(url, useAuth: true);

      if (responses != null) {
        if (responses is Map) {
          data.value = Map<String, dynamic>.from(responses);
        } else if (responses is String) {
          data.value = jsonDecode(jsonEncode(responses));
        } else {
          data.value = jsonDecode(jsonEncode(responses));
        }
        log('Fetchcart data :- $data');
      } else {
        throw {
          'Fetchcart data Error This :- ${200}, $responses',
          print('CountCart data this :- ${200}, $responses'),
        };
      }
    } catch (e) {
      print("Fetchcart data Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
