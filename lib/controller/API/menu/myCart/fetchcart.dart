// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../view/utils/app_url.dart';

class FetchcartCalling extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future fetchcartcall({String? flag, String? qty, String? cart, String? type}) async {
    try {
      isLoading.value = true;

      final url = '${AppUrl.cart}?flag=${flag ?? ''}&qty=${qty ?? ''}&cart=${cart ?? ''}&type=${type ?? ''}';
      print('Sending request to: $url');
      final responses = await DioClient.dio.get(
        url,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.authorization: tokans,
          },
        ),
      );

      if (responses.statusCode == 200 || responses.statusCode == 201) {
        data.value = jsonDecode(responses.data.toString());
        log('Fetchcart data :- $data');
      } else {
        throw {
          'Fetchcart data Error This :- ${responses.statusCode}, ${responses.data}',
          print('CountCart data this :- ${responses.statusCode}, ${responses.data}'),
        };
      }
    } catch (e) {
      print("Fetchcart data Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
