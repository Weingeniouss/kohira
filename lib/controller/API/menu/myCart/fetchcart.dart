// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/appconstants.dart';
import 'package:kohira/view/utils/widget/pop.dart';

import '../../../../view/utils/app_url.dart';
import '../../../../view/utils/errorcode.dart';

//Fetch items
class FetchcartCalling extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future fetchcartcall() async {
    try {
      isLoading.value = true;

      final url = Uri.parse(AppUrl.cart);
      print('Sending request to: $url');
      final responses = await http.get(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters, ApiHeaders.authorization: tokans});

      if (responses.statusCode == 200 || responses.statusCode == 201) {
        data.value = jsonDecode(responses.body);
        log('Fetchcart data :- $data');
        ToastificationSuccess.Success(data['message']);
      } else {
        throw {
          'Fetchcart data Error This :- ${responses.statusCode}, ${responses.body}',
          print('CountCart data this :- ${responses.statusCode}, ${responses.body}'),
          handleHttpError(responses.statusCode)
        };
      }
    } catch (e) {
      print("Fetchcart data Error This :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
